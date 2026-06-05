import asyncWrapper from "../middleware/asyncWrapper.js";
import User from "../models/userModel.js";
import jwt from "jsonwebtoken";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import { INCORRECT_CREDENTIALS } from "../utils/messages.js";

export const generateToken = (user) => {
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

export const register = asyncWrapper(async (req, res, next) => {
  const { fullname, email, password, passwordConfirm } = req.body;

  const user = await User.create({
    fullname,
    email,
    password,
    passwordConfirm,
  });

  const token = generateToken(user);

  user.password = undefined;

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    token: token,
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

  const token = generateToken(user);

  user.password = undefined;

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    token: token,
    data: {
      user: user,
    },
  });
});
