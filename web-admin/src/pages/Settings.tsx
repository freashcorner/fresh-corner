import { useState } from "react";
import SectionHeader from "../components/SectionHeader";

interface Toggle {
  key: string;
  label: string;
  description: string;
  default: boolean;
}

const TOGGLES: Toggle[] = [
  { key: "storeOpen", label: "স্টোর খোলা", description: "স্টোর বন্ধ করলে নতুন অর্ডার নেওয়া হবে না", default: true },
  { key: "maintenance", label: "মেইনটেন্যান্স মোড", description: "অ্যাপ মেইনটেন্যান্স পেজ দেখাবে", default: false },
  { key: "notifications", label: "পুশ নোটিফিকেশন", description: "গ্রাহকদের পুশ নোটিফিকেশন পাঠানো", default: true },
  { key: "cod", label: "ক্যাশ অন ডেলিভারি", description: "COD পেমেন্ট পদ্ধতি সক্রিয়", default: true },
  { key: "onlinePayment", label: "অনলাইন পেমেন্ট", description: "বিকাশ/নগদ পেমেন্ট সক্রিয়", default: true },
  { key: "newRegistration", label: "নতুন রেজিস্ট্রেশন", description: "নতুন ব্যবহারকারী রেজিস্ট্রেশন অনুমোদন", default: true },
  { key: "autoAssign", label: "অটো রাইডার অ্যাসাইন", description: "নিকটবর্তী রাইডারকে স্বয়ংক্রিয় নিযুক্ত", default: false },
  { key: "orderTracking", label: "অর্ডার ট্র্যাকিং", description: "গ্রাহক লাইভ ট্র্যাকিং দেখতে পারবে", default: true },
];

export default function Settings() {
  const [settings, setSettings] = useState<Record<string, boolean>>(
    Object.fromEntries(TOGGLES.map((t) => [t.key, t.default]))
  );

  function toggle(key: string) {
    setSettings((prev) => ({ ...prev, [key]: !prev[key] }));
  }

  return (
    <div className="p-6">
      <SectionHeader title="সেটিংস" />

      <div className="space-y-3 max-w-2xl">
        {TOGGLES.map((t) => (
          <div key={t.key} className="bg-[#2D2D2D] rounded-xl border border-white/10 p-4 flex items-center justify-between">
            <div>
              <div className="text-sm text-white font-bangla font-medium">{t.label}</div>
              <div className="text-xs text-white/40 font-bangla mt-0.5">{t.description}</div>
            </div>
            <button
              onClick={() => toggle(t.key)}
              className={`w-11 h-6 rounded-full transition-colors relative ${settings[t.key] ? "bg-yaru-orange" : "bg-white/15"}`}
            >
              <div className={`w-4 h-4 bg-white rounded-full absolute top-1 transition-all ${settings[t.key] ? "left-6" : "left-1"}`} />
            </button>
          </div>
        ))}
      </div>
    </div>
  );
}
