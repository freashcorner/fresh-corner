import { Router } from "express";
import { db, COLLECTIONS } from "../services/firebase.service";
import { authMiddleware, adminMiddleware, AuthRequest } from "../middleware/auth.middleware";
import { deleteImage } from "../services/cloudinary.service";
import { v4 as uuidv4 } from "uuid";

const router = Router();

// GET /api/products — public
router.get("/", async (req, res, next) => {
  try {
    let query: FirebaseFirestore.Query = db.collection(COLLECTIONS.PRODUCTS);
    const { categoryId, featured, limit = "20", page = "1" } = req.query;

    query = query.where("isActive", "==", true);
    if (categoryId) query = query.where("categoryId", "==", categoryId);
    if (featured === "true") query = query.where("isFeatured", "==", true);

    query = query.orderBy("createdAt", "desc").limit(Number(limit));
    const snapshot = await query.get();
    const products = snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
    res.json({ products, total: products.length });
  } catch (err) {
    next(err);
  }
});

// GET /api/products/:id
router.get("/:id", async (req, res, next) => {
  try {
    const doc = await db.collection(COLLECTIONS.PRODUCTS).doc(req.params.id).get();
    if (!doc.exists) {
      res.status(404).json({ error: "Product not found" });
      return;
    }
    res.json({ id: doc.id, ...doc.data() });
  } catch (err) {
    next(err);
  }
});

// POST /api/products — admin only
router.post("/", adminMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const id = uuidv4();
    const product = {
      ...req.body,
      id,
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    await db.collection(COLLECTIONS.PRODUCTS).doc(id).set(product);
    res.status(201).json(product);
  } catch (err) {
    next(err);
  }
});

// PUT /api/products/:id — admin only
router.put("/:id", adminMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const ref = db.collection(COLLECTIONS.PRODUCTS).doc(req.params.id);
    const existing = await ref.get();
    if (!existing.exists) {
      res.status(404).json({ error: "Product not found" });
      return;
    }
    await ref.update({ ...req.body, updatedAt: new Date() });
    res.json({ id: req.params.id, ...req.body });
  } catch (err) {
    next(err);
  }
});

// DELETE /api/products/:id — admin only
router.delete("/:id", adminMiddleware, async (_req, res, next) => {
  try {
    const ref = db.collection(COLLECTIONS.PRODUCTS).doc(_req.params.id);
    const doc = await ref.get();
    if (!doc.exists) {
      res.status(404).json({ error: "Product not found" });
      return;
    }
    const data = doc.data();
    if (data?.imagePublicId) {
      await deleteImage(data.imagePublicId);
    }
    await ref.delete();
    res.json({ message: "Product deleted" });
  } catch (err) {
    next(err);
  }
});

export default router;
