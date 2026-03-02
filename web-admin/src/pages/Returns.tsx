import { useState } from "react";
import StatusBadge from "../components/StatusBadge";
import SectionHeader from "../components/SectionHeader";
import SearchField from "../components/SearchField";

const MOCK_RETURNS = [
  { id: "RET-001", orderId: "ORD-2380", customer: "রহিম আহমেদ", reason: "পণ্য নষ্ট ছিল", amount: 450, status: "pending", date: "২০২৬-০৩-০১" },
  { id: "RET-002", orderId: "ORD-2365", customer: "কামাল হোসেন", reason: "ভুল পণ্য পাঠানো", amount: 320, status: "approved", date: "২০২৬-০২-২৮" },
  { id: "RET-003", orderId: "ORD-2350", customer: "সালমা বেগম", reason: "মেয়াদ উত্তীর্ণ", amount: 180, status: "rejected", date: "২০২৬-০২-২৭" },
  { id: "RET-004", orderId: "ORD-2342", customer: "তানিয়া ইসলাম", reason: "পরিমাণ কম", amount: 90, status: "approved", date: "২০২৬-০২-২৬" },
  { id: "RET-005", orderId: "ORD-2330", customer: "ফারুক মিয়া", reason: "পণ্য ভাঙ্গা ছিল", amount: 560, status: "pending", date: "২০২৬-০২-২৫" },
];

export default function Returns() {
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState("");

  const filtered = MOCK_RETURNS.filter((r) => {
    if (filter && r.status !== filter) return false;
    if (search && !r.customer.includes(search) && !r.orderId.includes(search)) return false;
    return true;
  });

  return (
    <div className="p-6">
      <SectionHeader title="রিটার্ন ও রিফান্ড" count={MOCK_RETURNS.length}>
        <SearchField value={search} onChange={setSearch} placeholder="গ্রাহক বা অর্ডার খুঁজুন..." />
      </SectionHeader>

      <div className="flex gap-2 mb-4">
        {["", "pending", "approved", "rejected"].map((s) => (
          <button key={s} onClick={() => setFilter(s)} className={`text-xs px-3 py-1.5 rounded-lg font-bangla transition-colors ${filter === s ? "bg-yaru-orange text-white" : "bg-white/8 text-white/60"}`}>
            {s === "" ? "সব" : s === "pending" ? "অপেক্ষমান" : s === "approved" ? "অনুমোদিত" : "প্রত্যাখ্যাত"}
          </button>
        ))}
      </div>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">রিটার্ন আইডি</th>
              <th className="text-left px-4 py-3 font-bangla">অর্ডার</th>
              <th className="text-left px-4 py-3 font-bangla">গ্রাহক</th>
              <th className="text-left px-4 py-3 font-bangla">কারণ</th>
              <th className="text-left px-4 py-3 font-bangla">পরিমাণ</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
              <th className="text-left px-4 py-3 font-bangla">তারিখ</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.length === 0 && (
              <tr><td colSpan={7} className="text-center py-8 text-white/30 font-bangla">কোনো রিটার্ন নেই</td></tr>
            )}
            {filtered.map((r) => (
              <tr key={r.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-mono text-xs">{r.id}</td>
                <td className="px-4 py-3 text-white/60 font-mono text-xs">{r.orderId}</td>
                <td className="px-4 py-3 text-white font-bangla">{r.customer}</td>
                <td className="px-4 py-3 text-white/60 font-bangla">{r.reason}</td>
                <td className="px-4 py-3 text-white font-semibold">৳{r.amount}</td>
                <td className="px-4 py-3"><StatusBadge status={r.status} /></td>
                <td className="px-4 py-3 text-white/40 text-xs">{r.date}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
