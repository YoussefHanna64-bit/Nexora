import express from "express";
import { createProductValidator } from "../utils/validators/productValidator.js";
import {
  createProduct,
  deleteProduct,
  getAllProducts,
  getProductByID,
  updateProduct,
} from "../controllers/productController.js";
import { validateMongoId } from "../utils/validators/idValidator.js";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";

const router = express.Router();

router.post(
  "/",
  verifyToken,
  authorize("admin"),
  createProductValidator,
  createProduct,
);

router.get("/", getAllProducts);
router.get("/:id", validateMongoId, getProductByID);

router.patch(
  "/:id",
  validateMongoId,
  verifyToken,
  authorize("admin"),
  updateProduct,
);

router.delete(
  "/:id",
  validateMongoId,
  verifyToken,
  authorize("admin"),
  deleteProduct,
);

export default router;
