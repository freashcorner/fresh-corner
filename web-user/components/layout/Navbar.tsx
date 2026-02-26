"use client";
import Link from "next/link";
import { useCartStore } from "@/store/cartStore";
import { ShoppingCart, MapPin } from "lucide-react";

export default function Navbar() {
  const count = useCartStore((s) => s.count());

  return (
    <header className="sticky top-0 z-50 bg-[#2ECC71] shadow-md">
      <div className="max-w-lg mx-auto px-4 py-3 flex items-center justify-between">
        <div>
          <Link href="/" className="text-white font-bold text-lg font-tiro">ফ্রেশ কর্নার</Link>
          <div className="flex items-center gap-1 text-white/80 text-xs mt-0.5">
            <MapPin size={10} /> ঢাকা, বাংলাদেশ
          </div>
        </div>
        <Link href="/cart" className="relative bg-white/20 hover:bg-white/30 rounded-full p-2 transition-colors">
          <ShoppingCart size={20} className="text-white" />
          {count > 0 && (
            <span className="absolute -top-1 -right-1 bg-[#FF6B35] text-white text-[10px] font-bold w-4 h-4 rounded-full flex items-center justify-center">
              {count > 9 ? "9+" : count}
            </span>
          )}
        </Link>
      </div>
    </header>
  );
}
