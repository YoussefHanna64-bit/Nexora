import bcrypt from "bcryptjs";
import asyncWrapper from "../middleware/asyncWrapper.js";
import User from "../models/userModel.js";
import httpStatus from "../utils/httpStatus.js";
import {
  ACCOUNT_DELETE_PERMISSION,
  ACCOUNT_DELETED,
  CLOUDINARY_UPLOAD_ERROR,
  INCORRECT_CURRENT_PASSWORD,
  NO_IMAGE_PROVIDED,
  PASSWORD_UPDATED,
  PROFILE_PICTURE_UPDATED,
  PROFILE_UPDATED,
  USER_NOT_FOUND,
} from "../utils/messages.js";
import AppError from "../utils/AppError.js";
import { generateAccessToken, generateRefreshToken } from "./authController.js";
import streamifier from "streamifier";
import { v2 as cloudinary } from "cloudinary";

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

  const accessToken = generateAccessToken(user);
  const refreshToken = generateRefreshToken(user);

  user.refreshToken = refreshToken;
  await user.save();

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: PASSWORD_UPDATED,
    accessToken,
    refreshToken,
    data: null,
  });
});

export const uploadProfilePicture = asyncWrapper(async (req, res, next) => {
  if (!req.file) {
    return next(new AppError(NO_IMAGE_PROVIDED, 400));
  }

  const uploadStream = (req) => {
    return new Promise((resolve, reject) => {
      const stream = cloudinary.uploader.upload_stream(
        {
          folder: "NexoraPFPs",
          gravity: "face",
          crop: "fill",
          width: 400,
          height: 400,
        },
        (error, result) => {
          if (result) {
            resolve(result);
          } else {
            reject(error);
          }
        },
      );
      streamifier.createReadStream(req.file.buffer).pipe(stream);
    });
  };

  let result;
  try {
    result = await uploadStream(req);
  } catch (error) {
    return next(new AppError(CLOUDINARY_UPLOAD_ERROR, 500));
  }

  const updatedUser = await User.findByIdAndUpdate(
    req.user.id,
    { profileImage: result.secure_url },
    {
      returnDocument: "after",
      runValidators: true,
    },
  );

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: PROFILE_PICTURE_UPDATED,
    data: {
      user: updatedUser,
    },
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
