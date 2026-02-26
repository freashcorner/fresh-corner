import { useEffect, useState } from "react";
import api from "../lib/api";
import toast from "react-hot-toast";
import { Plus, X } from "lucide-react";

interface Delivery { orderId: string; riderName: string; riderPhone: string; status: string; estimatedTime?: string; }

const STATUS_LABEL: Record<string, string> = {
  assigned: "নিযুক্ত", picked: "নেওয়া হয়েছে", on_way: "পথে আছে", delivered: "পৌঁছে গেছে",
};

export default function Delivery() {
  const [deliveries, setDeliveries] = useState<Delivery[]>([]);
  const [modal, setModal] = useState(false);
  const [form, setForm] = useState({ orderId: "", riderId: "", riderName: "", riderPhone: "", estimatedTime: "" });
  const [loading, setLoading] = useState(false);

  async function load() {
    const res = await api.get("/api/delivery");
    setDeliveries(res.data || []);
  }

  useEffect(() => { load(); }, []);

  async function handleAssign(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    try {
      await api.post("/api/delivery/assign", form);
      toast.success("রাইডার নিযুক্ত হয়েছে");
      setModal(false);
      load();
    } catch {
      toast.error("সমস্যা হয়েছে");
    } finally {
      setLoading(false);
    }
  }

  async function updateStatus(orderId: string, status: string) {
    await api.patch(`/api/delivery/${orderId}/status`, { status });
    toast.success("স্ট্যাটাস আপডেট");
    load();
  }

  return (
    <div className="p-6">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-xl font-semibold text-white font-bangla">ডেলিভারি</h1>
        <button onClick={() => setModal(true)} className="flex items-center gap-2 bg-yaru-orange text-white text-sm px-4 py-2 rounded-lg font-bangla">
          <Plus size={16} /> রাইডার নিযুক্ত করুন
        </button>
      </div>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">অর্ডার</th>
              <th className="text-left px-4 py-3 font-bangla">রাইডার</th>
              <th className="text-left px-4 py-3 font-bangla">আনুমানিক সময়</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
              <th className="text-left px-4 py-3 font-bangla">আপডেট</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {deliveries.length === 0 && (
              <tr><td colSpan={5} className="text-center py-8 text-white/30 font-bangla">কোনো ডেলিভারি নেই</td></tr>
            )}
            {deliveries.map((d) => (
              <tr key={d.orderId} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white/60 font-mono text-xs">{d.orderId?.slice(0, 8)}...</td>
                <td className="px-4 py-3">
                  <div className="text-white font-bangla">{d.riderName}</div>
                  <div className="text-white/40 text-xs">{d.riderPhone}</div>
                </td>
                <td className="px-4 py-3 text-white/60 font-bangla">{d.estimatedTime || "—"}</td>
                <td className="px-4 py-3 text-white/60 font-bangla">{STATUS_LABEL[d.status] || d.status}</td>
                <td className="px-4 py-3">
                  <select value={d.status} onChange={(e) => updateStatus(d.orderId, e.target.value)}
                    className="bg-[#3C3C3C] border border-white/10 rounded-lg px-2 py-1 text-xs text-white outline-none font-bangla">
                    {Object.entries(STATUS_LABEL).map(([v, l]) => <option key={v} value={v}>{l}</option>)}
                  </select>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {modal && (
        <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
          <div className="bg-[#2D2D2D] rounded-xl w-full max-w-sm border border-white/10">
            <div className="flex items-center justify-between p-5 border-b border-white/10">
              <h2 className="text-sm font-semibold text-white font-bangla">রাইডার নিযুক্ত করুন</h2>
              <button onClick={() => setModal(false)} className="text-white/40 hover:text-white"><X size={18} /></button>
            </div>
            <form onSubmit={handleAssign} className="p-5 space-y-3">
              <input placeholder="অর্ডার আইডি" value={form.orderId} onChange={(e) => setForm({...form, orderId: e.target.value})} required className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
              <input placeholder="রাইডার আইডি" value={form.riderId} onChange={(e) => setForm({...form, riderId: e.target.value})} required className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
              <input placeholder="রাইডারের নাম" value={form.riderName} onChange={(e) => setForm({...form, riderName: e.target.value})} required className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange font-bangla" />
              <input placeholder="ফোন নম্বর" value={form.riderPhone} onChange={(e) => setForm({...form, riderPhone: e.target.value})} required className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange" />
              <input placeholder="আনুমানিক সময় (যেমন: ৩০ মিনিট)" value={form.estimatedTime} onChange={(e) => setForm({...form, estimatedTime: e.target.value})} className="w-full bg-[#3C3C3C] border border-white/10 rounded-lg px-3 py-2 text-sm text-white outline-none focus:border-yaru-orange font-bangla" />
              <button type="submit" disabled={loading} className="w-full bg-yaru-orange disabled:opacity-50 text-white font-semibold py-2.5 rounded-lg font-bangla">
                {loading ? "নিযুক্ত হচ্ছে..." : "নিযুক্ত করুন"}
              </button>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
