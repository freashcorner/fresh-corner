import { messaging, db, COLLECTIONS } from "./firebase.service";

export async function sendNotificationToUser(
  userId: string,
  title: string,
  body: string,
  data?: Record<string, string>
): Promise<void> {
  const userDoc = await db.collection(COLLECTIONS.USERS).doc(userId).get();
  const fcmToken = userDoc.data()?.fcmToken;
  if (!fcmToken) return;

  await messaging.send({
    token: fcmToken,
    notification: { title, body },
    data,
    android: { priority: "high" },
  });
}

export async function sendOrderStatusNotification(
  userId: string,
  orderId: string,
  status: string
): Promise<void> {
  const statusMessages: Record<string, string> = {
    confirmed: "আপনার অর্ডার নিশ্চিত হয়েছে",
    processing: "আপনার অর্ডার প্রস্তুত হচ্ছে",
    shipped: "আপনার অর্ডার পাঠানো হয়েছে",
    delivered: "আপনার অর্ডার পৌঁছে গেছে",
    cancelled: "আপনার অর্ডার বাতিল হয়েছে",
  };

  await sendNotificationToUser(
    userId,
    "ফ্রেশ কর্নার — অর্ডার আপডেট",
    statusMessages[status] || "অর্ডার আপডেট হয়েছে",
    { orderId, status }
  );
}
