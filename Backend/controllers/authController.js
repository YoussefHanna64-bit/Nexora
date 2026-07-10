import asyncWrapper from "../middleware/asyncWrapper.js";
import User from "../models/userModel.js";
import jwt from "jsonwebtoken";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import {
  EMAIL_SENDING_ERROR,
  INCORRECT_CREDENTIALS,
  INVALID_EXPIRED_REFRESH_TOKEN,
  INVALID_EXPIRED_RESET_TOKEN,
  INVALID_REFRESH_TOKEN,
  INVALID_RESET_CODE,
  RESET_CODE_SENT,
  UNAUTHORIZED_RESET_TOKEN,
  UNAUTHORIZED_REFRESH_TOKEN,
  USER_NOT_FOUND,
  PASSWORD_RESETED,
} from "../utils/messages.js";
import crypto from "crypto";
import sendEmail from "../utils/sendEmail.js";

export const generateAccessToken = (user) => {
  return jwt.sign(
    {
      id: user._id,
      email: user.email,
      role: user.role,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: process.env.JWT_EXPIRE,
    },
  );
};

export const generateRefreshToken = (user) => {
  return jwt.sign({ id: user._id }, process.env.JWT_REFRESH_SECRET, {
    expiresIn: process.env.JWT_REFRESH_EXPIRE,
  });
};

const generateResetToken = (user) => {
  return jwt.sign({ id: user._id }, process.env.JWT_RESET_SECRET, {
    expiresIn: process.env.JWT_RESET_EXPIRE,
  });
};

export const register = asyncWrapper(async (req, res, next) => {
  const { fullname, email, password, passwordConfirm } = req.body;

  const user = await User.create({
    fullname,
    email,
    password,
    passwordConfirm,
  });

  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  user.refreshToken = refreshToken;
  await user.save({ validateBeforeSave: false });

  user.password = undefined;
  user.refreshToken = undefined;

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    accessToken,
    refreshToken,
    data: {
      user: user,
    },
  });
});

export const login = asyncWrapper(async (req, res, next) => {
  const { email, password } = req.body;

  const user = await User.findOne({ email }).select("+password");

  if (!user || !(await user.correctPassword(password, user.password))) {
    return next(new AppError(INCORRECT_CREDENTIALS, 401));
  }

  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  user.refreshToken = refreshToken;
  await user.save({ validateBeforeSave: false });

  user.password = undefined;
  user.refreshToken = undefined;

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    accessToken,
    refreshToken,
    data: {
      user: user,
    },
  });
});

export const refreshUserToken = asyncWrapper(async (req, res, next) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return next(new AppError(UNAUTHORIZED_REFRESH_TOKEN, 401));
  }

  let decodedPayload;
  try {
    decodedPayload = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
  } catch (error) {
    return next(new AppError(INVALID_EXPIRED_REFRESH_TOKEN, 403));
  }

  const user = await User.findById(decodedPayload.id).select("+refreshToken");

  if (!user || user.refreshToken !== refreshToken) {
    return next(new AppError(INVALID_REFRESH_TOKEN, 403));
  }

  const accessToken = generateAccessToken(user);

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    accessToken: accessToken,
  });
});

export const forgotPassword = asyncWrapper(async (req, res, next) => {
  const user = await User.findOne({ email: req.body.email });

  if (!user) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  const otp = crypto.randomInt(100000, 1000000).toString();

  user.passwordResetOTP = crypto.createHash("sha256").update(otp).digest("hex");
  user.passwordResetExpiresAt = Date.now() + 5 * 60 * 1000;

  await user.save({ validateBeforeSave: false });

  const message = `Hello ${user.fullname},\n\nWe received a request to reset your Nexora account password.\nYour password reset code is: ${otp}\n\nThis code is valid for only 5 minutes.`;

  try {
    await sendEmail({
      email: user.email,
      subject: "Nexora Password Reset Code",
      message,
    });

    res.status(200).json({
      success: true,
      status: httpStatus.SUCCESS,
      message: RESET_CODE_SENT,
    });
  } catch (err) {
    user.passwordResetOTP = undefined;
    user.passwordResetExpiresAt = undefined;

    await user.save({ validateBeforeSave: false });

    return next(new AppError(EMAIL_SENDING_ERROR, 500));
  }
});

export const verifyOTP = asyncWrapper(async (req, res, next) => {
  const { email, otp } = req.body;

  const hashedOTP = crypto.createHash("sha256").update(otp).digest("hex");

  const user = await User.findOne({
    email,
    passwordResetOTP: hashedOTP,
    passwordResetExpiresAt: { $gt: Date.now() },
  });

  if (!user) {
    return next(new AppError(INVALID_RESET_CODE, 400));
  }

  user.passwordResetOTP = undefined;
  user.passwordResetExpiresAt = undefined;

  await user.save({ validateBeforeSave: false });

  const resetToken = generateResetToken(user);

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    resetToken,
  });
});

export const resetPassword = asyncWrapper(async (req, res, next) => {
  const { resetToken, newPassword, passwordConfirm } = req.body;

  if (!resetToken) {
    return next(new AppError(UNAUTHORIZED_RESET_TOKEN, 401));
  }

  let decodedPayload;
  try {
    decodedPayload = jwt.verify(resetToken, process.env.JWT_RESET_SECRET);
  } catch (error) {
    return next(new AppError(INVALID_EXPIRED_RESET_TOKEN, 401));
  }

  const user = await User.findById(decodedPayload.id);
  if (!user) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  user.password = newPassword;
  user.passwordConfirm = passwordConfirm;

  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);
  user.refreshToken = refreshToken;

  await user.save();

  const message = `Hello ${user.fullname},\n\nYour Nexora account password has been successfully changed.\n\nIf you didn't perform this action, please secure your account or contact our support team.`;

  try {
    await sendEmail({
      email: user.email,
      subject: "Your Nexora Password Has Been Changed",
      message,
    });
  } catch (err) {
    console.error(EMAIL_SENDING_ERROR);
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: PASSWORD_RESETED,
    accessToken,
    refreshToken,
  });
});
