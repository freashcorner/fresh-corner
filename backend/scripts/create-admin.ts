/**
 * Create an admin user in Firebase Auth + Firestore
 *
 * Usage:
 *   npx ts-node scripts/create-admin.ts <email> <password> <name>
 *
 * Example:
 *   npx ts-node scripts/create-admin.ts admin@freshcorner.com MyPass123 "Admin"
 */

import * as admin from "firebase-admin";
import dotenv from "dotenv";
import path from "path";

dotenv.config({ path: path.resolve(__dirname, "../.env") });

if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert({
      projectId: process.env.FIREBASE_PROJECT_ID,
      privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, "\n"),
      clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    }),
  });
}

const auth = admin.auth();
const db = admin.firestore();

async function createAdmin() {
  const [email, password, name] = process.argv.slice(2);

  if (!email || !password) {
    console.error("Usage: npx ts-node scripts/create-admin.ts <email> <password> [name]");
    process.exit(1);
  }

  try {
    // Create user in Firebase Auth
    const user = await auth.createUser({
      email,
      password,
      displayName: name || "Admin",
    });

    // Set admin custom claim
    await auth.setCustomUserClaims(user.uid, { role: "admin" });

    // Save to Firestore
    await db.collection("users").doc(user.uid).set({
      id: user.uid,
      name: name || "Admin",
      email,
      role: "admin",
      isActive: true,
      createdAt: new Date(),
      updatedAt: new Date(),
    });

    console.log("Admin user created successfully!");
    console.log(`  UID:   ${user.uid}`);
    console.log(`  Email: ${email}`);
    console.log(`  Role:  admin`);
    process.exit(0);
  } catch (err: any) {
    if (err.code === "auth/email-already-exists") {
      // User exists, just set admin claim
      const existing = await auth.getUserByEmail(email);
      await auth.setCustomUserClaims(existing.uid, { role: "admin" });
      await db.collection("users").doc(existing.uid).set(
        { role: "admin", updatedAt: new Date() },
        { merge: true }
      );
      console.log("User already existed. Updated role to admin!");
      console.log(`  UID:   ${existing.uid}`);
      console.log(`  Email: ${email}`);
      process.exit(0);
    }
    console.error("Error:", err.message);
    process.exit(1);
  }
}

createAdmin();
