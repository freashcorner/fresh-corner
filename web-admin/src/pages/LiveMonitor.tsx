import { useState } from "react";
import { Activity, ShoppingCart, Bike, Clock, MapPin } from "lucide-react";
import StatCard from "../components/StatCard";
import StatusBadge from "../components/StatusBadge";

const MOCK_ACTIVE_ORDERS = [
  { id: "ORD-2401", customer: "রহিম আহমেদ", area: "মিরপুর-১০", status: "processing", rider: "করিম", time: "১২ মিনিট আগে" },
  { id: "ORD-2402", customer: "কামাল হোসেন", area: "ধানমন্ডি", status: "shipped", rider: "জামাল", time: "৫ মিনিট আগে" },
  { id: "ORD-2403", customer: "সালমা বেগম", area: "উত্তরা-৬", status: "confirmed", rider: "—", time: "২ মিনিট আগে" },
  { id: "ORD-2404", customer: "তানিয়া ইসলাম", area: "গুলশান-১", status: "pending", rider: "—", time: "এইমাত্র" },
  { id: "ORD-2405", customer: "ফারুক মিয়া", area: "মোহাম্মদপুর", status: "shipped", rider: "রাজু", time: "১৮ মিনিট আগে" },
];

const MOCK_ONLINE_RIDERS = [
  { name: "করিম হাসান", phone: "01712345678", status: "busy", area: "মিরপুর", deliveries: 3 },
  { name: "জামাল উদ্দিন", phone: "01812345678", status: "busy", area: "ধানমন্ডি", deliveries: 2 },
  { name: "রাজু আহমেদ", phone: "01912345678", status: "busy", area: "মোহাম্মদপুর", deliveries: 4 },
  { name: "সোহেল রানা", phone: "01612345678", status: "online", area: "উত্তরা", deliveries: 0 },
];

export default function LiveMonitor() {
  const [activeTab, setActiveTab] = useState<"orders" | "riders">("orders");

  return (
    <div className="p-6 space-y-6">
      <h1 className="text-xl font-semibold text-white font-bangla">লাইভ মনিটর</h1>

      <div className="grid grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard label="সক্রিয় অর্ডার" value={5} icon={ShoppingCart} color="bg-blue-500/10 text-blue-400" />
        <StatCard label="অনলাইন রাইডার" value={4} icon={Bike} color="bg-green-500/10 text-green-400" />
        <StatCard label="গড় ডেলিভারি সময়" value="২৮ মিনিট" icon={Clock} color="bg-yellow-500/10 text-yellow-400" />
        <StatCard label="আজকের ডেলিভারি" value={23} icon={Activity} color="bg-purple-500/10 text-purple-400" />
      </div>

      <div className="flex gap-2 mb-4">
        <button onClick={() => setActiveTab("orders")} className={`text-xs px-4 py-2 rounded-lg font-bangla transition-colors ${activeTab === "orders" ? "bg-yaru-orange text-white" : "bg-white/8 text-white/60"}`}>সক্রিয় অর্ডার</button>
        <button onClick={() => setActiveTab("riders")} className={`text-xs px-4 py-2 rounded-lg font-bangla transition-colors ${activeTab === "riders" ? "bg-yaru-orange text-white" : "bg-white/8 text-white/60"}`}>অনলাইন রাইডার</button>
      </div>

      {activeTab === "orders" && (
        <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-white/10 text-white/40 text-xs">
                <th className="text-left px-4 py-3 font-bangla">অর্ডার</th>
                <th className="text-left px-4 py-3 font-bangla">গ্রাহক</th>
                <th className="text-left px-4 py-3 font-bangla">এলাকা</th>
                <th className="text-left px-4 py-3 font-bangla">রাইডার</th>
                <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
                <th className="text-left px-4 py-3 font-bangla">সময়</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {MOCK_ACTIVE_ORDERS.map((o) => (
                <tr key={o.id} className="hover:bg-white/3">
                  <td className="px-4 py-3 text-white font-mono text-xs">{o.id}</td>
                  <td className="px-4 py-3 text-white font-bangla">{o.customer}</td>
                  <td className="px-4 py-3 text-white/60 font-bangla flex items-center gap-1"><MapPin size={12} />{o.area}</td>
                  <td className="px-4 py-3 text-white/60 font-bangla">{o.rider}</td>
                  <td className="px-4 py-3"><StatusBadge status={o.status} /></td>
                  <td className="px-4 py-3 text-white/40 text-xs font-bangla">{o.time}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {activeTab === "riders" && (
        <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-white/10 text-white/40 text-xs">
                <th className="text-left px-4 py-3 font-bangla">রাইডার</th>
                <th className="text-left px-4 py-3 font-bangla">ফোন</th>
                <th className="text-left px-4 py-3 font-bangla">এলাকা</th>
                <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
                <th className="text-left px-4 py-3 font-bangla">ডেলিভারি</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-white/5">
              {MOCK_ONLINE_RIDERS.map((r) => (
                <tr key={r.phone} className="hover:bg-white/3">
                  <td className="px-4 py-3 text-white font-bangla">{r.name}</td>
                  <td className="px-4 py-3 text-white/60">{r.phone}</td>
                  <td className="px-4 py-3 text-white/60 font-bangla">{r.area}</td>
                  <td className="px-4 py-3"><StatusBadge status={r.status} /></td>
                  <td className="px-4 py-3 text-white">{r.deliveries}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
