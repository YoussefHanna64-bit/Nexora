import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

export const createOrderValidator = [
  check("shippingAddress")
    .notEmpty()
    .withMessage("Shipping address is required")
    .isObject()
    .withMessage("Shipping address must be an object"),

  check("shippingAddress.street")
    .notEmpty()
    .withMessage("Street address is required"),

  check("shippingAddress.apartment")
    .optional()
    .isString()
    .withMessage("Apartment details must be valid text"),

  check("shippingAddress.city").notEmpty().withMessage("City is required"),

  check("shippingAddress.postalCode")
    .notEmpty()
    .withMessage("Postal code is required")
    .isNumeric()
    .withMessage("Postal code must contain only numbers"),

  check("shippingAddress.phone")
    .notEmpty()
    .withMessage("Phone number is required")
    .isMobilePhone(["ar-EG"])
    .withMessage("Phone number must be a valid mobile number"),

  check("paymentMethodType")
    .optional()
    .isIn(["cash", "card"])
    .withMessage("Payment method must be either cash or card"),

  validatorMiddleware,
];

export const updateOrderStatusValidator = [
  check("status")
    .notEmpty()
    .withMessage("Status is required")
    .isIn(["shipped", "delivered"])
    .withMessage("Status must be either shipped or delivered"),

  validatorMiddleware,
];
