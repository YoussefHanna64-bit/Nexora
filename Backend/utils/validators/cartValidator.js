import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";
import Product from "../../models/productModel.js";
import { PRODUCT_NOT_FOUND } from "../../utils/messages.js";

export const addProductToCartValidator = [
  check("productId")
    .notEmpty()
    .withMessage("Product ID is required")
    .isMongoId()
    .withMessage("Invalid Product ID format")
    .custom(async (val, { req }) => {
      const product = await Product.findById(val);
      if (!product) {
        throw new Error(PRODUCT_NOT_FOUND);
      }
      req.product = product;
      return true;
    }),

  check("quantity")
    .optional()
    .isInt({ min: 1 })
    .withMessage("Quantity must be an integer of at least 1"),

  validatorMiddleware,
];

export const updateCartItemQuantityValidator = [
  check("quantity")
    .notEmpty()
    .withMessage("Quantity is required")
    .isInt({ min: 0 })
    .withMessage("Quantity must be an integer >= 0"),

  validatorMiddleware,
];
