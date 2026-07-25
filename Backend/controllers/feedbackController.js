import asyncWrapper from "../middleware/asyncWrapper.js";
import Feedback from "../models/feedbackModel.js";
import User from "../models/userModel.js";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import sendEmail from "../utils/sendEmail.js";
import { FEEDBACK_NOT_FOUND, EMAIL_SENDING_ERROR } from "../utils/messages.js";

export const createFeedback = asyncWrapper(async (req, res, next) => {
  const feedback = await Feedback.create({
    user: req.user.id,
    type: req.body.type,
    message: req.body.message,
  });

  const user = await User.findById(req.user.id).select("fullname email");

  if (user) {
    const message = `Hello ${user.fullname},\n\nThank you for reaching out to Nexora!\n\nWe have received your ${feedback.type} and our team will review it shortly.\n\nYour message:\n"${feedback.message}"\n\nWe appreciate your feedback and will get back to you as soon as possible.\n\nBest regards,\nThe Nexora Team`;

    try {
      await sendEmail({
        email: user.email,
        subject: "Nexora - We received your feedback",
        message,
      });
    } catch (err) {
      console.error(EMAIL_SENDING_ERROR);
    }
  }

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

  if (feedback.user && feedback.user.email) {
    const statusLabels = {
      pending: "Pending Review",
      reviewed: "Reviewed",
      resolved: "Resolved",
    };

    const message = `Hello ${feedback.user.fullname},\n\nThe status of your feedback on ${feedback.type} has been updated.\n\nNew status: ${statusLabels[feedback.status]}\n\nYour message:\n"${feedback.message}"\n\nThank you for helping us improve Nexora!\n\nBest regards,\nThe Nexora Team`;

    try {
      await sendEmail({
        email: feedback.user.email,
        subject: `Nexora - Your feedback on ${feedback.type} has been ${feedback.status}`,
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
      feedback: feedback,
    },
  });
});
