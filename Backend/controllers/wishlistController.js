import asyncWrapper from "../middleware/asyncWrapper.js";
import User from "../models/userModel.js";
import httpStatus from "../utils/httpStatus.js";

export const toggleWishlist = asyncWrapper(async (req, res, next) => {
  const productId = req.params.id;

  const user = await User.findById(req.user.id);

  const isWishlisted = user.wishlist.some((id) => id.equals(productId));

  const updatedUser = await User.findByIdAndUpdate(
    req.user.id,
    isWishlisted
      ? { $pull: { wishlist: productId } }
      : { $addToSet: { wishlist: productId } },
    { returnDocument: "after" },
  ).populate("wishlist");

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: isWishlisted ? "Removed from wishlist" : "Added to wishlist",
    data: {
      wishlist: updatedUser.wishlist,
    },
  });
});

export const getUserWishlist = asyncWrapper(async (req, res, next) => {
  const user = await User.findById(req.user.id).populate("wishlist");

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: user.wishlist.length,
    data: {
      wishlist: user.wishlist,
    },
  });
});
