import mongoose from "mongoose";

const bannerSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, "Banner title is required"],
      trim: true,
      minlength: [2, "Banner title must be at least 2 characters long"],
    },
    image: {
      type: String,
      required: [true, "Banner image is required"],
    },
    type: {
      type: String,
      enum: ["product", "search"],
      required: [true, "Banner type must be either product or search"],
    },
    target: {
      type: String,
      required: [true, "Banner must have a target productId or search keyword"],
    },
    isActive: {
      type: Boolean,
      default: true,
    },
  },
  { timestamps: true },
);

const Banner = mongoose.model("Banner", bannerSchema);

export default Banner;
