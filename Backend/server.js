import express from "express";
import dotenv from "dotenv";
import { connectDB } from "./config/dbConfig.js";
import httpStatus from "./utils/httpStatus.js";
import cors from "cors";

dotenv.config();
connectDB();
const app = express();

app.use(cors());
app.use(express.json());

app.use((req, res) => {
  return res.status(404).json({
    status: httpStatus.FAIL,
    message: "Route not found",
  });
});

app.use((err, req, res, next) => {
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    status: err.status || httpStatus.ERROR,
    message: err.message || "Internal Server Error",
  });
});

app.listen(process.env.PORT, () => {
  console.log("Server is running");
});
