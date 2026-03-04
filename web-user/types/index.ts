export interface Product {
  id: string;
  name: string;
  price: number;
  discountPrice?: number;
  unit: string;
  stock: number;
  categoryId: string;
  imageUrl?: string;
  imagePublicId?: string;
  isActive: boolean;
  isFeatured?: boolean;
  description?: string;
  createdAt?: any;
}

export interface Category {
  id: string;
  name: string;
  icon?: string;
  slug: string;
  imageUrl?: string;
  imagePublicId?: string;
  order: number;
  isActive: boolean;
}

export interface CartItem extends Product {
  qty: number;
}

export interface User {
  uid: string;
  name: string;
  phone: string;
  address?: Address[];
  createdAt?: any;
}

export interface Address {
  id: string;
  label: string;
  full: string;
  area: string;
}

export interface Order {
  id: string;
  userId: string;
  items: OrderItem[];
  totalAmount: number;
  deliveryCharge: number;
  grandTotal: number;
  status: OrderStatus;
  paymentMethod: "cod" | "bkash" | "nagad" | "card";
  paymentStatus: "paid" | "unpaid";
  address: Address;
  createdAt: any;
}

export interface OrderItem {
  productId: string;
  name: string;
  price: number;
  qty: number;
  imageUrl?: string;
}

export type OrderStatus =
  | "pending"
  | "confirmed"
  | "processing"
  | "shipped"
  | "delivered"
  | "cancelled";
