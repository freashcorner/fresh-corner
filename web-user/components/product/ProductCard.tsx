"use client";
import Image from "next/image";
import Link from "next/link";
import { Plus } from "lucide-react";
import { useCartStore } from "@/store/cartStore";
import toast from "react-hot-toast";

interface Props {
  id: string;
  name: string;
  price: number;
  discountPrice?: number;
  unit: string;
  imageUrl?: string;
  categoryId?: string;
}

export default function ProductCard({ id, name, price, discountPrice, unit, imageUrl }: Props) {
  const addItem = useCartStore((s) => s.addItem);

  function handleAdd(e: React.MouseEvent) {
    e.preventDefault();
    addItem({ id, name, price, discountPrice, unit, imageUrl: imageUrl || "" });
    toast.success("কার্টে যোগ হয়েছে", { duration: 1200 });
  }

  const discount = discountPrice ? Math.round(((price - discountPrice) / price) * 100) : 0;

  return (
    <Link href={`/product/${id}`} className="product-card">
      <div className="img-wrap">
        {imageUrl ? (
          <Image src={imageUrl} alt={name} fill className="object-cover" sizes="250px" />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-4xl" style={{ background: 'var(--bg2)' }}>🥦</div>
        )}
        {discount > 0 && <div className="badge">-{discount}%</div>}
      </div>
      <div className="info">
        <div className="name font-bangla">{name}</div>
        <div className="unit font-bangla">{unit}</div>
        <div className="price-row">
          <div>
            <span className="price">৳{discountPrice || price}</span>
            {discountPrice && <span className="old-price">৳{price}</span>}
          </div>
          <button onClick={handleAdd} className="add-btn">
            <Plus size={16} />
          </button>
        </div>
      </div>
    </Link>
  );
}
