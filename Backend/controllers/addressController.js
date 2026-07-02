import asyncWrapper from "../middleware/asyncWrapper.js";
import httpStatus from "../utils/httpStatus.js";
import AppError from "../utils/AppError.js";
import {
  ADDRESS_ADDED,
  ADDRESS_DELETED,
  ADDRESS_NOT_FOUND,
  ADDRESS_UPDATED,
  USER_NOT_FOUND,
} from "../utils/messages.js";
import User from "../models/userModel.js";

export const addAddress = asyncWrapper(async (req, res, next) => {
  const user = await User.findById(req.user.id);

  if (!user) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  req.body.isDefault = true;

  if (user.addresses && user.addresses.length > 0) {
    user.addresses.forEach((addr) => {
      addr.isDefault = false;
    });
  }

  user.addresses.push(req.body);

  await user.save();

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: ADDRESS_ADDED,
    data: {
      addresses: user.addresses,
    },
  });
});

export const getAddresses = asyncWrapper(async (req, res, next) => {
  const user = await User.findById(req.user.id);

  if (!user) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: user.addresses.length,
    data: {
      addresses: user.addresses,
    },
  });
});

export const updateAddress = asyncWrapper(async (req, res, next) => {
  const user = await User.findById(req.user.id);

  if (!user) {
    return next(new AppError(USER_NOT_FOUND, 404));
  }

  const address = user.addresses.id(req.params.id);

  if (!address) {
    return next(new AppError(ADDRESS_NOT_FOUND, 404));
  }

  if (req.body.isDefault === true) {
    user.addresses.forEach((addr) => {
      addr.isDefault = false;
    });
    address.isDefault = true;
  }

  address.set(req.body);

  await user.save();

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: ADDRESS_UPDATED,
    data: {
      addresses: user.addresses,
    },
  });
});

export const deleteAddress = asyncWrapper(async (req, res, next) => {
  const user = await User.findByIdAndUpdate(
    req.user.id,
    { $pull: { addresses: { _id: req.params.id } } },
    { returnDocument: "after" },
  );

  if (!user) {
    return next(new AppError("User not found", 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: ADDRESS_DELETED,
    data: {
      addresses: user.addresses,
    },
  });
});
