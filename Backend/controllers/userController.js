import bcrypt from "bcryptjs";
import asyncWrapper from "../middleware/asyncWrapper.js";
import User from "../models/userModel.js";
import httpStatus from "../utils/httpStatus.js";
import {
  ACCOUNT_DELETE_PERMISSION,
  ACCOUNT_DELETED,
  INCORRECT_CURRENT_PASSWORD,
  PASSWORD_UPDATED,
  PROFILE_UPDATED,
  USER_NOT_FOUND,
} from "../utils/messages.js";
import AppError from "../utils/AppError.js";
import { generateToken } from "./authController.js";

export const getUser = asyncWrapper(async (req, res, next) => {
  const user = await User.findById(req.user.id);

  if (!user) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      user: user,
    },
  });
});

export const getAllUsers = asyncWrapper(async (req, res, next) => {
  const users = await User.find().sort("-createdAt");

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: users.length,
    data: {
      users: users,
    },
  });
});

export const getUserById = asyncWrapper(async (req, res, next) => {
  const user = await User.findById(req.params.id);

  if (!user) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      user: user,
    },
  });
});

export const updateUser = asyncWrapper(async (req, res, next) => {
  const filteredBody = {};

  if (req.body.fullname) {
    filteredBody.fullname = req.body.fullname;
  }

  if (req.body.email) {
    filteredBody.email = req.body.email;
  }

  const updatedUser = await User.findByIdAndUpdate(req.user.id, filteredBody, {
    returnDocument: "after",
    runValidators: true,
  });

  if (!updatedUser) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  let token;
  if (req.body.email) {
    token = generateToken(updatedUser);
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: PROFILE_UPDATED,
    token,
    data: {
      user: updatedUser,
    },
  });
});

export const updatePassword = asyncWrapper(async (req, res, next) => {
  const { currentPassword, newPassword, passwordConfirm } = req.body;

  const user = await User.findById(req.user.id).select("+password");

  const isCorrect = await bcrypt.compare(currentPassword, user.password);
  if (!isCorrect) {
    return next(new AppError(INCORRECT_CURRENT_PASSWORD, 401));
  }

  user.password = newPassword;
  user.passwordConfirm = passwordConfirm;
  await user.save();

  const token = generateToken(user);

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: PASSWORD_UPDATED,
    token,
    data: null,
  });
});

export const deleteUser = asyncWrapper(async (req, res, next) => {
  const userId = req.params.id || req.user.id;

  if (req.params.id && req.user.role !== "admin") {
    return next(new AppError(ACCOUNT_DELETE_PERMISSION, 403));
  }

  const user = await User.findByIdAndDelete(userId);

  if (!user) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: ACCOUNT_DELETED,
    data: null,
  });
});
