import express from "express";
import {
  createFeedback,
  getAllFeedbacks,
  getFeedbackById,
  updateFeedbackStatus,
} from "../controllers/feedbackController.js";
import {
  createFeedbackValidator,
  updateFeedbackStatusValidator,
} from "../utils/validators/feedbackValidator.js";
import { validateMongoId } from "../utils/validators/idValidator.js";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";

const router = express.Router();

router.post("/", verifyToken, createFeedbackValidator, createFeedback);

router.get("/", verifyToken, authorize("admin"), getAllFeedbacks);

router.get("/:id", verifyToken, authorize("admin"), validateMongoId, getFeedbackById);

router.patch(
  "/:id/status",
  verifyToken,
  authorize("admin"),
  validateMongoId,
  updateFeedbackStatusValidator,
  updateFeedbackStatus,
);

export default router;
