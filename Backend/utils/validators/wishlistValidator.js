import { check } from "express-validator";
import validatorMiddleware from "../../middleware/validatorMiddleware.js";
import Product from "../../models/productModel.js";
import { PRODUCT_NOT_FOUND } from "../messages.js";

export const toggleWishlistValidator = [
  check("id")
    .isMongoId()
    .withMessage("Invalid Product ID format")
    .bail()
    .custom(async (id, { req }) => {
      const product = await Product.findById(id);
      if (!product) {
        throw new Error(PRODUCT_NOT_FOUND);
      }
      req.product = product;
      return true;
    }),

  validatorMiddleware,
];
