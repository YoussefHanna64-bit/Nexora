import asyncWrapper from "../middleware/asyncWrapper.js";
import User from "../models/userModel.js";
import httpStatus from "../utils/httpStatus.js";
import { WISHLIST_ADDED, WISHLIST_REMOVED } from "../utils/messages.js";

export const toggleWishlist = asyncWrapper(async (req, res, next) => {
  const productId = req.params.id;

  const user = await User.findById(req.user.id);

  const isWishlisted = user.wishlist.some((id) => id.equals(productId));

  if (isWishlisted) {
    user.wishlist.pull(productId);
  } else {
    user.wishlist.addToSet(productId);
  }

  await user.save();

  await user.populate({
    path: "wishlist",
    populate: {
      path: "category",
      model: "Category",
    },
  });

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    message: isWishlisted ? WISHLIST_REMOVED : WISHLIST_ADDED,
    data: {
      wishlist: user.wishlist,
    },
  });
});

export const getUserWishlist = asyncWrapper(async (req, res, next) => {
  const user = await User.findById(req.user.id).populate({
    path: "wishlist",
    populate: {
      path: "category",
      model: "Category",
    },
  });

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: user.wishlist.length,
    data: {
      wishlist: user.wishlist,
    },
  });
});
