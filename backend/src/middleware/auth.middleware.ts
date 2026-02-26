import { Request, Response, NextFunction } from "express";
import { auth } from "../services/firebase.service";

export interface AuthRequest extends Request {
  user?: {
    uid: string;
    phone?: string;
    email?: string;
    role?: string;
  };
}

export async function authMiddleware(
  req: AuthRequest,
  res: Response,
  next: NextFunction
): Promise<void> {
  try {
    const token = req.headers.authorization?.split("Bearer ")[1];
    if (!token) {
      res.status(401).json({ error: "No token provided" });
      return;
    }
    const decoded = await auth.verifyIdToken(token);
    req.user = {
      uid: decoded.uid,
      phone: decoded.phone_number,
      email: decoded.email,
      role: (decoded as any).role || "customer",
    };
    next();
  } catch {
    res.status(401).json({ error: "Invalid or expired token" });
  }
}

export async function adminMiddleware(
  req: AuthRequest,
  res: Response,
  next: NextFunction
): Promise<void> {
  await authMiddleware(req, res, async () => {
    if (req.user?.role !== "admin") {
      res.status(403).json({ error: "Admin access required" });
      return;
    }
    next();
  });
}
