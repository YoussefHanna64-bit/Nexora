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

const router = express.Router();

router.post("/", createProductValidator, createProduct);
router.get("/", getAllProducts);
router.get("/:id", validateMongoId, getProductByID);
router.patch("/:id", validateMongoId, updateProduct);
router.delete("/:id", validateMongoId, deleteProduct);

export default router;
