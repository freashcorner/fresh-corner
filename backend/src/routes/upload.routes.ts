import { Router } from "express";
import multer from "multer";
import { adminMiddleware, AuthRequest } from "../middleware/auth.middleware";
import { uploadImageBuffer, deleteImage } from "../services/cloudinary.service";
const APP_CONFIG = {
  CLOUDINARY_PRODUCTS_FOLDER: "fresh-corner/products",
  CLOUDINARY_CATEGORIES_FOLDER: "fresh-corner/categories",
};

const router = Router();
const upload = multer({ storage: multer.memoryStorage(), limits: { fileSize: 5 * 1024 * 1024 } });

// POST /api/upload/product — admin uploads product image
router.post(
  "/product",
  adminMiddleware,
  upload.single("image"),
  async (req: AuthRequest, res, next) => {
    try {
      if (!req.file) {
        res.status(400).json({ error: "No image provided" });
        return;
      }
      const result = await uploadImageBuffer(req.file.buffer, APP_CONFIG.CLOUDINARY_PRODUCTS_FOLDER);
      res.json(result);
    } catch (err) {
      next(err);
    }
  }
);

// POST /api/upload/category — admin uploads category image
router.post(
  "/category",
  adminMiddleware,
  upload.single("image"),
  async (req: AuthRequest, res, next) => {
    try {
      if (!req.file) {
        res.status(400).json({ error: "No image provided" });
        return;
      }
      const result = await uploadImageBuffer(req.file.buffer, APP_CONFIG.CLOUDINARY_CATEGORIES_FOLDER);
      res.json(result);
    } catch (err) {
      next(err);
    }
  }
);

// DELETE /api/upload/:publicId — admin deletes image
router.delete("/:publicId(*)", adminMiddleware, async (req, res, next) => {
  try {
    await deleteImage(req.params.publicId);
    res.json({ message: "Image deleted" });
  } catch (err) {
    next(err);
  }
});

export default router;
