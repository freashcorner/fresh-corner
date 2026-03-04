"use client";
import { useCartStore } from "@/store/cartStore";
import { X, Plus, Minus, Trash2, ShoppingBag } from "lucide-react";
import Image from "next/image";
import Link from "next/link";

interface Props {
  open: boolean;
  onClose: () => void;
}

export default function CartPanel({ open, onClose }: Props) {
  const { items, updateQty, removeItem, total, count } = useCartStore();
  const DELIVERY = 30;
  const grand = total() + DELIVERY;

  return (
    <>
      <div className={`cart-overlay ${open ? "open" : ""}`} onClick={onClose} />
      <div className={`cart-panel ${open ? "open" : ""}`}>
        <div className="header">
          <h3 className="font-bold text-lg">কার্ট ({count()}টি)</h3>
          <button onClick={onClose} className="text-[var(--text2)] hover:text-[var(--g1)] transition-colors">
            <X size={22} />
          </button>
        </div>

        <div className="body">
          {items.length === 0 ? (
            <div className="empty-state">
              <div className="icon"><ShoppingBag size={48} /></div>
              <p className="font-bangla">কার্ট খালি</p>
            </div>
          ) : (
            items.map((item) => (
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
                  <button onClick={() => removeItem(item.id)} className="text-red-400 hover:text-red-500 transition-colors">
                    <Trash2 size={14} />
                  </button>
                  <div className="qty-control">
                    <button onClick={() => updateQty(item.id, item.qty - 1)}><Minus size={12} /></button>
                    <span>{item.qty}</span>
                    <button onClick={() => updateQty(item.id, item.qty + 1)}><Plus size={12} /></button>
                  </div>
                </div>
              </div>
            ))
          )}
        </div>

        {items.length > 0 && (
          <div className="footer">
            <div className="flex justify-between text-sm text-[var(--text2)] font-bangla mb-1">
              <span>পণ্যের মূল্য</span><span>৳{total()}</span>
            </div>
            <div className="flex justify-between text-sm text-[var(--text2)] font-bangla mb-3">
              <span>ডেলিভারি চার্জ</span><span>৳{DELIVERY}</span>
            </div>
            <div className="flex justify-between font-bold text-lg mb-4 border-t border-[var(--border)] pt-3">
              <span>মোট</span><span className="text-[var(--g1)]">৳{grand}</span>
            </div>
            <Link href="/checkout" onClick={onClose} className="btn-primary w-full justify-center font-bangla">
              চেকআউট করুন — ৳{grand}
            </Link>
          </div>
        )}
      </div>
    </>
  );
}
