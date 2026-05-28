import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

export const createCategoryValidator = [
  check("name")
    .notEmpty()
    .withMessage("Category name is required")
    .isLength({ min: 3 })
    .withMessage("Category name must be at least 3 characters"),

  check("description")
    .notEmpty()
    .withMessage("Category description is required")
    .isLength({ min: 3 })
    .withMessage("Category description must be at least 3 characters"),

  check("image")
    .notEmpty()
    .withMessage("Category image URL is required")
    .isURL()
    .withMessage("Image must be a valid URL format"),

  validatorMiddleware,
];
