import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

export const updateUserValidator = [
  check("fullname")
    .optional()
    .trim()
    .isLength({ min: 3 })
    .withMessage("Full name must be at least 3 characters long"),

  check("email")
    .optional()
    .trim()
    .isEmail()
    .withMessage("Invalid email format"),

  validatorMiddleware,
];

export const updatePasswordValidator = [
  check("currentPassword")
    .notEmpty()
    .withMessage("Current password is required"),

  check("newPassword")
    .notEmpty()
    .withMessage("New password is required")
    .isLength({ min: 8 })
    .withMessage("Password must be at least 8 characters"),

  check("passwordConfirm")
    .notEmpty()
    .withMessage("Password confirmation is required")
    .custom((val, { req }) => {
      if (val !== req.body.newPassword) {
        throw new Error("Passwords don't match");
      }
      return true;
    }),

  validatorMiddleware,
];
