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
const STATUS_COLORS: Record<string, string> = {
  pending: "text-yellow-600 bg-yellow-50",
  confirmed: "text-blue-600 bg-blue-50",
  processing: "text-purple-600 bg-purple-50",
  shipped: "text-cyan-600 bg-cyan-50",
  delivered: "text-green-600 bg-green-50",
  cancelled: "text-red-600 bg-red-50",
};

export default function OrdersPage() {
  const [orders, setOrders] = useState<any[]>([]);
  const [loading, setLoading] = useState(true);
  const { user } = useAuthStore();
  const router = useRouter();

  useEffect(() => {
    if (!user) { router.push("/login"); return; }
    api.get("/api/orders/my").then((r) => setOrders(r.data || [])).finally(() => setLoading(false));
  }, [user, router]);

  if (loading) return <div className="flex h-64 items-center justify-center text-gray-400 font-bangla">লোড হচ্ছে...</div>;

  if (orders.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center h-64 gap-3">
        <Package size={48} className="text-gray-300" />
        <div className="text-gray-400 font-bangla text-sm">কোনো অর্ডার নেই</div>
      </div>
    );
  }

  return (
    <div className="px-4 py-4">
      <h1 className="text-lg font-bold text-gray-800 font-bangla mb-4">আমার অর্ডার</h1>
      <div className="space-y-3">
        {orders.map((o) => (
          <div key={o.id} className="bg-white rounded-xl p-4 shadow-sm">
            <div className="flex items-start justify-between mb-2">
              <div>
                <div className="text-xs text-gray-400 font-mono">{o.id.slice(0, 8)}...</div>
                <div className="text-xs text-gray-400 font-bangla mt-0.5">{o.items?.length}টি পণ্য</div>
              </div>
              <span className={`text-xs px-2 py-1 rounded-full font-bangla font-semibold ${STATUS_COLORS[o.status] || "bg-gray-50 text-gray-600"}`}>
                {STATUS_LABEL[o.status] || o.status}
              </span>
            </div>
            <div className="flex justify-between items-center border-t pt-2 mt-2">
              <div className="text-xs text-gray-400 font-bangla">{o.paymentMethod?.toUpperCase()} · {o.paymentStatus === "paid" ? "পরিশোধিত" : "অপরিশোধিত"}</div>
              <div className="text-[#FF6B35] font-bold">৳{o.grandTotal}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}
