import express from "express";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";
import {
  deleteUser,
  getAllUsers,
  getUser,
  getUserById,
  updatePassword,
  updateUser,
} from "../controllers/userController.js";
import { validateMongoId } from "../utils/validators/idValidator.js";
import {
  updatePasswordValidator,
  updateUserValidator,
} from "../utils/validators/userValidator.js";

const router = express.Router();

router.use(verifyToken);

router.get("/me", authorize("user", "admin"), getUser);
router.patch(
  "/updateUser",
  authorize("user", "admin"),
  updateUserValidator,
  updateUser,
);

router.patch(
  "/updatePassword",
  authorize("user", "admin"),
  updatePasswordValidator,
  updatePassword,
);
router.delete("/", authorize("user", "admin"), deleteUser);

router.use(authorize("admin"));

router.get("/", getAllUsers);
router.get("/:id", validateMongoId, getUserById);
router.delete("/:id", validateMongoId, deleteUser);

export default router;
