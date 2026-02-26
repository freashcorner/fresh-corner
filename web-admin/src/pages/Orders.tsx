import { useEffect, useState } from "react";
import api from "../lib/api";
import toast from "react-hot-toast";

interface Order {
  id: string;
  userName: string;
  userPhone: string;
  grandTotal: number;
  status: string;
  paymentMethod: string;
  paymentStatus: string;
  createdAt: any;
  items: any[];
}

const STATUSES = ["pending", "confirmed", "processing", "shipped", "delivered", "cancelled"];
const STATUS_LABEL: Record<string, string> = {
  pending: "অপেক্ষমান", confirmed: "নিশ্চিত", processing: "প্রস্তুত",
  shipped: "পাঠানো", delivered: "পৌঁছেছে", cancelled: "বাতিল",
};
const STATUS_COLORS: Record<string, string> = {
  pending: "bg-yellow-500/15 text-yellow-400",
  confirmed: "bg-blue-500/15 text-blue-400",
  processing: "bg-purple-500/15 text-purple-400",
  shipped: "bg-cyan-500/15 text-cyan-400",
  delivered: "bg-green-500/15 text-green-400",
  cancelled: "bg-red-500/15 text-red-400",
};

export default function Orders() {
  const [orders, setOrders] = useState<Order[]>([]);
  const [filter, setFilter] = useState("");
  const [selected, setSelected] = useState<Order | null>(null);

  async function load() {
    const res = await api.get(`/api/orders${filter ? `?status=${filter}` : ""}`);
    setOrders(res.data || []);
  }

  useEffect(() => { load(); }, [filter]);

  async function updateStatus(id: string, status: string) {
    try {
      await api.patch(`/api/orders/${id}/status`, { status });
      toast.success("স্ট্যাটাস আপডেট হয়েছে");
      load();
      if (selected?.id === id) setSelected(null);
    } catch {
      toast.error("সমস্যা হয়েছে");
    }
  }

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-xl font-semibold text-white font-bangla">অর্ডার</h1>
        <div className="flex gap-2 flex-wrap">
          <button onClick={() => setFilter("")} className={`text-xs px-3 py-1.5 rounded-lg font-bangla transition-colors ${!filter ? "bg-yaru-orange text-white" : "bg-white/8 text-white/60"}`}>সব</button>
          {STATUSES.map((s) => (
            <button key={s} onClick={() => setFilter(s)} className={`text-xs px-3 py-1.5 rounded-lg font-bangla transition-colors ${filter === s ? "bg-yaru-orange text-white" : "bg-white/8 text-white/60"}`}>
              {STATUS_LABEL[s]}
            </button>
          ))}
        </div>
      </div>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">অর্ডার আইডি</th>
              <th className="text-left px-4 py-3 font-bangla">গ্রাহক</th>
              <th className="text-left px-4 py-3 font-bangla">মোট</th>
              <th className="text-left px-4 py-3 font-bangla">পেমেন্ট</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
              <th className="text-left px-4 py-3 font-bangla">আপডেট</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {orders.length === 0 && (
              <tr><td colSpan={6} className="text-center py-8 text-white/30 font-bangla">কোনো অর্ডার নেই</td></tr>
            )}
            {orders.map((o) => (
              <tr key={o.id} className="hover:bg-white/3 cursor-pointer" onClick={() => setSelected(o)}>
                <td className="px-4 py-3 text-white/60 font-mono text-xs">{o.id.slice(0, 8)}...</td>
                <td className="px-4 py-3">
                  <div className="text-white font-bangla">{o.userName}</div>
                  <div className="text-white/40 text-xs">{o.userPhone}</div>
                </td>
                <td className="px-4 py-3 text-white font-semibold">৳{o.grandTotal}</td>
                <td className="px-4 py-3 text-white/60 font-bangla text-xs">{o.paymentMethod?.toUpperCase()} / {o.paymentStatus === "paid" ? "পরিশোধিত" : "অপরিশোধিত"}</td>
                <td className="px-4 py-3">
                  <span className={`text-xs px-2 py-1 rounded-full font-bangla ${STATUS_COLORS[o.status] || "bg-white/10 text-white/60"}`}>
                    {STATUS_LABEL[o.status] || o.status}
                  </span>
                </td>
                <td className="px-4 py-3" onClick={(e) => e.stopPropagation()}>
                  <select
                    value={o.status}
                    onChange={(e) => updateStatus(o.id, e.target.value)}
                    className="bg-[#3C3C3C] border border-white/10 rounded-lg px-2 py-1 text-xs text-white outline-none font-bangla"
                  >
                    {STATUSES.map((s) => <option key={s} value={s}>{STATUS_LABEL[s]}</option>)}
                  </select>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Detail modal */}
      {selected && (
        <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4" onClick={() => setSelected(null)}>
          <div className="bg-[#2D2D2D] rounded-xl w-full max-w-md border border-white/10 p-6" onClick={(e) => e.stopPropagation()}>
            <h2 className="text-sm font-semibold text-white font-bangla mb-4">অর্ডার বিস্তারিত</h2>
            <div className="space-y-2 text-sm">
              <div className="flex justify-between"><span className="text-white/40 font-bangla">আইডি</span><span className="text-white font-mono text-xs">{selected.id}</span></div>
              <div className="flex justify-between"><span className="text-white/40 font-bangla">গ্রাহক</span><span className="text-white font-bangla">{selected.userName}</span></div>
              <div className="flex justify-between"><span className="text-white/40 font-bangla">ফোন</span><span className="text-white">{selected.userPhone}</span></div>
              <div className="flex justify-between"><span className="text-white/40 font-bangla">মোট</span><span className="text-white font-semibold">৳{selected.grandTotal}</span></div>
            </div>
            <div className="mt-4">
              <div className="text-xs text-white/40 font-bangla mb-2">আইটেম সমূহ</div>
              {selected.items?.map((item: any, i: number) => (
                <div key={i} className="flex justify-between text-sm py-1 border-b border-white/5">
                  <span className="text-white font-bangla">{item.name} ×{item.qty}</span>
                  <span className="text-white/60">৳{item.subtotal}</span>
                </div>
              ))}
            </div>
            <button onClick={() => setSelected(null)} className="mt-4 w-full bg-white/8 hover:bg-white/15 text-white py-2 rounded-lg text-sm font-bangla">বন্ধ করুন</button>
          </div>
        </div>
      )}
    </div>
  );
}
