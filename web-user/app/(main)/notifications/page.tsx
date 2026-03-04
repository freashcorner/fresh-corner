"use client";

const DEMO_NOTIFICATIONS = [
  { id: 1, icon: "🎉", iconClass: "green", title: "অর্ডার ডেলিভারি সম্পন্ন!", desc: "আপনার অর্ডার #FC2024 সফলভাবে ডেলিভারি হয়েছে।", time: "৫ মিনিট আগে", unread: true },
  { id: 2, icon: "🏷️", iconClass: "orange", title: "বিশেষ অফার!", desc: "সব শাকসবজিতে ২০% ছাড়! শুধু আজকের জন্য।", time: "১ ঘন্টা আগে", unread: true },
  { id: 3, icon: "📦", iconClass: "blue", title: "অর্ডার শিপড", desc: "আপনার অর্ডার #FC2023 ডেলিভারির জন্য বের হয়েছে।", time: "৩ ঘন্টা আগে", unread: false },
  { id: 4, icon: "🎁", iconClass: "green", title: "পয়েন্ট অর্জন!", desc: "আপনি ৫০ লয়্যালটি পয়েন্ট অর্জন করেছেন।", time: "গতকাল", unread: false },
  { id: 5, icon: "💳", iconClass: "blue", title: "পেমেন্ট সফল", desc: "৳৫৪০ পেমেন্ট সফলভাবে সম্পন্ন হয়েছে।", time: "গতকাল", unread: false },
];

export default function NotificationsPage() {
  return (
    <div className="page-container">
      <div className="section-header">
        <h1 className="text-2xl font-bold font-bangla">নোটিফিকেশন</h1>
        <button className="text-sm text-[var(--g1)] font-bangla hover:underline">সব পড়া হয়েছে</button>
      </div>

      {DEMO_NOTIFICATIONS.map((n) => (
        <div key={n.id} className={`notif-card ${n.unread ? "unread" : ""}`}>
          <div className={`notif-icon ${n.iconClass}`}>{n.icon}</div>
          <div className="flex-1 min-w-0">
            <div className="font-semibold font-bangla text-sm">{n.title}</div>
            <div className="text-sm text-[var(--text2)] font-bangla mt-0.5">{n.desc}</div>
            <div className="text-xs text-[var(--text3)] font-bangla mt-1">{n.time}</div>
          </div>
        </div>
      ))}
    </div>
  );
}
