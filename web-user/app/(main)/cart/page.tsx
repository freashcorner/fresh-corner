"use client";
import { useCartStore } from "@/store/cartStore";
import Image from "next/image";
import Link from "next/link";
import { Plus, Minus, Trash2, ShoppingBag } from "lucide-react";

export default function CartPage() {
  const { items, updateQty, removeItem, total } = useCartStore();

  if (items.length === 0) {
    return (
      <div className="page-container">
        <div className="empty-state">
          <div className="icon"><ShoppingBag size={48} /></div>
          <p className="font-bangla text-lg mb-4">কার্ট খালি</p>
          <Link href="/shop" className="btn-primary font-bangla">কেনাকাটা করুন</Link>
        </div>
      </div>
    );
  }

  const DELIVERY = 30;
  const grand = total() + DELIVERY;

  return (
    <div className="page-container" style={{ maxWidth: '800px' }}>
      <h1 className="text-2xl font-bold font-bangla mb-6">কার্ট ({items.length}টি)</h1>

      <div className="space-y-3 mb-6">
        {items.map((item) => (
          <div key={item.id} className="cart-item">
            <div className="thumb">
              {item.imageUrl ? (
                <Image src={item.imageUrl} alt={item.name} width={60} height={60} className="object-cover w-full h-full" />
              ) : (
                <div className="w-full h-full flex items-center justify-center text-2xl">🥦</div>
              )}
            </div>
            <div className="details">
              <div className="item-name font-bangla">{item.name}</div>
              <div className="item-unit font-bangla">{item.unit}</div>
              <div className="item-price">৳{(item.discountPrice || item.price) * item.qty}</div>
            </div>
            <div className="flex flex-col items-end justify-between">
              <button onClick={() => removeItem(item.id)} className="text-red-400 hover:text-red-500">
                <Trash2 size={14} />
              </button>
              <div className="qty-control">
                <button onClick={() => updateQty(item.id, item.qty - 1)}><Minus size={12} /></button>
                <span>{item.qty}</span>
                <button onClick={() => updateQty(item.id, item.qty + 1)}><Plus size={12} /></button>
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="glass-card p-5 mb-4">
        <div className="flex justify-between text-sm text-[var(--text2)] font-bangla mb-2">
          <span>পণ্যের মূল্য</span><span>৳{total()}</span>
        </div>
        <div className="flex justify-between text-sm text-[var(--text2)] font-bangla mb-3">
          <span>ডেলিভারি চার্জ</span><span>৳{DELIVERY}</span>
        </div>
        <div className="flex justify-between font-bold text-lg border-t border-[var(--border)] pt-3">
          <span className="font-bangla">মোট</span><span className="text-[var(--g1)]">৳{grand}</span>
        </div>
      </div>

      <Link href="/checkout" className="btn-primary w-full justify-center font-bangla text-lg">
        অর্ডার করুন → ৳{grand}
      </Link>
    </div>
  );
}
