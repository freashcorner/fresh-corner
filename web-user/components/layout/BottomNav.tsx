"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Home, Grid, ShoppingCart, ClipboardList, User } from "lucide-react";
import { useCartStore } from "@/store/cartStore";
import clsx from "clsx";

const NAV = [
  { href: "/", label: "হোম", icon: Home },
  { href: "/categories", label: "ক্যাটাগরি", icon: Grid },
  { href: "/cart", label: "কার্ট", icon: ShoppingCart },
  { href: "/orders", label: "অর্ডার", icon: ClipboardList },
  { href: "/profile", label: "প্রোফাইল", icon: User },
];

export default function BottomNav() {
  const pathname = usePathname();
  const count = useCartStore((s) => s.count());

  return (
    <nav className="fixed bottom-0 left-0 right-0 bg-white border-t border-gray-100 z-40 safe-bottom">
      <div className="max-w-lg mx-auto flex">
        {NAV.map(({ href, label, icon: Icon }) => {
          const isActive = href === "/" ? pathname === "/" : pathname.startsWith(href);
          return (
            <Link
              key={href}
              href={href}
              className={clsx(
                "flex-1 flex flex-col items-center justify-center gap-0.5 py-2 text-[10px] font-semibold transition-colors",
                isActive ? "text-[#2ECC71]" : "text-gray-400"
              )}
            >
              <div className="relative">
                <Icon size={20} />
                {href === "/cart" && count > 0 && (
                  <span className="absolute -top-1 -right-1 bg-[#FF6B35] text-white text-[8px] font-bold w-3.5 h-3.5 rounded-full flex items-center justify-center">{count}</span>
                )}
              </div>
              {label}
            </Link>
          );
        })}
      </div>
    </nav>
  );
}
