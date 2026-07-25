import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

export const createFeedbackValidator = [
  check("message")
    .notEmpty()
    .withMessage("Message is required")
    .isLength({ min: 10 })
    .withMessage("Message must be at least 10 characters"),

  check("type")
    .optional()
    .isIn(["bug", "feedback", "question"])
    .withMessage("Type must be bug, feedback or question"),

  validatorMiddleware,
];

export const updateFeedbackStatusValidator = [
  check("status")
    .notEmpty()
    .withMessage("Status is required")
    .isIn(["pending", "reviewed", "resolved"])
    .withMessage("Status must be pending, reviewed or resolved"),

  validatorMiddleware,
];
