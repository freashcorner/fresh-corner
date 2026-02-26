import { Router } from "express";
import { authMiddleware, AuthRequest } from "../middleware/auth.middleware";
import { db, COLLECTIONS } from "../services/firebase.service";

const router = Router();

// POST /api/payment/cod — Cash on Delivery confirmation
router.post("/cod", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const { orderId } = req.body;
    const ref = db.collection(COLLECTIONS.ORDERS).doc(orderId);
    const doc = await ref.get();
    if (!doc.exists) {
      res.status(404).json({ error: "Order not found" });
      return;
    }
    const data = doc.data() as any;
    if (data.userId !== req.user!.uid) {
      res.status(403).json({ error: "Forbidden" });
      return;
    }
    await ref.update({ paymentMethod: "cod", status: "confirmed", updatedAt: new Date() });
    res.json({ message: "COD order confirmed", orderId });
  } catch (err) {
    next(err);
  }
});

// Placeholder: POST /api/payment/bkash
router.post("/bkash", authMiddleware, async (_req, res) => {
  res.json({ message: "bKash payment integration coming soon" });
});

// POST /api/payment/verify — admin marks order as paid
router.post("/verify", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const { orderId } = req.body;
    await db
      .collection(COLLECTIONS.ORDERS)
      .doc(orderId)
      .update({ paymentStatus: "paid", updatedAt: new Date() });
    res.json({ message: "Payment verified", orderId });
  } catch (err) {
    next(err);
  }
});

export default router;
