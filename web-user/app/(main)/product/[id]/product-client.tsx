"use client";
import { useEffect, useState } from "react";
import { doc, getDoc } from "firebase/firestore";
import { db } from "@/lib/firebase";
import { useCartStore } from "@/store/cartStore";
import Image from "next/image";
import { ArrowLeft, Plus, Minus, ShoppingCart } from "lucide-react";
import { useRouter } from "next/navigation";
import toast from "react-hot-toast";

interface ProductClientProps {
  productId: string;
}

export default function ProductClient({ productId }: ProductClientProps) {
  const [product, setProduct] = useState<any>(null);
  const [qty, setQty] = useState(1);
  const { addItem, items, updateQty } = useCartStore();
  const router = useRouter();

  useEffect(() => {
    getDoc(doc(db, "products", productId)).then((d) => {
      if (d.exists()) setProduct({ id: d.id, ...d.data() });
    });
  }, [productId]);

  const cartItem = items.find((i) => i.id === productId);

  function handleAddToCart() {
    for (let i = 0; i < qty; i++) addItem(product);
    toast.success(`${qty}টি কার্টে যোগ হয়েছে`);
  }

  if (!product) return <div className="flex h-64 items-center justify-center text-gray-400 font-bangla">লোড হচ্ছে...</div>;

  return (
    <div>
      {/* Image */}
      <div className="relative aspect-square bg-gray-50">
        <button onClick={() => router.back()} className="absolute top-4 left-4 z-10 w-9 h-9 bg-white rounded-xl shadow flex items-center justify-center">
          <ArrowLeft size={18} className="text-gray-600" />
        </button>
        {product.imageUrl ? (
          <Image src={product.imageUrl} alt={product.name} fill className="object-cover" sizes="500px" />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-6xl">🥦</div>
        )}
      </div>

      <div className="px-4 py-4">
        <h1 className="text-xl font-bold text-gray-800 font-bangla">{product.name}</h1>
        <div className="text-gray-400 text-sm font-bangla mt-0.5">{product.unit}</div>

        <div className="flex items-center gap-3 mt-3">
          <span className="text-2xl font-bold text-[#FF6B35]">৳{product.discountPrice || product.price}</span>
          {product.discountPrice && (
            <span className="text-gray-400 line-through text-base">৳{product.price}</span>
          )}
          {product.discountPrice && (
            <span className="bg-[#D5F5E3] text-[#2ECC71] text-xs font-bold px-2 py-0.5 rounded-full font-bangla">
              {Math.round(((product.price - product.discountPrice) / product.price) * 100)}% ছাড়
            </span>
          )}
        </div>

        {product.description && (
          <p className="text-gray-500 text-sm font-bangla mt-3 leading-relaxed">{product.description}</p>
        )}

        {/* Qty selector */}
        <div className="flex items-center gap-4 mt-6">
          <div className="flex items-center gap-3 bg-gray-100 rounded-xl px-3 py-2">
            <button onClick={() => setQty(Math.max(1, qty - 1))} className="w-7 h-7 bg-white rounded-lg flex items-center justify-center shadow-sm">
              <Minus size={14} className="text-gray-600" />
            </button>
            <span className="text-gray-800 font-bold w-6 text-center">{qty}</span>
            <button onClick={() => setQty(qty + 1)} className="w-7 h-7 bg-[#2ECC71] rounded-lg flex items-center justify-center">
              <Plus size={14} className="text-white" />
            </button>
          </div>
          <button
            onClick={handleAddToCart}
            className="flex-1 bg-[#2ECC71] hover:bg-[#27AE60] text-white font-semibold py-3 rounded-xl flex items-center justify-center gap-2 transition-colors font-bangla"
          >
            <ShoppingCart size={18} />
            কার্টে যোগ করুন
          </button>
        </div>

        {cartItem && (
          <div className="mt-3 text-center text-sm text-[#2ECC71] font-bangla">
            কার্টে আছে: {cartItem.qty}টি
          </div>
        )}
      </div>
    </div>
  );
}
