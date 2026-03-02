import { useState } from "react";
import StatusBadge from "../components/StatusBadge";
import SectionHeader from "../components/SectionHeader";
import SearchField from "../components/SearchField";

const MOCK_RIDERS = [
  { id: "R-001", name: "করিম হাসান", phone: "01712345678", status: "online", deliveries: 156, rating: 4.8, earnings: 28500, area: "মিরপুর" },
  { id: "R-002", name: "জামাল উদ্দিন", phone: "01812345678", status: "busy", deliveries: 203, rating: 4.6, earnings: 35200, area: "ধানমন্ডি" },
  { id: "R-003", name: "রাজু আহমেদ", phone: "01912345678", status: "online", deliveries: 89, rating: 4.9, earnings: 15800, area: "মোহাম্মদপুর" },
  { id: "R-004", name: "সোহেল রানা", phone: "01612345678", status: "offline", deliveries: 312, rating: 4.4, earnings: 52100, area: "উত্তরা" },
  { id: "R-005", name: "মামুন রশিদ", phone: "01512345678", status: "online", deliveries: 178, rating: 4.7, earnings: 31400, area: "গুলশান" },
];

export default function Riders() {
  const [search, setSearch] = useState("");

  const filtered = MOCK_RIDERS.filter((r) =>
    !search || r.name.includes(search) || r.phone.includes(search)
  );

  return (
    <div className="p-6">
      <SectionHeader title="রাইডার" count={MOCK_RIDERS.length}>
        <SearchField value={search} onChange={setSearch} placeholder="রাইডার খুঁজুন..." />
      </SectionHeader>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">রাইডার</th>
              <th className="text-left px-4 py-3 font-bangla">ফোন</th>
              <th className="text-left px-4 py-3 font-bangla">এলাকা</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
              <th className="text-left px-4 py-3 font-bangla">ডেলিভারি</th>
              <th className="text-left px-4 py-3 font-bangla">রেটিং</th>
              <th className="text-left px-4 py-3 font-bangla">আয়</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.map((r) => (
              <tr key={r.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla">{r.name}</td>
                <td className="px-4 py-3 text-white/60">{r.phone}</td>
                <td className="px-4 py-3 text-white/60 font-bangla">{r.area}</td>
                <td className="px-4 py-3"><StatusBadge status={r.status} /></td>
                <td className="px-4 py-3 text-white">{r.deliveries}</td>
                <td className="px-4 py-3 text-yellow-400">{r.rating}</td>
                <td className="px-4 py-3 text-white font-semibold">৳{r.earnings.toLocaleString()}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
