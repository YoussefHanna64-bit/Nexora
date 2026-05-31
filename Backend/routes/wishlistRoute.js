import express from "express";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";
import {
  toggleWishlist,
  getUserWishlist,
} from "../controllers/wishlistController.js";
import { validateMongoId } from "../utils/validators/idValidator.js";

const router = express.Router();

router.use(verifyToken);
router.use(authorize("user"));

router.post("/:id", validateMongoId, toggleWishlist);
router.get("/", getUserWishlist);

export default router;
