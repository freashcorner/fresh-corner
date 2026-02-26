"use client";
import { useCartStore } from "@/store/cartStore";
import Image from "next/image";
import Link from "next/link";
import { Plus, Minus, Trash2, ShoppingBag } from "lucide-react";

export default function CartPage() {
  const { items, updateQty, removeItem, total } = useCartStore();

  if (items.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center h-64 gap-4">
        <ShoppingBag size={48} className="text-gray-300" />
        <div className="text-gray-400 font-bangla text-sm">কার্ট খালি</div>
        <Link href="/" className="bg-[#2ECC71] text-white px-6 py-2.5 rounded-xl text-sm font-bangla">কেনাকাটা করুন</Link>
      </div>
    );
  }

  const DELIVERY = 30;
  const grand = total() + DELIVERY;

  return (
    <div className="px-4 py-4">
      <h1 className="text-lg font-bold text-gray-800 font-bangla mb-4">কার্ট ({items.length}টি)</h1>

      <div className="space-y-3 mb-4">
        {items.map((item) => (
          <div key={item.id} className="bg-white rounded-xl p-3 flex gap-3 shadow-sm">
            <div className="w-16 h-16 rounded-lg bg-gray-50 overflow-hidden flex-shrink-0">
              {item.imageUrl ? (
                <Image src={item.imageUrl} alt={item.name} width={64} height={64} className="object-cover w-full h-full" />
              ) : (
                <div className="w-full h-full flex items-center justify-center text-2xl">🥦</div>
              )}
            </div>
            <div className="flex-1 min-w-0">
              <div className="text-sm font-medium text-gray-800 font-bangla truncate">{item.name}</div>
              <div className="text-xs text-gray-400 font-bangla">{item.unit}</div>
              <div className="text-[#FF6B35] font-bold text-sm mt-1">৳{(item.discountPrice || item.price) * item.qty}</div>
            </div>
            <div className="flex flex-col items-end justify-between">
              <button onClick={() => removeItem(item.id)} className="text-red-400 hover:text-red-600">
                <Trash2 size={14} />
              </button>
              <div className="flex items-center gap-2 bg-gray-100 rounded-lg px-2 py-1">
                <button onClick={() => updateQty(item.id, item.qty - 1)} className="text-gray-500">
                  <Minus size={12} />
                </button>
                <span className="text-gray-800 font-bold text-xs w-4 text-center">{item.qty}</span>
                <button onClick={() => updateQty(item.id, item.qty + 1)} className="text-[#2ECC71]">
                  <Plus size={12} />
                </button>
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Summary */}
      <div className="bg-white rounded-xl p-4 shadow-sm mb-4">
        <div className="flex justify-between text-sm text-gray-600 font-bangla mb-2">
          <span>পণ্যের মূল্য</span><span>৳{total()}</span>
        </div>
        <div className="flex justify-between text-sm text-gray-600 font-bangla mb-3">
          <span>ডেলিভারি চার্জ</span><span>৳{DELIVERY}</span>
        </div>
        <div className="flex justify-between font-bold text-gray-800 font-bangla text-base border-t pt-3">
          <span>মোট</span><span className="text-[#FF6B35]">৳{grand}</span>
        </div>
      </div>

      <Link
        href="/checkout"
        className="w-full bg-[#2ECC71] hover:bg-[#27AE60] text-white font-bold py-3.5 rounded-xl flex items-center justify-center text-base transition-colors font-bangla"
      >
        অর্ডার করুন → ৳{grand}
      </Link>
    </div>
  );
}
