import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

export const addAddressValidator = [
  check("street").notEmpty().withMessage("Street address is required"),

  check("apartment")
    .optional()
    .isString()
    .withMessage("Apartment details must be valid text"),

  check("city").notEmpty().withMessage("City is required"),

  check("postalCode")
    .notEmpty()
    .withMessage("Postal code is required")
    .isNumeric()
    .withMessage("Postal code must contain only numbers"),

  check("phone")
    .notEmpty()
    .withMessage("Phone number is required")
    .isMobilePhone(["ar-EG"])
    .withMessage("Phone number must be a valid mobile number"),

  check("label")
    .optional()
    .isIn(["Home", "Work", "Other"])
    .withMessage("Label must be Home, Work, or Other"),

  check("isDefault")
    .optional()
    .isBoolean()
    .withMessage("isDefault must be a boolean value"),

  validatorMiddleware,
];

export const updateAddressValidator = [
  check("street")
    .optional()
    .notEmpty()
    .withMessage("Street address is required"),

  check("apartment")
    .optional()
    .isString()
    .withMessage("Apartment details must be valid text"),

  check("city").optional().notEmpty().withMessage("City is required"),

  check("postalCode")
    .optional()
    .notEmpty()
    .withMessage("Postal code is required")
    .isNumeric()
    .withMessage("Postal code must contain only numbers"),

  check("phone")
    .optional()
    .notEmpty()
    .withMessage("Phone number is required")
    .isMobilePhone(["ar-EG"])
    .withMessage("Phone number must be a valid mobile number"),

  check("label")
    .optional()
    .isIn(["Home", "Work", "Other"])
    .withMessage("Label must be Home, Work, or Other"),

  check("isDefault")
    .optional()
    .isBoolean()
    .withMessage("isDefault must be a boolean value"),

  validatorMiddleware,
];
