"use client";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { useCartStore } from "@/store/cartStore";
import { ShoppingCart, Home, Store, ClipboardList, MapPin, User, Bell, MessageCircle, Settings, Menu, X } from "lucide-react";
import { useState } from "react";

const TABS = [
  { href: "/", label: "হোম", icon: Home },
  { href: "/shop", label: "শপ", icon: Store },
  { href: "/orders", label: "অর্ডার", icon: ClipboardList },
  { href: "/tracking", label: "ট্র্যাকিং", icon: MapPin },
  { href: "/profile", label: "প্রোফাইল", icon: User },
  { href: "/notifications", label: "নোটিফিকেশন", icon: Bell },
  { href: "/chat", label: "চ্যাট", icon: MessageCircle },
  { href: "/settings", label: "সেটিংস", icon: Settings },
];

const MOBILE_TABS = [
  { href: "/", label: "হোম", icon: Home },
  { href: "/shop", label: "শপ", icon: Store },
  { href: "/orders", label: "অর্ডার", icon: ClipboardList },
  { href: "/profile", label: "প্রোফাইল", icon: User },
  { href: "/chat", label: "চ্যাট", icon: MessageCircle },
];

export default function Navbar({ onCartOpen }: { onCartOpen: () => void }) {
  const pathname = usePathname();
  const count = useCartStore((s) => s.count());
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const isActive = (href: string) => href === "/" ? pathname === "/" : pathname.startsWith(href);

  return (
    <>
      <nav className="topnav">
        <div className="flex items-center gap-6">
          <Link href="/" className="flex items-center gap-2">
            <img src="/icon.svg" alt="Fresh Corner" className="w-8 h-8 rounded-lg" />
            <span className="text-[var(--g1)] font-bold text-lg font-tiro">ফ্রেশ কর্নার</span>
          </Link>
          <div className="nav-tabs">
            {TABS.map(({ href, label, icon: Icon }) => (
              <Link key={href} href={href} className={`nav-tab ${isActive(href) ? "active" : ""}`}>
                <Icon size={16} />
                {label}
              </Link>
            ))}
          </div>
        </div>

        <div className="flex items-center gap-3">
          <button onClick={onCartOpen} className="relative bg-[rgba(46,204,113,0.1)] hover:bg-[rgba(46,204,113,0.2)] rounded-xl p-2.5 transition-colors">
            <ShoppingCart size={20} className="text-[var(--g1)]" />
            {count > 0 && (
              <span className="absolute -top-1 -right-1 bg-[var(--o1)] text-white text-[10px] font-bold w-5 h-5 rounded-full flex items-center justify-center">
                {count > 9 ? "9+" : count}
              </span>
            )}
          </button>
          <button onClick={() => setMobileMenuOpen(!mobileMenuOpen)} className="lg:hidden bg-[rgba(46,204,113,0.1)] rounded-xl p-2.5">
            {mobileMenuOpen ? <X size={20} className="text-[var(--g1)]" /> : <Menu size={20} className="text-[var(--g1)]" />}
          </button>
        </div>
      </nav>

      {/* Mobile Menu */}
      {mobileMenuOpen && (
        <div className="fixed top-[64px] left-0 right-0 z-[99] glass p-4 lg:hidden">
          <div className="grid grid-cols-4 gap-2">
            {TABS.map(({ href, label, icon: Icon }) => (
              <Link
                key={href}
                href={href}
                onClick={() => setMobileMenuOpen(false)}
                className={`flex flex-col items-center gap-1 p-2 rounded-xl text-xs transition-colors ${isActive(href) ? "text-[var(--g1)] bg-[rgba(46,204,113,0.1)]" : "text-[var(--text2)]"}`}
              >
                <Icon size={18} />
                {label}
              </Link>
            ))}
          </div>
        </div>
      )}

      {/* Mobile Bottom Nav */}
      <nav className="mobile-nav">
        {MOBILE_TABS.map(({ href, label, icon: Icon }) => (
          <Link key={href} href={href} className={`mobile-nav-item ${isActive(href) ? "active" : ""}`}>
            <Icon size={20} />
            {label}
          </Link>
        ))}
      </nav>
    </>
  );
}
