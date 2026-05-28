import mongoose from "mongoose";

const categorySchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, "Category name is required"],
    unique: true,
    trim: true,
    minlength: [3, "Category name must be at least 3 characters"],
  },
  description: {
    type: String,
    required: [true, "Category description is required"],
    trim: true,
    minlength: [3, "Category description must be at least 3 characters"],
  },
  image: {
    type: String,
    required: [true, "Category image URL is required"],
  },
});

const Category = mongoose.model("Category", categorySchema);

export default Category;
