"use client";
import { useState } from "react";
import { useCartStore } from "@/store/cartStore";
import { useAuthStore } from "@/store/authStore";
import api from "@/lib/api";
import { useRouter } from "next/navigation";
import toast from "react-hot-toast";
import Link from "next/link";

export default function CheckoutPage() {
  const { items, total, clearCart } = useCartStore();
  const { user } = useAuthStore();
  const router = useRouter();
  const [form, setForm] = useState({ name: "", phone: "", street: "", area: "", city: "ঢাকা", note: "" });
  const [paymentMethod, setPaymentMethod] = useState("cod");
  const [loading, setLoading] = useState(false);

  const DELIVERY = 30;
  const grand = total() + DELIVERY;

  async function handleOrder(e: React.FormEvent) {
    e.preventDefault();
    if (!user) {
      router.push("/login");
      return;
    }
    setLoading(true);
    try {
      const orderItems = items.map((i) => ({
        productId: i.id,
        name: i.name,
        price: i.discountPrice || i.price,
        qty: i.qty,
        unit: i.unit,
        imageUrl: i.imageUrl,
        subtotal: (i.discountPrice || i.price) * i.qty,
      }));

      await api.post("/api/orders", {
        userName: form.name,
        userPhone: form.phone,
        items: orderItems,
        address: { label: "বাসা", street: form.street, area: form.area, city: form.city, phone: form.phone },
        paymentMethod,
        note: form.note,
      });

      clearCart();
      toast.success("অর্ডার সফল হয়েছে!");
      router.push("/orders");
    } catch {
      toast.error("অর্ডার দেওয়া যায়নি, আবার চেষ্টা করুন");
    } finally {
      setLoading(false);
    }
  }

  if (items.length === 0) {
    return (
      <div className="page-container">
        <div className="empty-state">
          <p className="font-bangla text-lg mb-4">কার্ট খালি</p>
          <Link href="/shop" className="btn-primary font-bangla">কেনাকাটা করুন</Link>
        </div>
      </div>
    );
  }

  return (
    <div className="page-container" style={{ maxWidth: '800px' }}>
      <h1 className="text-2xl font-bold font-bangla mb-6">চেকআউট</h1>

      <form onSubmit={handleOrder} className="space-y-4">
        <div className="checkout-section">
          <h2 className="font-bangla">ডেলিভারি তথ্য</h2>
          <input placeholder="নাম" value={form.name} onChange={(e) => setForm({...form, name: e.target.value})} required className="font-bangla" />
          <input placeholder="ফোন নম্বর" value={form.phone} onChange={(e) => setForm({...form, phone: e.target.value})} required />
          <input placeholder="রাস্তা ও বাড়ি নম্বর" value={form.street} onChange={(e) => setForm({...form, street: e.target.value})} required className="font-bangla" />
          <input placeholder="এলাকা" value={form.area} onChange={(e) => setForm({...form, area: e.target.value})} required className="font-bangla" />
          <textarea placeholder="বিশেষ নির্দেশনা (ঐচ্ছিক)" value={form.note} onChange={(e) => setForm({...form, note: e.target.value})} rows={2} className="font-bangla resize-none" />
        </div>

        <div className="checkout-section">
          <h2 className="font-bangla">পেমেন্ট পদ্ধতি</h2>
          <div className="space-y-3">
            {[
              { value: "cod", label: "ক্যাশ অন ডেলিভারি" },
              { value: "bkash", label: "বিকাশ" },
              { value: "nagad", label: "নগদ" },
            ].map(({ value, label }) => (
              <label key={value} className="flex items-center gap-3 cursor-pointer">
                <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center transition-colors ${paymentMethod === value ? "border-[var(--g1)]" : "border-[var(--border)]"}`}>
                  {paymentMethod === value && <div className="w-2.5 h-2.5 rounded-full bg-[var(--g1)]" />}
                </div>
                <input type="radio" name="payment" value={value} checked={paymentMethod === value} onChange={() => setPaymentMethod(value)} className="hidden" />
                <span className="text-sm font-bangla">{label}</span>
              </label>
            ))}
          </div>
        </div>

        <div className="checkout-section">
          <div className="flex justify-between text-sm text-[var(--text2)] font-bangla mb-1">
            <span>পণ্যের মূল্য ({items.length}টি)</span><span>৳{total()}</span>
          </div>
          <div className="flex justify-between text-sm text-[var(--text2)] font-bangla mb-3">
            <span>ডেলিভারি চার্জ</span><span>৳{DELIVERY}</span>
          </div>
          <div className="flex justify-between font-bold text-lg border-t border-[var(--border)] pt-3">
            <span className="font-bangla">মোট</span><span className="text-[var(--g1)]">৳{grand}</span>
          </div>
        </div>

        <button type="submit" disabled={loading} className="btn-primary w-full justify-center font-bangla text-lg disabled:opacity-50">
          {loading ? "অর্ডার হচ্ছে..." : `অর্ডার নিশ্চিত করুন — ৳${grand}`}
        </button>
      </form>
    </div>
  );
}
