import express from "express";
import dotenv from "dotenv";
import { connectDB } from "./config/dbConfig.js";
import httpStatus from "./utils/httpStatus.js";
import AppError from "./utils/AppError.js";
import cors from "cors";
import { errorHandler } from "./middleware/errorHandler.js";
import categoryRoute from "./routes/categoryRoute.js";
import productRoute from "./routes/productRoute.js";

dotenv.config();
connectDB();
const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/category", categoryRoute);
app.use("/api/products", productRoute);

app.all("*any", (req, res, next) => {
  next(new AppError(`Route ${req.originalUrl} not found`, 404));
});

app.use(errorHandler);

app.listen(process.env.PORT, () => {
  console.log("Server is running");
});
