import { Router } from "express";
import { db, COLLECTIONS } from "../services/firebase.service";
import { authMiddleware, adminMiddleware, AuthRequest } from "../middleware/auth.middleware";

const router = Router();

// GET /api/users — admin
router.get("/", adminMiddleware, async (_req, res, next) => {
  try {
    const snapshot = await db
      .collection(COLLECTIONS.USERS)
      .orderBy("createdAt", "desc")
      .get();
    const users = snapshot.docs.map((d) => ({ id: d.id, ...d.data() }));
    res.json(users);
  } catch (err) {
    next(err);
  }
});

// PUT /api/users/me — customer updates own profile
router.put("/me", authMiddleware, async (req: AuthRequest, res, next) => {
  try {
    const { name, addresses } = req.body;
    await db
      .collection(COLLECTIONS.USERS)
      .doc(req.user!.uid)
      .update({ name, addresses, updatedAt: new Date() });
    res.json({ message: "Profile updated" });
  } catch (err) {
    next(err);
  }
});

// PATCH /api/users/:id/role — admin changes role
router.patch("/:id/role", adminMiddleware, async (req, res, next) => {
  try {
    const { role } = req.body;
    await db
      .collection(COLLECTIONS.USERS)
      .doc(req.params.id)
      .update({ role, updatedAt: new Date() });
    res.json({ message: "Role updated" });
  } catch (err) {
    next(err);
  }
});

export default router;
