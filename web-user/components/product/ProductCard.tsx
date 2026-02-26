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
  imageUrl: string;
}

export default function ProductCard({ id, name, price, discountPrice, unit, imageUrl }: Props) {
  const addItem = useCartStore((s) => s.addItem);

  function handleAdd(e: React.MouseEvent) {
    e.preventDefault();
    addItem({ id, name, price, discountPrice, unit, imageUrl });
    toast.success("কার্টে যোগ হয়েছে", { duration: 1200 });
  }

  return (
    <Link href={`/product/${id}`} className="block bg-white rounded-xl shadow-sm overflow-hidden hover:shadow-md transition-shadow">
      <div className="aspect-square bg-gray-50 relative">
        {imageUrl ? (
          <Image src={imageUrl} alt={name} fill className="object-cover" sizes="200px" />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-4xl">🥦</div>
        )}
      </div>
      <div className="p-2.5">
        <div className="text-sm font-medium text-gray-800 font-bangla line-clamp-2 leading-tight mb-1">{name}</div>
        <div className="text-xs text-gray-400 font-bangla">{unit}</div>
        <div className="flex items-center justify-between mt-2">
          <div>
            <span className="text-[#FF6B35] font-bold text-sm">৳{discountPrice || price}</span>
            {discountPrice && <span className="text-gray-300 text-xs line-through ml-1">৳{price}</span>}
          </div>
          <button
            onClick={handleAdd}
            className="w-7 h-7 bg-[#2ECC71] hover:bg-[#27AE60] rounded-full flex items-center justify-center transition-colors shadow-sm"
          >
            <Plus size={14} className="text-white" />
          </button>
        </div>
      </div>
    </Link>
  );
}
