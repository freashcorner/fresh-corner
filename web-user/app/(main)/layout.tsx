"use client";
import { useState } from "react";
import Navbar from "@/components/layout/Navbar";
import CartPanel from "@/components/layout/CartPanel";

export default function MainLayout({ children }: { children: React.ReactNode }) {
  const [cartOpen, setCartOpen] = useState(false);

  return (
    <div style={{ minHeight: "100vh", background: "var(--bg)" }}>
      <Navbar onCartOpen={() => setCartOpen(true)} />
      <CartPanel open={cartOpen} onClose={() => setCartOpen(false)} />
      <main style={{ paddingBottom: "4rem" }}>{children}</main>
    </div>
  );
}
