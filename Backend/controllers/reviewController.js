import asyncWrapper from "../middleware/asyncWrapper.js";
import Review from "../models/reviewModel.js";
import Order from "../models/orderModel.js";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import {
  ALREADY_REVIEWED_PRODUCT,
  ONLY_DELIVERED_PRODUCTS_REVIEWABLE,
  REVIEW_DELETED,
  REVIEW_NOT_FOUND,
  REVIEW_SUBMITTED,
  REVIEW_UPDATED,
  UNAUTHORIZED_UPDATE_REVIEW,
} from "../utils/messages.js";

export const createReview = asyncWrapper(async (req, res, next) => {
  const { productId, rating, comment } = req.body;
  const userId = req.user.id;

  const isPurchasedAndDelivered = await Order.findOne({
    user: userId,
    status: "delivered",
    "cartItems.product": productId,
  });

  if (!isPurchasedAndDelivered) {
    return next(new AppError(ONLY_DELIVERED_PRODUCTS_REVIEWABLE, 403));
  }

  const isReviewExist = await Review.findOne({
    user: userId,
    product: productId,
  });

  if (isReviewExist) {
    return next(new AppError(ALREADY_REVIEWED_PRODUCT, 400));
  }

  const review = await Review.create({
    user: userId,
    product: productId,
    rating,
    comment,
  });

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: REVIEW_SUBMITTED,
    data: {
      review: review,
    },
  });
});

export const getAllProductReviews = asyncWrapper(async (req, res, next) => {
  const { productId } = req.params;

  const reviews = await Review.find({
    product: productId,
    comment: { $exists: true, $ne: "" },
  });

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: reviews.length,
    data: {
      reviews: reviews,
    },
  });
});

export const updateReview = asyncWrapper(async (req, res, next) => {
  const { id } = req.params;

  let review = await Review.findById(id);

  if (!review) {
    return next(new AppError(REVIEW_NOT_FOUND, 404));
  }

  if (review.user._id.toString() !== req.user.id.toString()) {
    return next(new AppError(UNAUTHORIZED_UPDATE_REVIEW, 403));
  }

  review = await Review.findByIdAndUpdate(id, req.body, {
    returnDocument: "after",
    runValidators: true,
  });

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: REVIEW_UPDATED,
    data: {
      review: review,
    },
  });
});

export const deleteReview = asyncWrapper(async (req, res, next) => {
  const { id } = req.params;

  const review = await Review.findById(id);

  if (!review) {
    return next(new AppError(REVIEW_NOT_FOUND, 404));
  }

  if (review.user._id.toString() !== req.user.id.toString()) {
    return next(new AppError(UNAUTHORIZED_UPDATE_REVIEW, 403));
  }

  await Review.findByIdAndDelete(id);

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: REVIEW_DELETED,
    data: null,
  });
});
