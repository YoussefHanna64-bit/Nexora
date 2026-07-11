import express from "express";
import {
  createBanner,
  deleteBanner,
  getAllActiveBanners,
  getAllBanners,
  getBannerByID,
  updateBanner,
} from "../controllers/bannerController.js";
import verifyToken from "../middleware/verifyToken.js";
import authorize from "../middleware/authorize.js";
import {
  createBannerValidator,
  updateBannerValidator,
} from "../utils/validators/bannerValidator.js";
import { validateMongoId } from "../utils/validators/idValidator.js";

const router = express.Router();

router.get("/active", getAllActiveBanners);

router.use(verifyToken, authorize("admin"));

router.post("/", createBannerValidator, createBanner);

router.get("/", getAllBanners);
router.get("/:id", validateMongoId, getBannerByID);

router.patch("/:id", validateMongoId, updateBannerValidator, updateBanner);

router.delete("/:id", validateMongoId, deleteBanner);

export default router;
