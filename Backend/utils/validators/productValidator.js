import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";
import Category from "../../models/categoryModel.js";

export const createProductValidator = [
  check("name")
    .notEmpty()
    .withMessage("Product name is required")
    .isLength({ min: 3 })
    .withMessage("Product name must be at least 3 characters long"),

  check("brand")
    .notEmpty()
    .withMessage("Product brand is required")
    .isLength({ min: 2 })
    .withMessage("Product brand must be at least 2 characters long"),

  check("description")
    .notEmpty()
    .withMessage("Product description is required")
    .isLength({ min: 4 })
    .withMessage("Product description must be at least 4 characters long"),

  check("price")
    .notEmpty()
    .withMessage("Product price is required")
    .isFloat({ min: 0 })
    .withMessage("Price must be a positive number"),

  check("discount")
    .optional()
    .isFloat({ min: 0, max: 100 })
    .withMessage("Discount must be between 0 and 100"),

  check("stock")
    .notEmpty()
    .withMessage("Product stock is required")
    .isInt({ min: 0 })
    .withMessage("Stock must be a positive integer number"),

  check("category")
    .notEmpty()
    .withMessage("Product category is required")
    .isMongoId()
    .withMessage("Invalid Category ID format")
    .custom(async (categoryId) => {
      const categoryExists = await Category.findById(categoryId);
      if (!categoryExists) {
        throw new Error("Category doesn't exist");
      }
      return true;
    }),

  check("thumbnail")
    .notEmpty()
    .withMessage("Product thumbnail is required")
    .isURL()
    .withMessage("Thumbnail must be a valid URL format"),

  check("images")
    .notEmpty()
    .withMessage("Product images are required")
    .isArray()
    .withMessage("Images must be an array of strings"),

  check("images.*")
    .isURL()
    .withMessage("Each image must be a valid URL format"),

  check("rating")
    .optional()
    .isObject()
    .withMessage("Rating must be an object containing rate and count"),

  check("rating.rate")
    .optional()
    .isFloat({ min: 0, max: 5 })
    .withMessage("Rating rate must be a number between 0 and 5"),

  check("rating.count")
    .optional()
    .isInt({ min: 0 })
    .withMessage("Rating count must be a positive number"),

  validatorMiddleware,
];
