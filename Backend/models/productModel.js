import mongoose from "mongoose";

const productSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Product name is required"],
      trim: true,
      minlength: [3, "Product name must be at least 3 characters long"],
    },
    brand: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Brand",
      required: [true, "Product brand is required"],
    },
    description: {
      type: String,
      required: [true, "Product description is required"],
      trim: true,
      minlength: [4, "Product description must be at least 4 characters long"],
    },
    price: {
      type: Number,
      required: [true, "Product price is required"],
      min: [0, "Price must be a positive number"],
    },
    discount: {
      type: Number,
      min: [0, "Discount must be a positive number"],
      max: [100, "Discount can't exceed 100%"],
      default: 0,
    },
    stock: {
      type: Number,
      required: [true, "Product stock is required"],
      min: [0, "Stock must be a positive number"],
    },
    sold: { type: Number, default: 0 },
    rating: {
      rate: {
        type: Number,
        min: [0, "Rating must be a positive number"],
        max: [5, "Rating can't exceed 5"],
        default: 0,
      },
      count: {
        type: Number,
        default: 0,
        min: [0, "Rating count must be a positive number"],
      },
    },
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
      required: [true, "Product category is required"],
    },
    thumbnail: {
      type: String,
      required: [true, "Product thumbnail is required"],
    },
    images: {
      type: [String],
      required: [true, "Product images are required"],
    },
  },
  {
    timestamps: true,
  },
);

const Product = mongoose.model("Product", productSchema);

export default Product;
