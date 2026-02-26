import { Router } from "express";
import { db, COLLECTIONS } from "../services/firebase.service";
import { adminMiddleware } from "../middleware/auth.middleware";

const router = Router();

// GET /api/settings — public
router.get("/", async (_req, res, next) => {
  try {
    const doc = await db.collection(COLLECTIONS.SETTINGS).doc("app").get();
    if (!doc.exists) {
      res.json({ deliveryCharge: 30, minOrderAmount: 200, maintenanceMode: false });
      return;
    }
    res.json(doc.data());
  } catch (err) {
    next(err);
  }
});

// PUT /api/settings — admin
router.put("/", adminMiddleware, async (req, res, next) => {
  try {
    await db.collection(COLLECTIONS.SETTINGS).doc("app").set(req.body, { merge: true });
    res.json({ message: "Settings updated" });
  } catch (err) {
    next(err);
  }
});

export default router;
