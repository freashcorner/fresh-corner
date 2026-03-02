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
