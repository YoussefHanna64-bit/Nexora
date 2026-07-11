import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

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
    .withMessage("Banner target is required productId or search keyword"),

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
    .withMessage("Banner target can't be empty"),

  check("isActive")
    .optional()
    .isBoolean()
    .withMessage("Banner isActive must be a boolean"),

  validatorMiddleware,
];
