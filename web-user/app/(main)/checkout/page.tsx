"use client";
import { useState } from "react";
import { useCartStore } from "@/store/cartStore";
import { useAuthStore } from "@/store/authStore";
import api from "@/lib/api";
import { useRouter } from "next/navigation";
import toast from "react-hot-toast";
import Link from "next/link";
import Image from "next/image";

export default function CheckoutPage() {
  const { items, total, clearCart } = useCartStore();
  const { user } = useAuthStore();
  const router = useRouter();
  const [form, setForm] = useState({
    name: "", phone: "", street: "", area: "", city: "ঢাকা", note: ""
  });
  const [paymentMethod, setPaymentMethod] = useState("cod");
  const [loading, setLoading] = useState(false);

  const DELIVERY = 30;
  const grand = total() + DELIVERY;

  async function handleOrder(e: React.FormEvent) {
    e.preventDefault();
    if (!user) { router.push("/login"); return; }
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

        {/* ✅ ১. অর্ডার আইটেম লিস্ট */}
        <div className="checkout-section">
          <h2 className="font-bangla mb-3">অর্ডার সারসংক্ষেপ</h2>
          <div className="space-y-3">
            {items.map((item) => (
              <div key={item.id} style={{
                display: 'flex',
                alignItems: 'center',
                gap: '12px',
                padding: '10px',
                borderRadius: '10px',
                background: 'var(--bg2)',
              }}>
                {/* ছবি */}
                <div style={{
                  width: '52px', height: '52px', borderRadius: '8px',
                  overflow: 'hidden', position: 'relative', flexShrink: 0,
                  background: 'var(--bg3)',
                  display: 'flex', alignItems: 'center', justifyContent: 'center'
                }}>
                  {item.imageUrl ? (
                    <Image src={item.imageUrl} alt={item.name} fill className="object-cover" sizes="52px" />
                  ) : (
                    <span style={{ fontSize: '24px' }}>🥦</span>
                  )}
                </div>
                {/* তথ্য */}
                <div style={{ flex: 1 }}>
                  <div className="font-bangla" style={{ fontWeight: 600, fontSize: '14px' }}>{item.name}</div>
                  <div className="font-bangla" style={{ fontSize: '12px', color: 'var(--text2)' }}>
                    {item.qty} {item.unit} × ৳{item.discountPrice || item.price}
                  </div>
                </div>
                {/* সাবটোটাল */}
                <div className="font-bangla" style={{ fontWeight: 700, color: 'var(--g1)', fontSize: '15px' }}>
                  ৳{(item.discountPrice || item.price) * item.qty}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* ✅ ২. সুন্দর ইনপুট ফিল্ড */}
        <div className="checkout-section">
          <h2 className="font-bangla mb-3">ডেলিভারি তথ্য</h2>
          <div className="space-y-3">
            {[
              { key: 'name', placeholder: '👤 আপনার নাম', type: 'text' },
              { key: 'phone', placeholder: '📞 ফোন নম্বর', type: 'tel' },
              { key: 'street', placeholder: '🏠 রাস্তা ও বাড়ি নম্বর', type: 'text' },
              { key: 'area', placeholder: '📍 এলাকা', type: 'text' },
            ].map(({ key, placeholder, type }) => (
              <div key={key} style={{ position: 'relative' }}>
                <input
                  type={type}
                  placeholder={placeholder}
                  value={form[key as keyof typeof form]}
                  onChange={(e) => setForm({ ...form, [key]: e.target.value })}
                  required
                  className="font-bangla"
                  style={{
                    width: '100%',
                    padding: '14px 16px',
                    borderRadius: '12px',
                    border: '1.5px solid var(--border)',
                    background: 'var(--bg2)',
                    color: 'var(--text1)',
                    fontSize: '14px',
                    outline: 'none',
                    transition: 'border-color 0.2s',
                  }}
                  onFocus={(e) => e.target.style.borderColor = 'var(--g1)'}
                  onBlur={(e) => e.target.style.borderColor = 'var(--border)'}
                />
              </div>
            ))}
            <textarea
              placeholder="💬 বিশেষ নির্দেশনা (ঐচ্ছিক)"
              value={form.note}
              onChange={(e) => setForm({ ...form, note: e.target.value })}
              rows={2}
              className="font-bangla resize-none"
              style={{
                width: '100%',
                padding: '14px 16px',
                borderRadius: '12px',
                border: '1.5px solid var(--border)',
                background: 'var(--bg2)',
                color: 'var(--text1)',
                fontSize: '14px',
                outline: 'none',
              }}
              onFocus={(e) => e.target.style.borderColor = 'var(--g1)'}
              onBlur={(e) => e.target.style.borderColor = 'var(--border)'}
            />
          </div>
        </div>

        {/* পেমেন্ট পদ্ধতি */}
        <div className="checkout-section">
          <h2 className="font-bangla mb-3">পেমেন্ট পদ্ধতি</h2>
          <div className="space-y-3">
            {[
              { value: "cod", label: "💵 ক্যাশ অন ডেলিভারি" },
              { value: "bkash", label: "🟣 বিকাশ" },
              { value: "nagad", label: "🟠 নগদ" },
            ].map(({ value, label }) => (
              <label key={value} style={{
                display: 'flex', alignItems: 'center', gap: '12px',
                padding: '12px 16px', borderRadius: '12px', cursor: 'pointer',
                border: `1.5px solid ${paymentMethod === value ? 'var(--g1)' : 'var(--border)'}`,
                background: paymentMethod === value ? 'rgba(34,197,94,0.08)' : 'var(--bg2)',
                transition: 'all 0.2s',
              }}>
                <div style={{
                  width: '20px', height: '20px', borderRadius: '50%',
                  border: `2px solid ${paymentMethod === value ? 'var(--g1)' : 'var(--border)'}`,
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                }}>
                  {paymentMethod === value && (
                    <div style={{ width: '10px', height: '10px', borderRadius: '50%', background: 'var(--g1)' }} />
                  )}
                </div>
                <input type="radio" name="payment" value={value} checked={paymentMethod === value}
                  onChange={() => setPaymentMethod(value)} className="hidden" />
                <span className="font-bangla" style={{ fontSize: '14px' }}>{label}</span>
              </label>
            ))}
          </div>
        </div>

        {/* মোট */}
        <div className="checkout-section">
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '8px' }}>
            <span className="font-bangla" style={{ color: 'var(--text2)', fontSize: '14px' }}>পণ্যের মূল্য ({items.length}টি)</span>
            <span style={{ fontSize: '14px' }}>৳{total()}</span>
          </div>
          <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '12px' }}>
            <span className="font-bangla" style={{ color: 'var(--text2)', fontSize: '14px' }}>ডেলিভারি চার্জ</span>
            <span style={{ fontSize: '14px' }}>৳{DELIVERY}</span>
          </div>
          <div style={{
            display: 'flex', justifyContent: 'space-between',
            borderTop: '1px solid var(--border)', paddingTop: '12px',
          }}>
            <span className="font-bangla" style={{ fontWeight: 700, fontSize: '18px' }}>মোট</span>
            <span style={{ fontWeight: 700, fontSize: '18px', color: 'var(--g1)' }}>৳{grand}</span>
          </div>
        </div>

        <button type="submit" disabled={loading} className="btn-primary w-full justify-center font-bangla text-lg disabled:opacity-50">
          {loading ? "অর্ডার হচ্ছে..." : `অর্ডার নিশ্চিত করুন — ৳${grand}`}
        </button>
      </form>
    </div>
  );
}
