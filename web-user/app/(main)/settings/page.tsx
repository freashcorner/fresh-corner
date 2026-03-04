"use client";
import { useState } from "react";
import { Bell, Globe, Moon, Shield, HelpCircle, LogOut, ChevronRight } from "lucide-react";
import { useAuthStore } from "@/store/authStore";
import { auth } from "@/lib/firebase";
import { useRouter } from "next/navigation";
import toast from "react-hot-toast";

export default function SettingsPage() {
  const [notifications, setNotifications] = useState(true);
  const [darkMode, setDarkMode] = useState(true);
  const { user } = useAuthStore();
  const router = useRouter();

  async function handleLogout() {
    await auth.signOut();
    toast.success("লগআউট সফল");
    router.push("/");
  }

  return (
    <div className="page-container">
      <h1 className="text-2xl font-bold font-bangla mb-6">সেটিংস</h1>

      {/* Preferences */}
      <h2 className="text-sm font-semibold text-[var(--text2)] font-bangla mb-3 uppercase tracking-wider">পছন্দসমূহ</h2>
      <div className="settings-group">
        <div className="settings-item">
          <div className="left">
            <div className="icon-wrap"><Bell size={18} /></div>
            <div>
              <div className="label font-bangla">নোটিফিকেশন</div>
              <div className="sublabel font-bangla">পুশ নোটিফিকেশন চালু/বন্ধ</div>
            </div>
          </div>
          <button className={`toggle ${notifications ? "on" : ""}`} onClick={() => setNotifications(!notifications)}>
            <div className="knob" />
          </button>
        </div>
        <div className="settings-item">
          <div className="left">
            <div className="icon-wrap"><Moon size={18} /></div>
            <div>
              <div className="label font-bangla">ডার্ক মোড</div>
              <div className="sublabel font-bangla">অন্ধকার থিম</div>
            </div>
          </div>
          <button className={`toggle ${darkMode ? "on" : ""}`} onClick={() => setDarkMode(!darkMode)}>
            <div className="knob" />
          </button>
        </div>
        <div className="settings-item">
          <div className="left">
            <div className="icon-wrap"><Globe size={18} /></div>
            <div>
              <div className="label font-bangla">ভাষা</div>
              <div className="sublabel font-bangla">বাংলা</div>
            </div>
          </div>
          <ChevronRight size={18} className="text-[var(--text3)]" />
        </div>
      </div>

      {/* Support */}
      <h2 className="text-sm font-semibold text-[var(--text2)] font-bangla mb-3 mt-6 uppercase tracking-wider">সাপোর্ট</h2>
      <div className="settings-group">
        <div className="settings-item">
          <div className="left">
            <div className="icon-wrap"><HelpCircle size={18} /></div>
            <div>
              <div className="label font-bangla">সাহায্য কেন্দ্র</div>
              <div className="sublabel font-bangla">FAQ ও গাইড</div>
            </div>
          </div>
          <ChevronRight size={18} className="text-[var(--text3)]" />
        </div>
        <div className="settings-item">
          <div className="left">
            <div className="icon-wrap"><Shield size={18} /></div>
            <div>
              <div className="label font-bangla">গোপনীয়তা নীতি</div>
              <div className="sublabel font-bangla">আপনার তথ্যের নিরাপত্তা</div>
            </div>
          </div>
          <ChevronRight size={18} className="text-[var(--text3)]" />
        </div>
      </div>

      {/* Logout */}
      {user && (
        <button onClick={handleLogout} className="settings-group w-full mt-6">
          <div className="settings-item" style={{ justifyContent: 'center' }}>
            <div className="flex items-center gap-2 text-red-400">
              <LogOut size={18} />
              <span className="font-bangla font-semibold">লগআউট</span>
            </div>
          </div>
        </button>
      )}
    </div>
  );
}
