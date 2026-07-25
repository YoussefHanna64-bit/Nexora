import asyncWrapper from "../middleware/asyncWrapper.js";
import Feedback from "../models/feedbackModel.js";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import { FEEDBACK_NOT_FOUND } from "../utils/messages.js";

export const createFeedback = asyncWrapper(async (req, res, next) => {
  const feedback = await Feedback.create({
    user: req.user.id,
    type: req.body.type,
    message: req.body.message,
  });

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      feedback: feedback,
    },
  });
});

export const getAllFeedbacks = asyncWrapper(async (req, res, next) => {
  const feedbacks = await Feedback.find()
    .sort("-createdAt")
    .populate("user", "fullname email profileImage");

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: feedbacks.length,
    data: {
      feedbacks: feedbacks,
    },
  });
});

export const getFeedbackById = asyncWrapper(async (req, res, next) => {
  const feedback = await Feedback.findById(req.params.id).populate(
    "user",
    "fullname email profileImage",
  );

  if (!feedback) {
    return next(new AppError(FEEDBACK_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      feedback: feedback,
    },
  });
});

export const updateFeedbackStatus = asyncWrapper(async (req, res, next) => {
  const feedback = await Feedback.findByIdAndUpdate(
    req.params.id,
    { status: req.body.status },
    { returnDocument: "after", runValidators: true },
  ).populate("user", "fullname email profileImage");

  if (!feedback) {
    return next(new AppError(FEEDBACK_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      feedback: feedback,
    },
  });
});
