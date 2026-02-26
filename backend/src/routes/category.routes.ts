import { Router } from "express";
import { db, COLLECTIONS } from "../services/firebase.service";
import { adminMiddleware, AuthRequest } from "../middleware/auth.middleware";
import { deleteImage } from "../services/cloudinary.service";
import { v4 as uuidv4 } from "uuid";

const router = Router();

// GET /api/categories — public
router.get("/", async (_req, res, next) => {
  try {
    const snapshot = await db
      .collection(COLLECTIONS.CATEGORIES)
      .where("isActive", "==", true)
      .orderBy("order", "asc")
      .get();
    const categories = snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
    res.json(categories);
  } catch (err) {
    next(err);
  }
});

// POST /api/categories — admin
router.post("/", adminMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const id = uuidv4();
    const cat = { ...req.body, id, isActive: true, createdAt: new Date() };
    await db.collection(COLLECTIONS.CATEGORIES).doc(id).set(cat);
    res.status(201).json(cat);
  } catch (err) {
    next(err);
  }
});

// PUT /api/categories/:id — admin
router.put("/:id", adminMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const ref = db.collection(COLLECTIONS.CATEGORIES).doc(req.params.id);
    if (!(await ref.get()).exists) {
      res.status(404).json({ error: "Category not found" });
      return;
    }
    await ref.update(req.body);
    res.json({ id: req.params.id, ...req.body });
  } catch (err) {
    next(err);
  }
});

// DELETE /api/categories/:id — admin
router.delete("/:id", adminMiddleware, async (req, res, next) => {
  try {
    const ref = db.collection(COLLECTIONS.CATEGORIES).doc(req.params.id);
    const doc = await ref.get();
    if (!doc.exists) {
      res.status(404).json({ error: "Category not found" });
      return;
    }
    const data = doc.data();
    if (data?.imagePublicId) await deleteImage(data.imagePublicId);
    await ref.delete();
    res.json({ message: "Category deleted" });
  } catch (err) {
    next(err);
  }
});

export default router;
