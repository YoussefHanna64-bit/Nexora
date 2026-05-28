import asyncWrapper from "../middleware/asyncWrapper.js";
import Product from "../models/productModel.js";
import Category from "../models/categoryModel.js";
import httpStatus from "../utils/httpStatus.js";
import AppError from "../utils/AppError.js";

export const createProduct = asyncWrapper(async (req, res, next) => {
  const product = await Product.create({ ...req.body });

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      product: product,
    },
  });
});

export const getAllProducts = asyncWrapper(async (req, res, next) => {
  const products = await Product.find().populate("category");

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: products.length,
    data: {
      products: products,
    },
  });
});

export const getProductByID = asyncWrapper(async (req, res, next) => {
  const product = await Product.findById(req.params.id).populate("category");

  if (!product) {
    return next(new AppError("Product not found", 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      product: product,
    },
  });
});

export const updateProduct = asyncWrapper(async (req, res, next) => {
  const product = await Product.findByIdAndUpdate(req.params.id, req.body, {
    returnDocument: "after",
    runValidators: true,
  }).populate("category");

  if (!product) {
    return next(new AppError("Product not found", 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      product: product,
    },
  });
});

export const deleteProduct = asyncWrapper(async (req, res, next) => {
  const product = await Product.findByIdAndDelete(req.params.id);

  if (!product) {
    return next(new AppError("Product not found", 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: null,
  });
});
