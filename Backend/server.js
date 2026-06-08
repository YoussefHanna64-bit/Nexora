import express from "express";
import dotenv from "dotenv";
import { connectDB } from "./config/dbConfig.js";
import httpStatus from "./utils/httpStatus.js";
import AppError from "./utils/AppError.js";
import cors from "cors";
import { errorHandler } from "./middleware/errorHandler.js";
import authRouter from "./routes/authRoute.js";
import userRouter from "./routes/userRoute.js";
import categoryRoute from "./routes/categoryRoute.js";
import productRoute from "./routes/productRoute.js";
import cartRoute from "./routes/cartRoute.js";
import wishlistRoute from "./routes/wishlistRoute.js";
import orderRoute from "./routes/orderRoute.js";

dotenv.config();
connectDB();
const app = express();

app.set("query parser", "extended");

app.use(cors());
app.use(express.json());

app.use("/api/auth", authRouter);
app.use("/api/users", userRouter);
app.use("/api/categories", categoryRoute);
app.use("/api/products", productRoute);
app.use("/api/cart", cartRoute);
app.use("/api/wishlist", wishlistRoute);
app.use("/api/orders", orderRoute);

app.all("*any", (req, res, next) => {
  next(new AppError(`Route ${req.originalUrl} not found`, 404));
});

app.use(errorHandler);

app.listen(process.env.PORT, () => {
  console.log("Server is running");
});
