import mongoose from "mongoose";

const feedbackSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "Feedback must belong to a user"],
    },
    type: {
      type: String,
      enum: {
        values: ["bug", "feedback", "question"],
        message: "Type must be bug, feedback or question",
      },
      default: "feedback",
    },
    message: {
      type: String,
      required: [true, "Message is required"],
      trim: true,
      minlength: [10, "Message must be at least 10 characters"],
    },
    status: {
      type: String,
      enum: {
        values: ["pending", "reviewed", "resolved"],
        message: "Status must be pending, reviewed or resolved",
      },
      default: "pending",
    },
  },
  {
    timestamps: true,
  },
);

const Feedback = mongoose.model("Feedback", feedbackSchema);

export default Feedback;
