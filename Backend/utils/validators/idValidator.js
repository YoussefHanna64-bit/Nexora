import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";

export const validateMongoId = [
  check("id").isMongoId().withMessage("Invalid ID format"),
  validatorMiddleware,
];
