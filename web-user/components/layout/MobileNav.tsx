"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { Home, Store, ClipboardList, User } from "lucide-react";
import { useCartStore } from "@/store/cartStore";

const NAV = [
  { href: "/", label: "হোম", icon: Home },
  { href: "/shop", label: "শপ", icon: Store },
  { href: "/orders", label: "অর্ডার", icon: ClipboardList },
  { href: "/profile", label: "প্রোফাইল", icon: User },
];

export default function MobileNav() {
  const pathname = usePathname();
  const count = useCartStore((s) => s.count());

  return (
    <nav className="mobile-nav">
      {NAV.map(({ href, label, icon: Icon }) => {
        const isActive = href === "/" ? pathname === "/" : pathname.startsWith(href);
        return (
          <Link
            key={href}
            href={href}
            className={`mobile-nav-item ${isActive ? "active" : ""}`}
          >
            <Icon size={20} />
            <span>{label}</span>
            {href === "/cart" && count > 0 && (
              <span className="badge-count">{count}</span>
            )}
          </Link>
        );
      })}
    </nav>
  );
}
