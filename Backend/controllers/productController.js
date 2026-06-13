import asyncWrapper from "../middleware/asyncWrapper.js";
import Product from "../models/productModel.js";
import Category from "../models/categoryModel.js";
import httpStatus from "../utils/httpStatus.js";
import AppError from "../utils/AppError.js";
import ApiFeatures from "../utils/ApiFeatures.js";
import { PRODUCT_NOT_FOUND } from "../utils/messages.js";

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
  let features = new ApiFeatures(
    Product.find().populate("category"),
    req.query,
  ).filter();

  features = await features.search(["name", "brand"]);

  features.sort().limitFields().paginate();

  const products = await features.mongooseQuery;

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
    return next(new AppError(PRODUCT_NOT_FOUND, 404));
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
    return next(new AppError(PRODUCT_NOT_FOUND, 404));
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
    return next(new AppError(PRODUCT_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: null,
  });
});
