import express from "express";
import {
  login,
  refreshUserToken,
  register,
} from "../controllers/authController.js";
import {
  loginValidator,
  refreshTokenValidator,
  registerValidator,
} from "../utils/validators/authValidator.js";

const router = express.Router();

router.post("/register", registerValidator, register);
router.post("/login", loginValidator, login);
router.post("/refresh", refreshTokenValidator, refreshUserToken);
export default router;
