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
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";

const router = express.Router();

router.post(
  "/",
  verifyToken,
  authorize("admin"),
  createCategoryValidator,
  createCategory,
);

router.get("/", getAllCategories);
router.get("/:id", validateMongoId, getCategoryByID);

router.patch(
  "/:id",
  validateMongoId,
  verifyToken,
  authorize("admin"),
  updateCategory,
);

router.delete(
  "/:id",
  validateMongoId,
  verifyToken,
  authorize("admin"),
  deleteCategory,
);

export default router;
