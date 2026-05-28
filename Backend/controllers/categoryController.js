import asyncWrapper from "../middleware/asyncWrapper.js";
import Category from "../models/categoryModel.js";
import httpStatus from "../utils/httpStatus.js";
import AppError from "../utils/AppError.js";

export const createCategory = asyncWrapper(async (req, res, next) => {
  const category = await Category.create({ ...req.body });

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      category: category,
    },
  });
});

export const getAllCategories = asyncWrapper(async (req, res, next) => {
  const categories = await Category.find();

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: categories.length,
    data: {
      categories: categories,
    },
  });
});

export const getCategoryByID = asyncWrapper(async (req, res, next) => {
  const category = await Category.findById(req.params.id);

  if (!category) {
    return next(new AppError("Category not found", 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      category: category,
    },
  });
});

export const updateCategory = asyncWrapper(async (req, res, next) => {
  const category = await Category.findByIdAndUpdate(req.params.id, req.body, {
    returnDocument: "after",
    runValidators: true,
  });

  if (!category) {
    return next(new AppError("Category not found", 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      category: category,
    },
  });
});

export const deleteCategory = asyncWrapper(async (req, res, next) => {
  const category = await Category.findByIdAndDelete(req.params.id);

  if (!category) {
    return next(new AppError("Category not found", 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: null,
  });
});
