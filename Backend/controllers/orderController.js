import asyncWrapper from "../middleware/asyncWrapper.js";
import ApiFeatures from "../utils/ApiFeatures.js";
import mongoose from "mongoose";
import Cart from "../models/cartModel.js";
import Order from "../models/orderModel.js";
import Product from "../models/productModel.js";
import User from "../models/userModel.js";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import sendEmail from "../utils/sendEmail.js";
import {
  ORDER_ALREADY_CANCELLED,
  ORDER_ALREADY_DELIVERED,
  ORDER_CANNOT_CANCEL,
  ORDER_CANNOT_DELIVER,
  ORDER_CART_NOT_AUTHORIZED,
  ORDER_CART_NOT_FOUND,
  ORDER_CREATED,
  ORDER_CANCELLED,
  ORDER_MARKED_DELIVERED,
  ORDER_NOT_AUTHORIZED,
  ORDER_NOT_FOUND,
  PRODUCT_NOT_FOUND,
  stockExceeded,
  EMAIL_SENDING_ERROR,
} from "../utils/messages.js";
import { updateOrderStatusValidator } from "../utils/validators/orderValidator.js";

export const createOrder = asyncWrapper(async (req, res, next) => {
  const { shippingAddress, paymentMethodType = "cash" } = req.body;

  const cart = await Cart.findOne({ user: req.user.id });
  if (!cart || cart.cartItems.length === 0) {
    return next(new AppError(ORDER_CART_NOT_FOUND, 404));
  }

  const productIds = cart.cartItems.map((item) => item.product);
  const products = await Product.find({ _id: { $in: productIds } }).select(
    "price stock",
  );

  const productById = new Map(
    products.map((product) => [product._id.toString(), product]),
  );

  const orderItems = cart.cartItems.map((item) => {
    const product = productById.get(item.product.toString());

    if (!product) {
      throw new AppError(PRODUCT_NOT_FOUND, 404);
    }

    if (item.quantity > product.stock) {
      throw new AppError(stockExceeded(product.stock), 400);
    }

    return {
      product: item.product,
      quantity: item.quantity,
      price: product.price,
    };
  });

  const totalOrderPrice = orderItems.reduce(
    (sum, it) => sum + it.price * it.quantity,
    0,
  );

  const isCardPayment = paymentMethodType === "card";

  const session = await mongoose.startSession();
  let order;
  try {
    await session.withTransaction(async () => {
      order = await Order.create(
        [
          {
            user: req.user.id,
            cartItems: orderItems,
            shippingAddress,
            totalOrderPrice,
            paymentMethodType: paymentMethodType,
            isPaid: isCardPayment,
            paidAt: isCardPayment ? Date.now() : undefined,
          },
        ],
        { session },
      );

      const bulkOption = orderItems.map((item) => ({
        updateOne: {
          filter: { _id: item.product, stock: { $gte: item.quantity } },
          update: { $inc: { stock: -item.quantity, sold: +item.quantity } },
        },
      }));

      const bulkResult = await Product.bulkWrite(bulkOption, { session });

      if (bulkResult.modifiedCount !== orderItems.length) {
        throw new AppError(ORDER_ITEMS_UNAVAILABLE, 400);
      }

      await Cart.findByIdAndDelete(cart._id, { session });
    });
  } catch (err) {
    return next(err);
  } finally {
    session.endSession();
  }

  const populatedOrder = await Order.findById(order[0]._id).populate({
    path: "cartItems.product",
    select: "name thumbnail price",
  });

  const user = await User.findById(req.user.id).select("fullname email");

  if (user) {
    const itemLines = populatedOrder.cartItems
      .map((item) => `  - ${item.product.name} x${item.quantity}  ($${item.price.toFixed(2)} each)`)
      .join("\n");

    const message = `Hello ${user.fullname},\n\nThank you for your purchase on Nexora! \n\nOrder Summary:\n${itemLines}\n\nTotal: $${populatedOrder.totalOrderPrice.toFixed(2)}\nPayment: ${populatedOrder.paymentMethodType}\n\nWe will notify you once your order ships.\n\nBest regards,\nThe Nexora Team`;

    try {
      await sendEmail({
        email: user.email,
        subject: "Nexora - Thank you for your purchase!",
        message,
      });
    } catch (err) {
      console.error(EMAIL_SENDING_ERROR);

    }
  }

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: ORDER_CREATED,
    data: {
      order: populatedOrder,
    },
  });
});

