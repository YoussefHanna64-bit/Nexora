import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

export const createBrandValidator = [
  check("name")
    .notEmpty()
    .withMessage("Brand name is required")
    .isLength({ min: 2 })
    .withMessage("Brand name must be at least 2 characters"),

  check("image")
    .notEmpty()
    .withMessage("Brand image is required")
    .isURL()
    .withMessage("Image must be a valid URL format"),

  check("description")
    .optional()
    .isLength({ min: 3 })
    .withMessage("Description must be at least 3 characters"),

  validatorMiddleware,
];

export const updateBrandValidator = [
  check("name")
    .optional()
    .isLength({ min: 2 })
    .withMessage("Brand name must be at least 2 characters"),

  check("image")
    .optional()
    .isURL()
    .withMessage("Image must be a valid URL format"),

  check("description")
    .optional()
    .isLength({ min: 3 })
    .withMessage("Description must be at least 3 characters"),

  validatorMiddleware,
];
