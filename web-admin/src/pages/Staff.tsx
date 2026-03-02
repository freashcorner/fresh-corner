import { useState } from "react";
import StatusBadge from "../components/StatusBadge";
import SectionHeader from "../components/SectionHeader";
import SearchField from "../components/SearchField";

const MOCK_STAFF = [
  { id: "S-001", name: "আবির হোসেন", email: "abir@freshcorner.com", role: "Super Admin", lastLogin: "২০২৬-০৩-০২ ১০:৩০", status: "active" },
  { id: "S-002", name: "রাকিব হাসান", email: "rakib@freshcorner.com", role: "Manager", lastLogin: "২০২৬-০৩-০১ ১৮:১৫", status: "active" },
  { id: "S-003", name: "নাফিসা আক্তার", email: "nafisa@freshcorner.com", role: "Support", lastLogin: "২০২৬-০২-২৮ ০৯:৪৫", status: "active" },
  { id: "S-004", name: "তানভীর আলম", email: "tanvir@freshcorner.com", role: "Warehouse", lastLogin: "২০২৬-০২-২৫ ১৪:২০", status: "inactive" },
];

const ROLE_COLORS: Record<string, string> = {
  "Super Admin": "bg-yaru-orange/15 text-yaru-orange",
  Manager: "bg-purple-500/15 text-purple-400",
  Support: "bg-blue-500/15 text-blue-400",
  Warehouse: "bg-green-500/15 text-green-400",
};

export default function Staff() {
  const [search, setSearch] = useState("");

  const filtered = MOCK_STAFF.filter((s) =>
    !search || s.name.includes(search) || s.email.includes(search)
  );

  return (
    <div className="p-6">
      <SectionHeader title="স্টাফ ও রোল" count={MOCK_STAFF.length}>
        <SearchField value={search} onChange={setSearch} placeholder="স্টাফ খুঁজুন..." />
      </SectionHeader>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">নাম</th>
              <th className="text-left px-4 py-3 font-bangla">ইমেইল</th>
              <th className="text-left px-4 py-3 font-bangla">রোল</th>
              <th className="text-left px-4 py-3 font-bangla">শেষ লগইন</th>
              <th className="text-left px-4 py-3 font-bangla">অবস্থা</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.map((s) => (
              <tr key={s.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla">{s.name}</td>
                <td className="px-4 py-3 text-white/60">{s.email}</td>
                <td className="px-4 py-3">
                  <span className={`text-xs px-2 py-1 rounded-full ${ROLE_COLORS[s.role] || "bg-white/10 text-white/60"}`}>{s.role}</span>
                </td>
                <td className="px-4 py-3 text-white/40 text-xs">{s.lastLogin}</td>
                <td className="px-4 py-3"><StatusBadge status={s.status} /></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
