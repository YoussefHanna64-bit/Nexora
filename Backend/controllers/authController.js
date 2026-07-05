import asyncWrapper from "../middleware/asyncWrapper.js";
import User from "../models/userModel.js";
import jwt from "jsonwebtoken";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import {
  INCORRECT_CREDENTIALS,
  INVALID_EXPIRED_REFRESH_TOKEN,
  INVALID_REFRESH_TOKEN,
} from "../utils/messages.js";

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
