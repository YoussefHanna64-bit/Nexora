import express from "express";
import { createPaymentIntent } from "../controllers/paymentController.js";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";

const router = express.Router();

router.post(
  "/payment-intent",
  verifyToken,
  authorize("user"),
  createPaymentIntent,
);

export default router;
