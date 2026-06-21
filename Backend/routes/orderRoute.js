import express from "express";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";
import { validateMongoId } from "../utils/validators/idValidator.js";
import {
  createOrder,
  cancelOrder,
  getAllOrders,
  getUserOrders,
  getOrderByID,
  updateOrderStatus,
} from "../controllers/orderController.js";
import {
  createOrderValidator,
  updateOrderStatusValidator,
} from "../utils/validators/orderValidator.js";

const router = express.Router();

router.use(verifyToken);

router.post("/", authorize("user"), createOrderValidator, createOrder);

router.get("/", authorize("admin"), getAllOrders);

router.get("/my-orders", authorize("user"), getUserOrders);

router.get("/:id", authorize("user", "admin"), validateMongoId, getOrderByID);

router.patch(
  "/:id/status",
  authorize("admin"),
  validateMongoId,
  updateOrderStatusValidator,
  updateOrderStatus,
);

router.patch(
  "/:id/cancel",
  authorize("user", "admin"),
  validateMongoId,
  cancelOrder,
);

export default router;
