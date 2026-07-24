import asyncWrapper from "../middleware/asyncWrapper.js";
import Brand from "../models/brandModel.js";
import httpStatus from "../utils/httpStatus.js";
import AppError from "../utils/AppError.js";
import { BRAND_NOT_FOUND } from "../utils/messages.js";

export const createBrand = asyncWrapper(async (req, res, next) => {
  const brand = await Brand.create(req.body);

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      brand: brand,
    },
  });
});

export const getAllBrands = asyncWrapper(async (req, res, next) => {
  const brands = await Brand.find();

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: brands.length,
    data: {
      brands: brands,
    },
  });
});

export const getBrandByID = asyncWrapper(async (req, res, next) => {
  const brand = await Brand.findById(req.params.id);

  if (!brand) {
    return next(new AppError(BRAND_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      brand: brand,
    },
  });
});

export const updateBrand = asyncWrapper(async (req, res, next) => {
  const brand = await Brand.findByIdAndUpdate(req.params.id, req.body, {
    returnDocument: "after",
    runValidators: true,
  });

  if (!brand) {
    return next(new AppError(BRAND_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      brand: brand,
    },
  });
});

export const deleteBrand = asyncWrapper(async (req, res, next) => {
  const brand = await Brand.findByIdAndDelete(req.params.id);

  if (!brand) {
    return next(new AppError(BRAND_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: null,
  });
});
