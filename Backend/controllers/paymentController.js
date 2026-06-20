import Stripe from "stripe";
import Cart from "../models/cartModel.js";
import asyncWrapper from "../middleware/asyncWrapper.js";
import AppError from "../utils/AppError.js";
import { ORDER_CART_NOT_FOUND } from "../utils/messages.js";
import httpStatus from "../utils/httpStatus.js";

export const createPaymentIntent = asyncWrapper(async (req, res, next) => {
  const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);

  const cart = await Cart.findOne({ user: req.user.id });

  if (!cart || cart.cartItems.length === 0) {
    return next(new AppError(ORDER_CART_NOT_FOUND, 404));
  }

  const amountInCents = Math.round(cart.totalCartPrice * 100);

  const paymentIntent = await stripe.paymentIntents.create({
    amount: amountInCents,
    currency: "usd",
    metadata: {
      userId: req.user.id.toString(),
      cartId: cart._id.toString(),
    },
  });

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      clientSecret: paymentIntent.client_secret,
    },
  });
});
