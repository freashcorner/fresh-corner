import { useState } from "react";
import StatusBadge from "../components/StatusBadge";
import SectionHeader from "../components/SectionHeader";

const MOCK_PROMOS = [
  { id: "P-001", code: "WELCOME50", type: "percentage", value: 50, minOrder: 500, maxDiscount: 200, usageLimit: 100, used: 45, expiry: "২০২৬-০৩-৩১", status: "active" },
  { id: "P-002", code: "FLAT100", type: "fixed", value: 100, minOrder: 300, maxDiscount: 100, usageLimit: 200, used: 180, expiry: "২০২৬-০৩-১৫", status: "active" },
  { id: "P-003", code: "SUMMER25", type: "percentage", value: 25, minOrder: 400, maxDiscount: 150, usageLimit: 500, used: 500, expiry: "২০২৬-০২-২৮", status: "inactive" },
  { id: "P-004", code: "NEWUSER", type: "percentage", value: 30, minOrder: 200, maxDiscount: 100, usageLimit: 1000, used: 320, expiry: "২০২৬-০৪-৩০", status: "active" },
];

export default function Promos() {
  const [filter, setFilter] = useState("");

  const filtered = MOCK_PROMOS.filter((p) => !filter || p.status === filter);

  return (
    <div className="p-6">
      <SectionHeader title="প্রোমো ও কুপন" count={MOCK_PROMOS.length} />

      <div className="flex gap-2 mb-4">
        {["", "active", "inactive"].map((s) => (
          <button key={s} onClick={() => setFilter(s)} className={`text-xs px-3 py-1.5 rounded-lg font-bangla transition-colors ${filter === s ? "bg-yaru-orange text-white" : "bg-white/8 text-white/60"}`}>
            {s === "" ? "সব" : s === "active" ? "সক্রিয়" : "নিষ্ক্রিয়"}
          </button>
        ))}
      </div>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">কোড</th>
              <th className="text-left px-4 py-3 font-bangla">ধরন</th>
              <th className="text-left px-4 py-3 font-bangla">মান</th>
              <th className="text-left px-4 py-3 font-bangla">ন্যূনতম অর্ডার</th>
              <th className="text-left px-4 py-3 font-bangla">সর্বোচ্চ ছাড়</th>
              <th className="text-left px-4 py-3 font-bangla">ব্যবহার</th>
              <th className="text-left px-4 py-3 font-bangla">মেয়াদ</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.map((p) => (
              <tr key={p.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-yaru-orange font-mono font-semibold">{p.code}</td>
                <td className="px-4 py-3 text-white/60 font-bangla">{p.type === "percentage" ? "শতাংশ" : "নির্দিষ্ট"}</td>
                <td className="px-4 py-3 text-white font-semibold">{p.type === "percentage" ? `${p.value}%` : `৳${p.value}`}</td>
                <td className="px-4 py-3 text-white/60">৳{p.minOrder}</td>
                <td className="px-4 py-3 text-white/60">৳{p.maxDiscount}</td>
                <td className="px-4 py-3 text-white">{p.used}/{p.usageLimit}</td>
                <td className="px-4 py-3 text-white/40 text-xs">{p.expiry}</td>
                <td className="px-4 py-3"><StatusBadge status={p.status} /></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
