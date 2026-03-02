import StatusBadge from "../components/StatusBadge";
import SectionHeader from "../components/SectionHeader";

const MOCK_BANNERS = [
  { id: "B-001", title: "রমজান স্পেশাল", position: "Home Top", clicks: 1250, impressions: 8900, status: "active", image: "" },
  { id: "B-002", title: "ফ্রি ডেলিভারি", position: "Home Middle", clicks: 890, impressions: 6200, status: "active", image: "" },
  { id: "B-003", title: "নতুন পণ্য", position: "Category Top", clicks: 560, impressions: 4100, status: "inactive", image: "" },
  { id: "B-004", title: "সুপার সেল", position: "Home Bottom", clicks: 2100, impressions: 12000, status: "active", image: "" },
];

export default function Banners() {
  return (
    <div className="p-6">
      <SectionHeader title="ব্যানার" count={MOCK_BANNERS.length} />

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">শিরোনাম</th>
              <th className="text-left px-4 py-3 font-bangla">অবস্থান</th>
              <th className="text-left px-4 py-3 font-bangla">ক্লিক</th>
              <th className="text-left px-4 py-3 font-bangla">ইমপ্রেশন</th>
              <th className="text-left px-4 py-3 font-bangla">CTR</th>
              <th className="text-left px-4 py-3 font-bangla">স্ট্যাটাস</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {MOCK_BANNERS.map((b) => (
              <tr key={b.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla font-medium">{b.title}</td>
                <td className="px-4 py-3 text-white/60">{b.position}</td>
                <td className="px-4 py-3 text-white">{b.clicks.toLocaleString()}</td>
                <td className="px-4 py-3 text-white">{b.impressions.toLocaleString()}</td>
                <td className="px-4 py-3 text-g1 font-semibold">{((b.clicks / b.impressions) * 100).toFixed(1)}%</td>
                <td className="px-4 py-3"><StatusBadge status={b.status} /></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
