import type { Address } from "./user.types";

export type OrderStatus =
  | "pending"
  | "confirmed"
  | "processing"
  | "shipped"
  | "delivered"
  | "cancelled";

export type PaymentMethod = "cod" | "bkash" | "nagad" | "card";
export type PaymentStatus = "unpaid" | "paid" | "refunded";

export interface OrderItem {
  productId: string;
  name: string;
  price: number;
  qty: number;
  unit: string;
  imageUrl: string;
  subtotal: number;
}

export interface Order {
  id: string;
  userId: string;
  userName: string;
  userPhone: string;
  items: OrderItem[];
  totalAmount: number;
  deliveryCharge: number;
  grandTotal: number;
  status: OrderStatus;
  paymentMethod: PaymentMethod;
  paymentStatus: PaymentStatus;
  address: Address;
  note?: string;
  riderId?: string;
  estimatedDelivery?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export interface Delivery {
  orderId: string;
  riderId: string;
  riderName: string;
  riderPhone: string;
  status: "assigned" | "picked" | "on_way" | "delivered";
  estimatedTime?: string;
  assignedAt: Date;
  deliveredAt?: Date;
}
