"use client";
import { useEffect, useState } from "react";
import api from "@/lib/api";
import { useAuthStore } from "@/store/authStore";
import { useRouter } from "next/navigation";
import { Package } from "lucide-react";

const STATUS_LABEL: Record<string, string> = {
  pending: "অপেক্ষমান", confirmed: "নিশ্চিত", processing: "প্রস্তুত",
  shipped: "পাঠানো হয়েছে", delivered: "পৌঁছে গেছে", cancelled: "বাতিল",
};

const TABS = ["all", "pending", "confirmed", "processing", "shipped", "delivered", "cancelled"];
const TAB_LABELS: Record<string, string> = {
  all: "সব", pending: "অপেক্ষমান", confirmed: "নিশ্চিত", processing: "প্রস্তুত",
  shipped: "শিপড", delivered: "ডেলিভারড", cancelled: "বাতিল",
};

export default function OrdersPage() {
  const [orders, setOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeTab, setActiveTab] = useState("all");
  const { user } = useAuthStore();
  const router = useRouter();

  useEffect(() => {
    if (!user) { router.push("/login"); return; }
    api.get("/api/orders/my").then((r) => setOrders(r.data || [])).finally(() => setLoading(false));
  }, [user, router]);

  const filtered = activeTab === "all" ? orders : orders.filter((o) => o.status === activeTab);

  if (loading) return (
    <div className="page-container">
      <div className="flex h-64 items-center justify-center text-[var(--text2)] font-bangla">লোড হচ্ছে...</div>
    </div>
  );

  return (
    <div className="page-container">
      <h1 className="text-2xl font-bold font-bangla mb-6">আমার অর্ডার</h1>

      <div className="order-tabs">
        {TABS.map((tab) => (
          <button key={tab} onClick={() => setActiveTab(tab)} className={`order-tab font-bangla ${activeTab === tab ? "active" : ""}`}>
            {TAB_LABELS[tab]}
          </button>
        ))}
      </div>

      {filtered.length === 0 ? (
        <div className="empty-state">
          <div className="icon"><Package size={48} /></div>
          <p className="font-bangla">কোনো অর্ডার নেই</p>
        </div>
      ) : (
        filtered.map((o) => (
          <div key={o.id} className="order-card">
            <div className="order-header">
              <div>
                <div className="order-id">{o.id.slice(0, 8)}...</div>
                <div className="order-date font-bangla">{o.items?.length}টি পণ্য</div>
              </div>
              <span className={`status-badge status-${o.status}`}>
                {STATUS_LABEL[o.status] || o.status}
              </span>
            </div>
            <div className="flex justify-between items-center border-t border-[var(--border)] pt-3 mt-2">
              <div className="text-sm text-[var(--text2)] font-bangla">
                {o.paymentMethod?.toUpperCase()} · {o.paymentStatus === "paid" ? "পরিশোধিত" : "অপরিশোধিত"}
              </div>
              <div className="text-[var(--g1)] font-bold text-lg">৳{o.grandTotal}</div>
            </div>
          </div>
        ))
      )}
    </div>
  );
}
