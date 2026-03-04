"use client";
import { MapPin, Phone, Clock } from "lucide-react";

const DEMO_STEPS = [
  { title: "অর্ডার গৃহীত", time: "আজ, ১০:৩০ AM", active: true },
  { title: "অর্ডার নিশ্চিত", time: "আজ, ১০:৩২ AM", active: true },
  { title: "প্রস্তুত হচ্ছে", time: "আজ, ১০:৪৫ AM", active: true },
  { title: "ডেলিভারি ম্যান বের হয়েছে", time: "আজ, ১১:০০ AM", active: false },
  { title: "পৌঁছে গেছে", time: "", active: false },
];

export default function TrackingPage() {
  return (
    <div className="page-container">
      <h1 className="text-2xl font-bold font-bangla mb-6">লাইভ ট্র্যাকিং</h1>

      {/* Map */}
      <div className="tracking-map mb-6">
        <div className="map-placeholder">
          <MapPin size={48} className="mx-auto mb-3 opacity-50" />
          <p className="font-bangla text-lg">ম্যাপ ভিউ</p>
          <p className="font-bangla text-sm mt-1">অর্ডার করলে এখানে লাইভ লোকেশন দেখা যাবে</p>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {/* Tracking Steps */}
        <div className="glass-card p-6">
          <h2 className="font-bold font-bangla text-lg mb-4">অর্ডার স্ট্যাটাস</h2>
          <div className="tracking-steps">
            {DEMO_STEPS.map((step, i) => (
              <div key={i} className="tracking-step">
                <div className="step-line">
                  <div className={`step-dot ${step.active ? "active" : ""}`} />
                  {i < DEMO_STEPS.length - 1 && <div className={`step-connector ${step.active && DEMO_STEPS[i + 1]?.active ? "active" : ""}`} />}
                </div>
                <div className="step-content">
                  <div className={`step-title font-bangla ${!step.active ? "opacity-40" : ""}`}>{step.title}</div>
                  {step.time && <div className="step-time font-bangla">{step.time}</div>}
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Delivery Info */}
        <div>
          <div className="glass-card p-6 mb-4">
            <h2 className="font-bold font-bangla text-lg mb-4">ডেলিভারি তথ্য</h2>
            <div className="flex items-center gap-3 mb-4">
              <div className="w-12 h-12 rounded-full bg-[rgba(46,204,113,0.15)] flex items-center justify-center text-xl">🛵</div>
              <div>
                <div className="font-semibold font-bangla">রহিম উদ্দিন</div>
                <div className="text-sm text-[var(--text2)] font-bangla">ডেলিভারি ম্যান</div>
              </div>
              <button className="ml-auto w-10 h-10 rounded-xl bg-[rgba(46,204,113,0.15)] flex items-center justify-center text-[var(--g1)]">
                <Phone size={18} />
              </button>
            </div>
            <div className="flex items-center gap-2 text-sm text-[var(--text2)]">
              <Clock size={14} />
              <span className="font-bangla">আনুমানিক সময়: ১৫-২০ মিনিট</span>
            </div>
          </div>

          <div className="glass-card p-6">
            <h2 className="font-bold font-bangla text-lg mb-3">ডেলিভারি ঠিকানা</h2>
            <div className="flex items-start gap-2 text-sm text-[var(--text2)]">
              <MapPin size={16} className="text-[var(--g1)] mt-0.5 flex-shrink-0" />
              <span className="font-bangla">বাসা ১২, রোড ৫, ধানমন্ডি, ঢাকা-১২০৫</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
