import express from "express";
import { createProductValidator } from "../utils/validators/productValidator.js";
import {
  createProduct,
  deleteProduct,
  getAllProducts,
  getProductByID,
  updateProduct,
} from "../controllers/productController.js";

const router = express.Router();

router.post("/", createProductValidator, createProduct);
router.get("/", getAllProducts);
router.get("/:id", getProductByID);
router.patch("/:id", updateProduct);
router.delete("/:id", deleteProduct);

export default router;
