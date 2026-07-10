import express from "express";
import {
  forgotPassword,
  login,
  refreshUserToken,
  register,
  resetPassword,
  verifyOTP,
} from "../controllers/authController.js";
import {
  forgotPasswordValidator,
  loginValidator,
  refreshTokenValidator,
  registerValidator,
  resetPasswordValidator,
  verifyOTPValidator,
} from "../utils/validators/authValidator.js";

const router = express.Router();

router.post("/register", registerValidator, register);
router.post("/login", loginValidator, login);
router.post("/refresh", refreshTokenValidator, refreshUserToken);

router.post("/forgotPassword", forgotPasswordValidator, forgotPassword);
router.post("/verifyOTP", verifyOTPValidator, verifyOTP);
router.patch("/resetPassword", resetPasswordValidator, resetPassword);

export default router;
