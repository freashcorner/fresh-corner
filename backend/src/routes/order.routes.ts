import { Router } from "express";
import { db, COLLECTIONS } from "../services/firebase.service";
import { authMiddleware, adminMiddleware, AuthRequest } from "../middleware/auth.middleware";
import { sendOrderStatusNotification } from "../services/notification.service";
import { v4 as uuidv4 } from "uuid";

const router = Router();

// POST /api/orders — customer creates order
router.post("/", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const id = uuidv4();
    const settingsDoc = await db.collection(COLLECTIONS.SETTINGS).doc("app").get();
    const deliveryCharge = settingsDoc.data()?.deliveryCharge ?? 30;

    const totalAmount = req.body.items.reduce(
      (sum: number, item: any) => sum + item.price * item.qty,
      0
    );

    const order = {
      ...req.body,
      id,
      userId: req.user!.uid,
      totalAmount,
      deliveryCharge,
      grandTotal: totalAmount + deliveryCharge,
      status: "pending",
      paymentStatus: "unpaid",
      createdAt: new Date(),
      updatedAt: new Date(),
    };
    await db.collection(COLLECTIONS.ORDERS).doc(id).set(order);
    res.status(201).json(order);
  } catch (err) {
    next(err);
  }
});

// GET /api/orders/my — customer's own orders
router.get("/my", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const snapshot = await db
      .collection(COLLECTIONS.ORDERS)
      .where("userId", "==", req.user!.uid)
      .orderBy("createdAt", "desc")
      .get();
    const orders = snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
    res.json(orders);
  } catch (err) {
    next(err);
  }
});

// GET /api/orders — admin: all orders
router.get("/", adminMiddleware, async (req, res, next) => {
  try {
    const { status, limit = "50" } = req.query;
    let query: FirebaseFirestore.Query = db
      .collection(COLLECTIONS.ORDERS)
      .orderBy("createdAt", "desc")
      .limit(Number(limit));
    if (status) query = query.where("status", "==", status);
    const snapshot = await query.get();
    const orders = snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
    res.json(orders);
  } catch (err) {
    next(err);
  }
});

// GET /api/orders/:id
router.get("/:id", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const doc = await db.collection(COLLECTIONS.ORDERS).doc(req.params.id).get();
    if (!doc.exists) {
      res.status(404).json({ error: "Order not found" });
      return;
    }
    const data = doc.data() as any;
    // customer can only see own orders
    if (req.user?.role !== "admin" && data.userId !== req.user?.uid) {
      res.status(403).json({ error: "Forbidden" });
      return;
    }
    res.json({ id: doc.id, ...data });
  } catch (err) {
    next(err);
  }
});

// PATCH /api/orders/:id/status — admin updates status
router.patch("/:id/status", adminMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const { status } = req.body;
    const ref = db.collection(COLLECTIONS.ORDERS).doc(req.params.id);
    const doc = await ref.get();
    if (!doc.exists) {
      res.status(404).json({ error: "Order not found" });
      return;
    }
    await ref.update({ status, updatedAt: new Date() });
    const data = doc.data() as any;
    await sendOrderStatusNotification(data.userId, req.params.id, status);
    res.json({ message: "Order status updated", status });
  } catch (err) {
    next(err);
  }
});

export default router;
