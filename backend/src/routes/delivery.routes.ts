import { Router } from "express";
import { db, COLLECTIONS } from "../services/firebase.service";
import { adminMiddleware, AuthRequest } from "../middleware/auth.middleware";

const router = Router();

// POST /api/delivery/assign — admin assigns rider to order
router.post("/assign", adminMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const { orderId, riderId, riderName, riderPhone, estimatedTime } = req.body;
    const delivery = {
      orderId,
      riderId,
      riderName,
      riderPhone,
      status: "assigned",
      estimatedTime,
      assignedAt: new Date(),
    };
    await db.collection(COLLECTIONS.DELIVERIES).doc(orderId).set(delivery);
    await db.collection(COLLECTIONS.ORDERS).doc(orderId).update({
      riderId,
      status: "shipped",
      updatedAt: new Date(),
    });
    res.status(201).json(delivery);
  } catch (err) {
    next(err);
  }
});

// GET /api/delivery — admin: all deliveries
router.get("/", adminMiddleware, async (_req, res, next) => {
  try {
    const snapshot = await db
      .collection(COLLECTIONS.DELIVERIES)
      .orderBy("assignedAt", "desc")
      .get();
    const deliveries = snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
    res.json(deliveries);
  } catch (err) {
    next(err);
  }
});

// PATCH /api/delivery/:orderId/status
router.patch("/:orderId/status", adminMiddleware, async (req, res, next) => {
  try {
    const { status } = req.body;
    const ref = db.collection(COLLECTIONS.DELIVERIES).doc(req.params.orderId);
    const update: any = { status };
    if (status === "delivered") update.deliveredAt = new Date();
    await ref.update(update);
    res.json({ message: "Delivery status updated" });
  } catch (err) {
    next(err);
  }
});

export default router;
