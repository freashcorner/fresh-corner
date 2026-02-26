import { Router } from "express";
import { authMiddleware, AuthRequest } from "../middleware/auth.middleware";
import { db, auth, COLLECTIONS } from "../services/firebase.service";

const router = Router();

// POST /api/auth/register — save user profile after Firebase phone auth
router.post("/register", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const { name, phone } = req.body;
    const uid = req.user!.uid;

    const userRef = db.collection(COLLECTIONS.USERS).doc(uid);
    const existing = await userRef.get();
    if (existing.exists) {
      res.json({ message: "User already exists", user: existing.data() });
      return;
    }

    const user = {
      id: uid,
      name,
      phone,
      addresses: [],
      role: "customer",
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    await userRef.set(user);
    // Set custom claim
    await auth.setCustomUserClaims(uid, { role: "customer" });
    res.status(201).json({ message: "User registered", user });
  } catch (err) {
    next(err);
  }
});

// GET /api/auth/me
router.get("/me", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const doc = await db.collection(COLLECTIONS.USERS).doc(req.user!.uid).get();
    if (!doc.exists) {
      res.status(404).json({ error: "User not found" });
      return;
    }
    res.json(doc.data());
  } catch (err) {
    next(err);
  }
});

// PUT /api/auth/fcm-token
router.put("/fcm-token", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const { fcmToken } = req.body;
    await db.collection(COLLECTIONS.USERS).doc(req.user!.uid).update({ fcmToken });
    res.json({ message: "FCM token updated" });
  } catch (err) {
    next(err);
  }
});

export default router;
