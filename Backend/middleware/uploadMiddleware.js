import multer from "multer";
import { INVALID_IMAGE } from "../utils/messages.js";
import AppError from "../utils/AppError.js";

const storage = multer.memoryStorage();

const filter = (req, file, cb) => {
  if (file.mimetype.startsWith("image")) {
    cb(null, true);
  } else {
    cb(new AppError(INVALID_IMAGE, 400), false);
  }
};

const upload = multer({
  storage: storage,
  fileFilter: filter,
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
});

export const uploadProfileImage = upload.single("profileImage");
