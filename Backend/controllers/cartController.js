import asyncWrapper from "../middleware/asyncWrapper.js";
import Cart from "../models/cartModel.js";
import Product from "../models/productModel.js";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import {
  PRODUCT_NOT_FOUND,
  CART_NOT_FOUND,
  ITEM_NOT_IN_CART,
  stockExceeded,
  ITEM_ADDED_TO_CART,
  ITEM_REMOVED,
  ITEM_REMOVED_FROM_CART,
  CART_UPDATED,
  CART_CLEARED,
} from "../utils/messages.js";

const isInStock = (product, newQuantity) => {
  if (!product) {
    throw new AppError(PRODUCT_NOT_FOUND, 404);
  }

  if (newQuantity > product.stock) {
    throw new AppError(stockExceeded(product.stock), 400);
  }
};

export const addProductToCart = asyncWrapper(async (req, res, next) => {
  const productId = req.body.productId;
  const quantity = req.body.quantity || 1;

  const product = req.product;
  let cart = await Cart.findOne({ user: req.user.id });

  let newQuantity = quantity;
  let productIndex = -1;

  if (cart) {
    productIndex = cart.cartItems.findIndex((item) =>
      item.product.equals(productId),
    );
    if (productIndex > -1) {
      newQuantity += cart.cartItems[productIndex].quantity;
    }
  }

  isInStock(product, newQuantity);

  if (!cart) {
    cart = await Cart.create({
      user: req.user.id,
      cartItems: [
        { product: productId, price: product.price, quantity: quantity },
      ],
    });
  } else {
    if (productIndex > -1) {
      cart.cartItems[productIndex].quantity = newQuantity;
      cart.cartItems[productIndex].price = product.price;
    } else {
      cart.cartItems.push({
        product: productId,
        price: product.price,
        quantity: quantity,
      });
    }
    await cart.save();
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: ITEM_ADDED_TO_CART,
    data: {
      cart: cart,
    },
  });
});

export const getUserCart = asyncWrapper(async (req, res, next) => {
  const cart = await Cart.findOne({ user: req.user.id }).populate({
    path: "cartItems.product",
    select: "name images price discount",
  });

  if (!cart) {
    return next(new AppError(CART_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: cart.cartItems.length,
    data: {
      cart: cart,
    },
  });
});

export const updateCartItemQuantity = asyncWrapper(async (req, res, next) => {
  const { quantity } = req.body;

  const cart = await Cart.findOne({ user: req.user.id });
  if (!cart) {
    return next(new AppError(CART_NOT_FOUND, 404));
  }

  const productIndex = cart.cartItems.findIndex((item) =>
    item._id.equals(req.params.id),
  );

  if (productIndex === -1) {
    return next(new AppError(ITEM_NOT_IN_CART, 404));
  }

  if (quantity <= 0) {
    cart.cartItems.splice(productIndex, 1);
    await cart.save();

    return res.status(200).json({
      success: true,
      status: httpStatus.SUCCESS,
      message: ITEM_REMOVED,
      data: {
        cart: cart,
      },
    });
  }

  const { product: productId } = cart.cartItems[productIndex];
  const product = await Product.findById(productId);

  if (!product) {
    cart.cartItems.splice(productIndex, 1);
    await cart.save();

    return next(new AppError(ITEM_REMOVED_FROM_CART, 404));
  }

  isInStock(product, quantity);

  cart.cartItems[productIndex].quantity = quantity;
  cart.cartItems[productIndex].price = product.price;
  await cart.save();

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: CART_UPDATED,
    data: {
      cart: cart,
    },
  });
});

export const removeCartItem = asyncWrapper(async (req, res, next) => {
  const cart = await Cart.findOne({ user: req.user.id });

  if (!cart) {
    return next(new AppError(CART_NOT_FOUND, 404));
  }

  cart.cartItems = cart.cartItems.filter(
    (item) => !item._id.equals(req.params.id),
  );

  await cart.save();

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: ITEM_REMOVED,
    data: {
      cart: cart,
    },
  });
});

export const clearCart = asyncWrapper(async (req, res, next) => {
  await Cart.findOneAndDelete({ user: req.user.id });

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: CART_CLEARED,
    data: null,
  });
});
