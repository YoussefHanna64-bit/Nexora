import express from "express";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";
import {
  addProductToCartValidator,
  updateCartItemQuantityValidator,
} from "../utils/validators/cartValidator.js";
import {
  addProductToCart,
  clearCart,
  getUserCart,
  removeCartItem,
  updateCartItemQuantity,
} from "../controllers/cartController.js";
import { validateMongoId } from "../utils/validators/idValidator.js";

const router = express.Router();

router.use(verifyToken);
router.use(authorize("user", "admin"));

router.post("/", addProductToCartValidator, addProductToCart);
router.get("/", getUserCart);
router.patch("/:id", validateMongoId, updateCartItemQuantityValidator, updateCartItemQuantity);
router.delete("/:id", validateMongoId, removeCartItem);
router.delete("/", clearCart);

export default router;
