import AppError from "../utils/AppError.js";
import jwt from "jsonwebtoken";
import httpStatus from "../utils/httpStatus.js";
import User from "../models/userModel.js";
import asyncWrapper from "./asyncWrapper.js";

const verifyToken = asyncWrapper(async (req, res, next) => {
  const authHeader =
    req.headers["Authorization"] || req.headers["authorization"];
  if (!authHeader) {
    return next(new AppError("No Authorization Headers Provided", 401));
  }

  if (!authHeader.startsWith("Bearer ")) {
    return next(new AppError("Invalid token format. Missing Bearer", 401));
  }

  const token = authHeader.split(" ")[1];

  const decodedPayload = jwt.verify(token, process.env.JWT_SECRET);

  const currentUser = await User.findById(decodedPayload.id);
  if (!currentUser) {
    return next(
      new AppError("The user belonging to this token no longer exists.", 401),
    );
  }

  req.user = decodedPayload;
  next();
});

export default verifyToken;
