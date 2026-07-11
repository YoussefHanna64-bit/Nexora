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
  uploadProfilePicture,
} from "../controllers/userController.js";
import { validateMongoId } from "../utils/validators/idValidator.js";
import {
  updatePasswordValidator,
  updateUserValidator,
} from "../utils/validators/userValidator.js";
import {
  addAddressValidator,
  updateAddressValidator,
} from "../utils/validators/addressValidator.js";
import {
  addAddress,
  deleteAddress,
  getAddresses,
  updateAddress,
} from "../controllers/addressController.js";
import { uploadProfileImage } from "../middleware/uploadMiddleware.js";

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

router.patch(
  "/profilePicture",
  authorize("user", "admin"),
  uploadProfileImage,
  uploadProfilePicture,
);

router.get("/addresses", authorize("user", "admin"), getAddresses);

router.post(
  "/addresses",
  authorize("user", "admin"),
  addAddressValidator,
  addAddress,
);

router.patch(
  "/addresses/:id",
  authorize("user", "admin"),
  validateMongoId,
  updateAddressValidator,
  updateAddress,
);

router.delete(
  "/addresses/:id",
  authorize("user", "admin"),
  validateMongoId,
  deleteAddress,
);

router.delete("/", authorize("user", "admin"), deleteUser);

router.use(authorize("admin"));

router.get("/", getAllUsers);
router.get("/:id", validateMongoId, getUserById);
router.delete("/:id", validateMongoId, deleteUser);

export default router;
