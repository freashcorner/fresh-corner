import { useEffect, useState } from "react";
import api from "../lib/api";
import SectionHeader from "../components/SectionHeader";
import SearchField from "../components/SearchField";
import StatusBadge from "../components/StatusBadge";

interface User {
  id: string;
  name: string;
  phone: string;
  role: string;
  isActive: boolean;
  createdAt: any;
}

const TIERS = ["New", "Regular", "Premium"];
function getTier(index: number) {
  return TIERS[index % 3];
}

const TIER_COLORS: Record<string, string> = {
  New: "bg-blue-500/15 text-blue-400",
  Regular: "bg-green-500/15 text-green-400",
  Premium: "bg-yaru-orange/15 text-yaru-orange",
};

export default function Customers() {
  const [users, setUsers] = useState<User[]>([]);
  const [search, setSearch] = useState("");

  useEffect(() => {
    api.get("/api/users").then((res) => {
      const customers = (res.data || []).filter((u: User) => u.role === "customer");
      setUsers(customers);
    });
  }, []);

  const filtered = users.filter((u) =>
    !search || u.name?.toLowerCase().includes(search.toLowerCase()) || u.phone?.includes(search)
  );

  return (
    <div className="p-6">
      <SectionHeader title="গ্রাহক" count={users.length}>
        <SearchField value={search} onChange={setSearch} placeholder="নাম বা ফোন খুঁজুন..." />
      </SectionHeader>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">নাম</th>
              <th className="text-left px-4 py-3 font-bangla">ফোন</th>
              <th className="text-left px-4 py-3 font-bangla">টায়ার</th>
              <th className="text-left px-4 py-3 font-bangla">অবস্থা</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.length === 0 && (
              <tr><td colSpan={4} className="text-center py-8 text-white/30 font-bangla">কোনো গ্রাহক নেই</td></tr>
            )}
            {filtered.map((u, i) => {
              const tier = getTier(i);
              return (
                <tr key={u.id} className="hover:bg-white/3">
                  <td className="px-4 py-3 text-white font-bangla">{u.name}</td>
                  <td className="px-4 py-3 text-white/60">{u.phone}</td>
                  <td className="px-4 py-3">
                    <span className={`text-xs px-2 py-1 rounded-full ${TIER_COLORS[tier]}`}>{tier}</span>
                  </td>
                  <td className="px-4 py-3"><StatusBadge status={u.isActive ? "active" : "inactive"} /></td>
                </tr>
              );
            })}
          </tbody>
        </table>
      </div>
    </div>
  );
}
