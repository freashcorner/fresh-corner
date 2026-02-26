export interface Product {
  id: string;
  name: string;
  description?: string;
  price: number;
  discountPrice?: number;
  unit: string; // "kg", "liter", "piece", "dozen"
  stock: number;
  categoryId: string;
  imageUrl: string;       // Cloudinary URL
  imagePublicId: string;  // Cloudinary public ID (for delete)
  isActive: boolean;
  isFeatured?: boolean;
  tags?: string[];
  createdAt: Date;
  updatedAt: Date;
}

export interface Category {
  id: string;
  name: string;
  slug: string;
  icon?: string;          // emoji
  imageUrl?: string;      // Cloudinary URL
  imagePublicId?: string; // Cloudinary public ID
  order: number;
  isActive: boolean;
  productCount?: number;
  createdAt: Date;
}
