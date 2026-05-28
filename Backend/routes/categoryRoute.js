import express from "express";
import { createCategoryValidator } from "../utils/validators/categoryValidator.js";
import { createCategory, deleteCategory, getAllCategories, getCategoryByID, updateCategory } from "../controllers/categoryController.js";

const router = express.Router();

router.post("/", createCategoryValidator, createCategory);
router.get("/", getAllCategories);
router.get("/:id", getCategoryByID);
router.patch("/:id", updateCategory);
router.delete("/:id", deleteCategory);

export default router;
