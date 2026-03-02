import { useState } from "react";
import StatusBadge from "../components/StatusBadge";
import SectionHeader from "../components/SectionHeader";
import SearchField from "../components/SearchField";

const MOCK_VENDORS = [
  { id: "V-001", name: "গ্রিন ফার্ম", contact: "আব্দুল করিম", phone: "01711111111", products: 45, rating: 4.5, status: "active" },
  { id: "V-002", name: "ফ্রেশ হার্ভেস্ট", contact: "রফিকুল ইসলাম", phone: "01822222222", products: 32, rating: 4.2, status: "active" },
  { id: "V-003", name: "ডেইলি ফুডস", contact: "কামরুল হাসান", phone: "01933333333", products: 28, rating: 3.8, status: "inactive" },
  { id: "V-004", name: "অর্গানিক লাইফ", contact: "মোস্তফা কামাল", phone: "01644444444", products: 56, rating: 4.7, status: "active" },
];

export default function Vendors() {
  const [search, setSearch] = useState("");

  const filtered = MOCK_VENDORS.filter((v) =>
    !search || v.name.includes(search) || v.contact.includes(search)
  );

  return (
    <div className="p-6">
      <SectionHeader title="ভেন্ডর" count={MOCK_VENDORS.length}>
        <SearchField value={search} onChange={setSearch} placeholder="ভেন্ডর খুঁজুন..." />
      </SectionHeader>

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">ভেন্ডর</th>
              <th className="text-left px-4 py-3 font-bangla">যোগাযোগ</th>
              <th className="text-left px-4 py-3 font-bangla">ফোন</th>
              <th className="text-left px-4 py-3 font-bangla">পণ্য সংখ্যা</th>
              <th className="text-left px-4 py-3 font-bangla">রেটিং</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {filtered.map((v) => (
              <tr key={v.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla font-medium">{v.name}</td>
                <td className="px-4 py-3 text-white/60 font-bangla">{v.contact}</td>
                <td className="px-4 py-3 text-white/60">{v.phone}</td>
                <td className="px-4 py-3 text-white">{v.products}</td>
                <td className="px-4 py-3 text-yellow-400">{v.rating}</td>
                <td className="px-4 py-3"><StatusBadge status={v.status} /></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
