export const ORDER_STATUS = {
  PENDING: "pending",
  CONFIRMED: "confirmed",
  PROCESSING: "processing",
  SHIPPED: "shipped",
  DELIVERED: "delivered",
  CANCELLED: "cancelled",
} as const;

export const ORDER_STATUS_LABEL: Record<string, string> = {
  pending: "অপেক্ষমান",
  confirmed: "নিশ্চিত",
  processing: "প্রস্তুত হচ্ছে",
  shipped: "পাঠানো হয়েছে",
  delivered: "পৌঁছে গেছে",
  cancelled: "বাতিল",
};

export const PAYMENT_STATUS_LABEL: Record<string, string> = {
  unpaid: "অপরিশোধিত",
  paid: "পরিশোধিত",
  refunded: "ফেরত",
};
