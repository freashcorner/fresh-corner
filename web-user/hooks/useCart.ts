"use client";
import { useCartStore } from "@/store/cartStore";

export function useCart() {
  const { items, addItem, removeItem, updateQty, clearCart, total, count } = useCartStore();
  const DELIVERY = 30;
  const grandTotal = total() + DELIVERY;

  return {
    items,
    addItem,
    removeItem,
    updateQty,
    clearCart,
    total: total(),
    count: count(),
    deliveryCharge: DELIVERY,
    grandTotal,
    isEmpty: items.length === 0,
  };
}
