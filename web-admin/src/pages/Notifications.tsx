import SectionHeader from "../components/SectionHeader";

const MOCK_NOTIFICATIONS = [
  { id: "N-001", title: "নতুন অফার!", type: "promo", sentTo: 1250, opened: 890, date: "২০২৬-০৩-০১" },
  { id: "N-002", title: "অর্ডার আপডেট", type: "order", sentTo: 45, opened: 42, date: "২০২৬-০৩-০১" },
  { id: "N-003", title: "ফ্ল্যাশ সেল শুরু!", type: "promo", sentTo: 2100, opened: 1560, date: "২০২৬-০২-২৮" },
  { id: "N-004", title: "ডেলিভারি বিলম্ব নোটিশ", type: "system", sentTo: 320, opened: 280, date: "২০২৬-০২-২৭" },
  { id: "N-005", title: "নতুন পণ্য যোগ হয়েছে", type: "product", sentTo: 1800, opened: 1200, date: "২০২৬-০২-২৫" },
];

const TYPE_LABELS: Record<string, string> = {
  promo: "প্রোমো",
  order: "অর্ডার",
  system: "সিস্টেম",
  product: "পণ্য",
};

const TYPE_COLORS: Record<string, string> = {
  promo: "bg-yaru-orange/15 text-yaru-orange",
  order: "bg-blue-500/15 text-blue-400",
  system: "bg-purple-500/15 text-purple-400",
  product: "bg-green-500/15 text-green-400",
};

export default function Notifications() {
  return (
    <div className="p-6">
      <SectionHeader title="নোটিফিকেশন" count={MOCK_NOTIFICATIONS.length} />

      <div className="bg-[#2D2D2D] rounded-xl border border-white/10 overflow-hidden">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-white/10 text-white/40 text-xs">
              <th className="text-left px-4 py-3 font-bangla">শিরোনাম</th>
              <th className="text-left px-4 py-3 font-bangla">ধরন</th>
              <th className="text-left px-4 py-3 font-bangla">পাঠানো</th>
              <th className="text-left px-4 py-3 font-bangla">দেখেছে</th>
              <th className="text-left px-4 py-3 font-bangla">হার</th>
              <th className="text-left px-4 py-3 font-bangla">তারিখ</th>
            </tr>
          </thead>
          <tbody className="divide-y divide-white/5">
            {MOCK_NOTIFICATIONS.map((n) => (
              <tr key={n.id} className="hover:bg-white/3">
                <td className="px-4 py-3 text-white font-bangla">{n.title}</td>
                <td className="px-4 py-3">
                  <span className={`text-xs px-2 py-1 rounded-full ${TYPE_COLORS[n.type]}`}>{TYPE_LABELS[n.type]}</span>
                </td>
                <td className="px-4 py-3 text-white">{n.sentTo.toLocaleString()}</td>
                <td className="px-4 py-3 text-white">{n.opened.toLocaleString()}</td>
                <td className="px-4 py-3 text-g1 font-semibold">{((n.opened / n.sentTo) * 100).toFixed(0)}%</td>
                <td className="px-4 py-3 text-white/40 text-xs">{n.date}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
