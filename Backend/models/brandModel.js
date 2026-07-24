import mongoose from "mongoose";

const brandSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: [true, "Brand name is required"],
      unique: true,
      trim: true,
      minlength: [2, "Brand name must be at least 2 characters"],
    },
    slug: {
      type: String,
      lowercase: true,
    },
    image: {
      type: String,
      required: [true, "Brand image is required"],
    },
    description: {
      type: String,
      trim: true,
    },
  },
  {
    timestamps: true,
  },
);

brandSchema.pre("save", function () {
  this.slug = this.name.toLowerCase().replace(/\s+/g, "-");
});

brandSchema.pre("findOneAndUpdate", function () {
  const update = this.getUpdate();

  if (update.name) {
    update.slug = update.name.toLowerCase().replace(/\s+/g, "-");
  }
});

const Brand = mongoose.model("Brand", brandSchema);

export default Brand;
