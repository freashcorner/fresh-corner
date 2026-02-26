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
      <div className="flex flex-col items-center justify-center h-64">
        <div className="text-gray-400 font-bangla mb-4">কার্ট খালি</div>
        <Link href="/" className="bg-[#2ECC71] text-white px-6 py-2.5 rounded-xl text-sm font-bangla">কেনাকাটা করুন</Link>
      </div>
    );
  }

  return (
    <div className="px-4 py-4">
      <h1 className="text-lg font-bold text-gray-800 font-bangla mb-4">চেকআউট</h1>

      <form onSubmit={handleOrder} className="space-y-4">
        {/* Delivery Address */}
        <div className="bg-white rounded-xl p-4 shadow-sm">
          <h2 className="text-sm font-semibold text-gray-700 font-bangla mb-3">ডেলিভারি তথ্য</h2>
          <div className="space-y-2.5">
            <input placeholder="নাম" value={form.name} onChange={(e) => setForm({...form, name: e.target.value})} required className="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm outline-none focus:border-[#2ECC71] font-bangla" />
            <input placeholder="ফোন নম্বর" value={form.phone} onChange={(e) => setForm({...form, phone: e.target.value})} required className="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm outline-none focus:border-[#2ECC71]" />
            <input placeholder="রাস্তা ও বাড়ি নম্বর" value={form.street} onChange={(e) => setForm({...form, street: e.target.value})} required className="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm outline-none focus:border-[#2ECC71] font-bangla" />
            <input placeholder="এলাকা" value={form.area} onChange={(e) => setForm({...form, area: e.target.value})} required className="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm outline-none focus:border-[#2ECC71] font-bangla" />
            <textarea placeholder="বিশেষ নির্দেশনা (ঐচ্ছিক)" value={form.note} onChange={(e) => setForm({...form, note: e.target.value})} rows={2} className="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm outline-none focus:border-[#2ECC71] resize-none font-bangla" />
          </div>
        </div>

        {/* Payment */}
        <div className="bg-white rounded-xl p-4 shadow-sm">
          <h2 className="text-sm font-semibold text-gray-700 font-bangla mb-3">পেমেন্ট পদ্ধতি</h2>
          <div className="space-y-2">
            {[
              { value: "cod", label: "ক্যাশ অন ডেলিভারি" },
              { value: "bkash", label: "বিকাশ" },
              { value: "nagad", label: "নগদ" },
            ].map(({ value, label }) => (
              <label key={value} className="flex items-center gap-3 cursor-pointer">
                <div className={`w-5 h-5 rounded-full border-2 flex items-center justify-center transition-colors ${paymentMethod === value ? "border-[#2ECC71]" : "border-gray-300"}`}>
                  {paymentMethod === value && <div className="w-2.5 h-2.5 rounded-full bg-[#2ECC71]" />}
                </div>
                <input type="radio" name="payment" value={value} checked={paymentMethod === value} onChange={() => setPaymentMethod(value)} className="hidden" />
                <span className="text-sm text-gray-700 font-bangla">{label}</span>
              </label>
            ))}
          </div>
        </div>

        {/* Summary */}
        <div className="bg-white rounded-xl p-4 shadow-sm">
          <div className="flex justify-between text-sm text-gray-600 font-bangla mb-1">
            <span>পণ্যের মূল্য ({items.length}টি)</span><span>৳{total()}</span>
          </div>
          <div className="flex justify-between text-sm text-gray-600 font-bangla mb-2">
            <span>ডেলিভারি চার্জ</span><span>৳{DELIVERY}</span>
          </div>
          <div className="flex justify-between font-bold text-gray-800 font-bangla text-base border-t pt-2">
            <span>মোট</span><span className="text-[#FF6B35]">৳{grand}</span>
          </div>
        </div>

        <button type="submit" disabled={loading} className="w-full bg-[#2ECC71] hover:bg-[#27AE60] disabled:opacity-60 text-white font-bold py-3.5 rounded-xl transition-colors font-bangla text-base">
          {loading ? "অর্ডার হচ্ছে..." : `অর্ডার নিশ্চিত করুন — ৳${grand}`}
        </button>
      </form>
    </div>
  );
}
