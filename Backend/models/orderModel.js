import mongoose from "mongoose";

const orderSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: [true, "Order must belong to a user"],
    },
    cartItems: [
      {
        product: {
          type: mongoose.Schema.Types.ObjectId,
          ref: "Product",
        },
        quantity: Number,
        price: Number,
      },
    ],
    totalOrderPrice: {
      type: Number,
    },
    status: {
      type: String,
      enum: ["pending", "shipped", "delivered", "canceled"],
      default: "pending",
    },
    paymentMethodType: {
      type: String,
      enum: ["card", "cash"],
      default: "cash",
    },
    isPaid: {
      type: Boolean,
      default: false,
    },
    paidAt: Date,
    deliveredAt: Date,
    shippedAt: Date,
    canceledAt: Date,
    shippingAddress: {
      street: {
        type: String,
        required: [true, "Street address is required"],
      },
      apartment: {
        type: String,
      },
      city: {
        type: String,
        required: [true, "City is required"],
      },
      postalCode: {
        type: String,
        required: [true, "Postal code is required"],
      },
      phone: {
        type: String,
        required: [true, "Phone number is required"],
      },
    },
  },
  { timestamps: true },
);

const Order = mongoose.model("Order", orderSchema);

export default Order;
