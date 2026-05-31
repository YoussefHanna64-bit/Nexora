import express from "express";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";
import {
  toggleWishlist,
  getUserWishlist,
} from "../controllers/wishlistController.js";
import { toggleWishlistValidator } from "../utils/validators/wishlistValidator.js";

const router = express.Router();

router.use(verifyToken);
router.use(authorize("user"));

router.post("/:id", toggleWishlistValidator, toggleWishlist);
router.get("/", getUserWishlist);

export default router;
