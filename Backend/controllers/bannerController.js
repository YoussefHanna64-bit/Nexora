import asyncWrapper from "../middleware/asyncWrapper.js";
import Banner from "../models/bannerModel.js";
import AppError from "../utils/AppError.js";
import httpStatus from "../utils/httpStatus.js";
import { BANNER_NOT_FOUND } from "../utils/messages.js";

export const createBanner = asyncWrapper(async (req, res, next) => {
  const banner = await Banner.create(req.body);

  res.status(201).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      banner: banner,
    },
  });
});

export const getAllBanners = asyncWrapper(async (req, res, next) => {
  const banners = await Banner.find();

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: banners.length,
    data: {
      banners: banners,
    },
  });
});

export const getAllActiveBanners = asyncWrapper(async (req, res, next) => {
  const banners = await Banner.find({ isActive: true });

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    results: banners.length,
    data: {
      banners: banners,
    },
  });
});

export const getBannerByID = asyncWrapper(async (req, res, next) => {
  const banner = await Banner.findById(req.params.id);

  if (!banner) {
    return next(new AppError(BANNER_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      banner: banner,
    },
  });
});

export const updateBanner = asyncWrapper(async (req, res, next) => {
  const banner = await Banner.findByIdAndUpdate(req.params.id, req.body, {
    returnDocument: "after",
    runValidators: true,
  });

  if (!banner) {
    return next(new AppError(BANNER_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: {
      banner: banner,
    },
  });
});

export const deleteBanner = asyncWrapper(async (req, res, next) => {
  const banner = await Banner.findByIdAndDelete(req.params.id);

  if (!banner) {
    return next(new AppError(BANNER_NOT_FOUND, 404));
  }

  res.status(200).json({
    success: true,
    status: httpStatus.SUCCESS,
    data: null,
  });
});