export const getAllOrders = asyncWrapper(async (req, res, next) => {
  const query = Order.find()
    .populate({ path: "user", select: "fullname email" })
    .populate({ path: "cartItems.product", select: "name thumbnail price" });

  const features = new ApiFeatures(query, req.query)
    .filter()
    .sort()
    .limitFields()
    .paginate();

  const orders = await features.mongooseQuery;

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: orders.length,
    data: {
      orders: orders,
    },
  });
});

export const getUserOrders = asyncWrapper(async (req, res, next) => {
  const orders = await Order.find({ user: req.user.id })
    .sort("-createdAt")
    .populate({ path: "cartItems.product", select: "name thumbnail price" });

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: orders.length,
    data: {
      orders: orders,
    },
  });
});

export const getOrderByID = asyncWrapper(async (req, res, next) => {
  const order = await Order.findById(req.params.id)
    .populate({ path: "user", select: "fullname email" })
    .populate({
      path: "cartItems.product",
      select: "name thumbnail price",
    });

  if (!order) {
    return next(new AppError(ORDER_NOT_FOUND, 404));
  }

  if (!order.user.equals(req.user.id) && req.user.role !== "admin") {
    return next(new AppError(ORDER_NOT_AUTHORIZED, 403));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      order: order,
    },
  });
});

export const updateOrderStatus = asyncWrapper(async (req, res, next) => {
  const { status } = req.body;
  const order = await Order.findById(req.params.id);

  if (!order) {
    return next(new AppError(ORDER_NOT_FOUND, 404));
  }

  if (order.status === "canceled") {
    return next(new AppError(ORDER_CANNOT_DELIVER, 400));
  }

  const from = order.status;
  const to = status;

  const allowed = [
    from === "pending" && to === "shipped",
    from === "pending" && to === "delivered",
    from === "shipped" && to === "delivered",
  ].some(Boolean);

  if (!allowed) {
    return next(new AppError(ORDER_INVALID_TRANSITION, 400));
  }

  if (to === "shipped") {
    if (order.status === "shipped") {
      return next(new AppError(ORDER_ALREADY_SHIPPED, 400));
    }

    order.status = "shipped";
    order.shippedAt = Date.now();
  }

  if (to === "delivered") {
    if (order.status === "delivered") {
      return next(new AppError(ORDER_ALREADY_DELIVERED, 400));
    }

    order.status = "delivered";
    order.deliveredAt = Date.now();
  }

  const updatedOrder = await order.save();

  const user = await User.findById(order.user).select("fullname email");
  if (user) {
    const statusLabels = {
      pending: "Pending",
      shipped: "Shipped",
      delivered: "Delivered",
    };

    const message = `Hello ${user.fullname},\n\nGreat news! Your Nexora order status has been updated.\n\nNew status: ${statusLabels[updatedOrder.status]}\nOrder total: $${updatedOrder.totalOrderPrice.toFixed(2)}\n\nThank you for shopping with us!\n\nBest regards,\nThe Nexora Team`;

    try {
      await sendEmail({
        email: user.email,
        subject: `Nexora - Your order has been ${updatedOrder.status}`,
        message,
      });
    } catch (err) {
      console.error(EMAIL_SENDING_ERROR);

    }
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      order: updatedOrder,
    },
  });
});

export const cancelOrder = asyncWrapper(async (req, res, next) => {
  const order = await Order.findById(req.params.id);

  if (!order) {
    return next(new AppError(ORDER_NOT_FOUND, 404));
  }

  if (!order.user.equals(req.user.id) && req.user.role !== "admin") {
    return next(new AppError(ORDER_NOT_AUTHORIZED, 403));
  }

  if (order.status === "canceled") {
    return next(new AppError(ORDER_ALREADY_CANCELLED, 400));
  }

  if (order.status === "shipped" || order.status === "delivered") {
    return next(new AppError(ORDER_CANNOT_CANCEL, 400));
  }

  const session = await mongoose.startSession();
  let updatedOrder;

  try {
    await session.withTransaction(async () => {
      const bulkOption = order.cartItems.map((item) => ({
        updateOne: {
          filter: { _id: item.product },
          update: { $inc: { stock: item.quantity, sold: -item.quantity } },
        },
      }));

      await Product.bulkWrite(bulkOption, { session });

      order.status = "canceled";
      order.canceledAt = Date.now();
      updatedOrder = await order.save({ session });
    });
  } catch (err) {
    return next(err);
  } finally {
    session.endSession();
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: ORDER_CANCELLED,
    data: {
      order: updatedOrder,
    },
  });
});
