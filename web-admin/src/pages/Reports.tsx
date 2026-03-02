import { FileText, ShoppingCart, Package, Bike, Users, DollarSign } from "lucide-react";
import SectionHeader from "../components/SectionHeader";

const REPORT_CARDS = [
  { title: "বিক্রয় রিপোর্ট", description: "দৈনিক, সাপ্তাহিক, মাসিক বিক্রয় বিশ্লেষণ", icon: FileText, color: "bg-yaru-orange/10 text-yaru-orange" },
  { title: "অর্ডার রিপোর্ট", description: "অর্ডার স্ট্যাটাস, বাতিল হার, গড় মূল্য", icon: ShoppingCart, color: "bg-blue-500/10 text-blue-400" },
  { title: "পণ্য রিপোর্ট", description: "বেস্ট সেলার, কম বিক্রি, স্টক পরিস্থিতি", icon: Package, color: "bg-green-500/10 text-green-400" },
  { title: "রাইডার রিপোর্ট", description: "ডেলিভারি পারফর্ম্যান্স, সময়, রেটিং", icon: Bike, color: "bg-purple-500/10 text-purple-400" },
  { title: "গ্রাহক রিপোর্ট", description: "নতুন গ্রাহক, রিটেনশন, এলাকা অনুযায়ী", icon: Users, color: "bg-cyan-500/10 text-cyan-400" },
  { title: "ফাইন্যান্স রিপোর্ট", description: "আয়-ব্যয়, লাভ-ক্ষতি, পেমেন্ট পদ্ধতি", icon: DollarSign, color: "bg-yellow-500/10 text-yellow-400" },
];

export default function Reports() {
  return (
    <div className="p-6">
      <SectionHeader title="রিপোর্ট সেন্টার" />

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
        {REPORT_CARDS.map(({ title, description, icon: Icon, color }) => (
          <div key={title} className="bg-[#2D2D2D] rounded-xl border border-white/10 p-5 hover:border-yaru-orange/30 transition-colors cursor-pointer group">
            <div className={`w-12 h-12 rounded-lg ${color} flex items-center justify-center mb-4`}>
              <Icon size={22} />
            </div>
            <h3 className="text-sm font-semibold text-white font-bangla mb-1">{title}</h3>
            <p className="text-xs text-white/40 font-bangla">{description}</p>
            <button className="mt-4 text-xs text-yaru-orange font-bangla group-hover:underline">রিপোর্ট তৈরি করুন →</button>
          </div>
        ))}
      </div>
    </div>
  );
}
