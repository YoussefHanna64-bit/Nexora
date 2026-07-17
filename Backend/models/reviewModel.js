import mongoose from "mongoose";
import Product from "./productModel.js";

const reviewSchema = new mongoose.Schema(
  {
    product: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Product",
      required: [true, "Product is required"],
    },
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "User is required"],
    },
    rating: {
      type: Number,
      min: [0, "Rating must be a positive number"],
      max: [5, "Rating can't exceed 5"],
      required: [true, "Rating is required"],
    },
    comment: {
      type: String,
      trim: true,
    },
  },
  { timestamps: true },
);

reviewSchema.index({ product: 1, user: 1 }, { unique: true });

reviewSchema.pre(/^find/, function (next) {
  this.populate({
    path: "user",
    select: "fullname profileImage",
  });
  next();
});

reviewSchema.statics.calcAvgRatings = async function (productId) {
  const stats = await this.aggregate([
    {
      $match: { product: productId },
    },
    {
      $group: {
        _id: "$product",
        nRating: { $sum: 1 },
        avgRating: { $avg: "$rating" },
      },
    },
  ]);

  if (stats.length > 0) {
    await Product.findByIdAndUpdate(productId, {
      "rating.count": stats[0].nRating,
      "rating.rate": Math.round(stats[0].avgRating * 10) / 10,
    });
  } else {
    await Product.findByIdAndUpdate(productId, {
      "rating.count": 0,
      "rating.rate": 0,
    });
  }
};

reviewSchema.post("save", function () {
  this.constructor.calcAvgRatings(this.product);
});

reviewSchema.post(/(findOneAndUpdate|findOneAndDelete)/, async function (doc) {
  if (doc) {
    await doc.constructor.calcAvgRatings(doc.product);
  }
});

const Review = mongoose.model("Review", reviewSchema);

export default Review;
