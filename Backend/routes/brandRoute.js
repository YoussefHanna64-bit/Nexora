import express from "express";
import { createBrandValidator, updateBrandValidator } from "../utils/validators/brandValidator.js";
import {
  createBrand,
  deleteBrand,
  getAllBrands,
  getBrandByID,
  updateBrand,
} from "../controllers/brandController.js";
import { validateMongoId } from "../utils/validators/idValidator.js";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";

const router = express.Router();

router.post(
  "/",
  verifyToken,
  authorize("admin"),
  createBrandValidator,
  createBrand,
);

router.get("/", getAllBrands);
router.get("/:id", validateMongoId, getBrandByID);

router.patch(
  "/:id",
  validateMongoId,
  verifyToken,
  authorize("admin"),
  updateBrandValidator,
  updateBrand,
);

router.delete(
  "/:id",
  validateMongoId,
  verifyToken,
  authorize("admin"),
  deleteBrand,
);

export default router;
