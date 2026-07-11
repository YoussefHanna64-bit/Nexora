import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";
import Product from "../../models/productModel.js";
import { PRODUCT_NOT_FOUND } from "../messages.js";
import mongoose from "mongoose";

export const createBannerValidator = [
  check("title")
    .notEmpty()
    .withMessage("Banner title is required")
    .isLength({ min: 2 })
    .withMessage("Banner title must be at least 2 characters long"),

  check("image")
    .notEmpty()
    .withMessage("Banner image is required")
    .isURL()
    .withMessage("Banner image must be a valid URL format"),

  check("type")
    .notEmpty()
    .withMessage("Banner type is required")
    .isIn(["product", "search"])
    .withMessage("Banner type must be either product or search"),

  check("target")
    .notEmpty()
    .withMessage("Banner target is required productId or search keyword")
    .custom(async (val, { req }) => {
      if (req.body.type === "product") {
        if (!mongoose.Types.ObjectId.isValid(val)) {
          throw new Error(
            "Banner target must be a valid MongoDB ID when type is product",
          );
        }
        const product = await Product.findById(val);
        if (!product) {
          throw new Error(PRODUCT_NOT_FOUND);
        }
      }
      return true;
    }),

  check("isActive")
    .optional()
    .isBoolean()
    .withMessage("Banner isActive must be a boolean"),

  validatorMiddleware,
];

export const updateBannerValidator = [
  check("title")
    .optional()
    .isLength({ min: 2 })
    .withMessage("Banner title must be at least 2 characters long"),

  check("image")
    .optional()
    .isURL()
    .withMessage("Banner image must be a valid URL format"),

  check("type")
    .optional()
    .isIn(["product", "search"])
    .withMessage("Banner type must be either product or search"),

  check("target")
    .optional()
    .notEmpty()
    .withMessage("Banner target is required productId or search keyword")
    .custom(async (val, { req }) => {
      if (req.body.type === "product") {
        if (!mongoose.Types.ObjectId.isValid(val)) {
          throw new Error(
            "Banner target must be a valid MongoDB ID when type is product",
          );
        }
        const product = await Product.findById(val);
        if (!product) {
          throw new Error(PRODUCT_NOT_FOUND);
        }
      }
      return true;
    }),

  check("isActive")
    .optional()
    .isBoolean()
    .withMessage("Banner isActive must be a boolean"),

  validatorMiddleware,
];
