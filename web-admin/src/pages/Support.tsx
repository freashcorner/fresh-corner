import { useState } from "react";
import StatusBadge from "../components/StatusBadge";
import SectionHeader from "../components/SectionHeader";
import SearchField from "../components/SearchField";

const MOCK_TICKETS = [
  { id: "TKT-001", subject: "ডেলিভারি দেরি হচ্ছে", customer: "রহিম আহমেদ", priority: "high", status: "open", date: "২০২৬-০৩-০২" },
  { id: "TKT-002", subject: "ভুল পণ্য পেয়েছি", customer: "কামাল হোসেন", priority: "high", status: "open", date: "২০২৬-০৩-০১" },
  { id: "TKT-003", subject: "পেমেন্ট সমস্যা", customer: "সালমা বেগম", priority: "medium", status: "resolved", date: "২০২৬-০২-২৮" },
  { id: "TKT-004", subject: "অ্যাকাউন্ট লগইন সমস্যা", customer: "তানিয়া ইসলাম", priority: "low", status: "closed", date: "২০২৬-০২-২৭" },
  { id: "TKT-005", subject: "রিফান্ড পাইনি", customer: "ফারুক মিয়া", priority: "high", status: "open", date: "২০২৬-০৩-০২" },
];

const PRIORITY_COLORS: Record<string, string> = {
  high: "bg-red-500/15 text-red-400",
  medium: "bg-yellow-500/15 text-yellow-400",
  low: "bg-blue-500/15 text-blue-400",
};
const PRIORITY_LABELS: Record<string, string> = { high: "জরুরি", medium: "মাঝারি", low: "সাধারণ" };

export default function Support() {
  const [search, setSearch] = useState("");
  const [filter, setFilter] = useState("");

  const filtered = MOCK_TICKETS.filter((t) => {
    if (filter && t.status !== filter) return false;
    if (search && !t.subject.includes(search) && !t.customer.includes(search)) return false;
    return true;
  });

  return (
    <div className="p-6">
      <SectionHeader title="সাপোর্ট টিকেট" count={MOCK_TICKETS.length}>
        <SearchField value={search} onChange={setSearch} placeholder="টিকেট খুঁজুন..." />
      </SectionHeader>

      <div className="flex gap-2 mb-4">
        {["", "open", "resolved", "closed"].map((s) => (
          <button key={s} onClick={() => setFilter(s)} className={`text-xs px-3 py-1.5 rounded-lg font-bangla transition-colors ${filter === s ? "bg-yaru-orange text-white" : "bg-white/8 text-white/60"}`}>
            {s === "" ? "সব" : s === "open" ? "চলমান" : s === "resolved" ? "সমাধান" : "বন্ধ"}
          </button>
        ))}
      </div>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">টিকেট</th>
              <th className="text-left px-4 py-3 font-bangla">বিষয়</th>
              <th className="text-left px-4 py-3 font-bangla">গ্রাহক</th>
              <th className="text-left px-4 py-3 font-bangla">প্রায়োরিটি</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
              <th className="text-left px-4 py-3 font-bangla">তারিখ</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.length === 0 && (
              <tr><td colSpan={6} className="text-center py-8 text-white/30 font-bangla">কোনো টিকেট নেই</td></tr>
            )}
            {filtered.map((t) => (
              <tr key={t.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-mono text-xs">{t.id}</td>
                <td className="px-4 py-3 text-white font-bangla">{t.subject}</td>
                <td className="px-4 py-3 text-white/60 font-bangla">{t.customer}</td>
                <td className="px-4 py-3">
                  <span className={`text-xs px-2 py-1 rounded-full font-bangla ${PRIORITY_COLORS[t.priority]}`}>{PRIORITY_LABELS[t.priority]}</span>
                </td>
                <td className="px-4 py-3"><StatusBadge status={t.status} /></td>
                <td className="px-4 py-3 text-white/40 text-xs">{t.date}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
