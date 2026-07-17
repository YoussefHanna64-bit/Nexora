import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

export const createReviewValidator = [
  check("productId")
    .notEmpty()
    .withMessage("Product ID is required")
    .isMongoId()
    .withMessage("Invalid Product ID format"),

  check("rating")
    .notEmpty()
    .withMessage("Rating is required")
    .isFloat({ min: 1, max: 5 })
    .withMessage("Rating must be a number between 1 and 5"),

  check("comment").optional().isString().withMessage("Comment must be text"),

  validatorMiddleware,
];

export const updateReviewValidator = [
  check("rating")
    .optional()
    .isFloat({ min: 1, max: 5 })
    .withMessage("Rating must be a number between 1 and 5"),

  check("comment").optional().isString().withMessage("Comment must be text"),

  validatorMiddleware,
];
