import express from "express";
import { createCategoryValidator } from "../utils/validators/categoryValidator.js";
import {
  createCategory,
  deleteCategory,
  getAllCategories,
  getCategoryByID,
  updateCategory,
} from "../controllers/categoryController.js";
import { validateMongoId } from "../utils/validators/idValidator.js";

const router = express.Router();

router.post("/", createCategoryValidator, createCategory);
router.get("/", getAllCategories);
router.get("/:id", validateMongoId, getCategoryByID);
router.patch("/:id", validateMongoId, updateCategory);
router.delete("/:id", validateMongoId, deleteCategory);

export default router;
