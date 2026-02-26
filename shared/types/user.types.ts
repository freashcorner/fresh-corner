export interface Address {
  label: string; // "বাসা", "অফিস"
  street: string;
  area: string;
  city: string;
  phone: string;
}

export interface User {
  id: string;
  name: string;
  phone: string; // "+8801XXXXXXXX"
  email?: string;
  addresses: Address[];
  profileImage?: string;
  role: "customer" | "admin" | "rider";
  isActive: boolean;
  fcmToken?: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface AuthUser {
  uid: string;
  phone: string;
  role: "customer" | "admin" | "rider";
}
