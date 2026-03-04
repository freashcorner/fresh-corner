"use client";
import { useAuthStore } from "@/store/authStore";
import { Award, ShoppingBag, MapPin, CreditCard } from "lucide-react";
import Link from "next/link";

export default function ProfilePage() {
  const { user } = useAuthStore();

  return (
    <div className="page-container">
      {/* Profile Header */}
      <div className="profile-header">
        <div className="profile-avatar">
          {user ? (user.displayName?.[0] || "U") : "?"}
        </div>
        <h1 className="text-2xl font-bold font-bangla">{user?.displayName || "অতিথি"}</h1>
        <p className="text-[var(--text2)] font-bangla mt-1">{user?.phoneNumber || "লগইন করুন"}</p>
        {!user && (
          <Link href="/login" className="btn-primary font-bangla mt-4">লগইন করুন</Link>
        )}
      </div>

      {/* Loyalty Card */}
      <div className="loyalty-card mb-6">
        <div className="relative z-10">
          <div className="flex items-center gap-2 mb-3">
            <Award size={20} />
            <span className="font-semibold font-bangla">লয়্যালটি কার্ড</span>
          </div>
          <div className="text-3xl font-bold mb-1">১,২৫০ পয়েন্ট</div>
          <div className="text-white/70 text-sm font-bangla">গোল্ড মেম্বার</div>
          <div className="mt-4 bg-white/20 rounded-full h-2">
            <div className="bg-white rounded-full h-2" style={{ width: '65%' }} />
          </div>
          <div className="text-white/70 text-xs mt-1 font-bangla">প্লাটিনাম হতে আরো ৭৫০ পয়েন্ট</div>
        </div>
      </div>

      {/* Stats */}
      <div className="stat-grid mb-6">
        <div className="stat-card">
          <div className="value">২৪</div>
          <div className="label font-bangla">মোট অর্ডার</div>
        </div>
        <div className="stat-card">
          <div className="value">৳১২,৪৫০</div>
          <div className="label font-bangla">মোট খরচ</div>
        </div>
        <div className="stat-card">
          <div className="value">৳৮৫০</div>
          <div className="label font-bangla">সঞ্চয়</div>
        </div>
      </div>

      {/* Quick Links */}
      <div className="glass-card overflow-hidden">
        {[
          { icon: ShoppingBag, label: "আমার অর্ডার", href: "/orders" },
          { icon: MapPin, label: "ঠিকানা সমূহ", href: "/settings" },
          { icon: CreditCard, label: "পেমেন্ট মেথড", href: "/settings" },
          { icon: Award, label: "রিওয়ার্ড", href: "/profile" },
        ].map(({ icon: Icon, label, href }, i) => (
          <Link key={label} href={href} className="settings-item">
            <div className="left">
              <div className="icon-wrap"><Icon size={18} /></div>
              <span className="label font-bangla">{label}</span>
            </div>
            <span className="text-[var(--text3)]">→</span>
          </Link>
        ))}
      </div>
    </div>
  );
}
