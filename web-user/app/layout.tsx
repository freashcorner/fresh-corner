"use client";
import { useState } from "react";
import Navbar from "@/components/layout/Navbar";
import CartPanel from "@/components/layout/CartPanel";

export default function MainLayout({ children }: { children: React.ReactNode }) {
  const [cartOpen, setCartOpen] = useState(false);

  return (
    <div className="min-h-screen" style={{ background: "var(--bg)" }}>
      <Navbar onCartOpen={() => setCartOpen(true)} />
      <CartPanel open={cartOpen} onClose={() => setCartOpen(false)} />
      <main className="pb-16 md:pb-0">{children}</main>
    </div>
  );
}
