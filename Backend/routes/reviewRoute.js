import express from "express";
import {
  createReview,
  deleteReview,
  getAllProductReviews,
  updateReview,
} from "../controllers/reviewController.js";
import { validateMongoId } from "../utils/validators/idValidator.js";
import {
  createReviewValidator,
  updateReviewValidator,
} from "../utils/validators/reviewValidator.js";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";

const router = express.Router();

router.get("/:id", validateMongoId, getAllProductReviews);

router.use(verifyToken);

router.post("/", authorize("user"), createReviewValidator, createReview);

router.patch(
  "/:id",
  authorize("user"),
  validateMongoId,
  updateReviewValidator,
  updateReview,
);

router.delete(
  "/:id",
  authorize("user", "admin"),
  validateMongoId,
  deleteReview,
);

export default router;
