import httpStatus from "../utils/httpStatus.js";
import AppError from "../utils/AppError.js";
import { INVALID_TOKEN, JWT_EXPIRED } from "../utils/messages.js";

const handleDuplicateFieldsDB = (err) => {
  const field = Object.keys(err.keyValue)[0];
  const value = Object.values(err.keyValue)[0];

  const message = `Duplicate ${field}: '${value}'. Please use another value!`;
  return new AppError(message, 409);
};

export const errorHandler = (err, req, res, next) => {
  let error = { ...err };
  error.message = err.message;
  error.name = err.name;

  if (err.code === 11000) {
    error = handleDuplicateFieldsDB(error);
  }

  if (err.name === "CastError") {
    const message = `Invalid ${err.path}: ${err.value}.`;
    error = new AppError(message, 400);
  }

  if (err.name === "TokenExpiredError" || err.message === "jwt expired") {
    error = new AppError(JWT_EXPIRED, 401);
  }

  if (err.name === "JsonWebTokenError") {
    error = new AppError(INVALID_TOKEN, 401);
  }

  const statusCode = error.statusCode || 500;
  const status = error.status || httpStatus.ERROR;

  res.status(statusCode).json({
    success: false,
    status: status,
    message: error.message || "Internal Server Error",
  });
};
