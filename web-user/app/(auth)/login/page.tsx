"use client";
import { useState } from "react";
import { RecaptchaVerifier, signInWithPhoneNumber, ConfirmationResult } from "firebase/auth";
import { auth } from "@/lib/firebase";
import api from "@/lib/api";
import { useRouter } from "next/navigation";
import toast from "react-hot-toast";

declare global { interface Window { recaptchaVerifier: RecaptchaVerifier; confirmationResult: ConfirmationResult; } }

export default function LoginPage() {
  const [phone, setPhone] = useState("");
  const [otp, setOtp] = useState("");
  const [name, setName] = useState("");
  const [step, setStep] = useState<"phone" | "otp" | "register">("phone");
  const [loading, setLoading] = useState(false);
  const router = useRouter();

  function setupRecaptcha() {
    if (!window.recaptchaVerifier) {
      window.recaptchaVerifier = new RecaptchaVerifier(auth, "recaptcha-container", { size: "invisible" });
    }
  }

  async function sendOTP() {
    setLoading(true);
    try {
      setupRecaptcha();
      const fullPhone = phone.startsWith("+") ? phone : `+88${phone}`;
      window.confirmationResult = await signInWithPhoneNumber(auth, fullPhone, window.recaptchaVerifier);
      setStep("otp");
      toast.success("OTP পাঠানো হয়েছে");
    } catch {
      toast.error("OTP পাঠানো যায়নি");
    } finally {
      setLoading(false);
    }
  }

  async function verifyOTP() {
    setLoading(true);
    try {
      const result = await window.confirmationResult.confirm(otp);
      const user = result.user;
      // Check if user exists
      try {
        await api.get("/api/auth/me");
        router.push("/");
      } catch {
        setStep("register");
      }
    } catch {
      toast.error("OTP ভুল হয়েছে");
    } finally {
      setLoading(false);
    }
  }

  async function handleRegister() {
    setLoading(true);
    try {
      await api.post("/api/auth/register", { name, phone });
      toast.success("নিবন্ধন সফল!");
      router.push("/");
    } catch {
      toast.error("নিবন্ধন ব্যর্থ");
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#1A4731] to-[#2ECC71] flex items-end">
      <div id="recaptcha-container" />
      <div className="w-full bg-white rounded-t-3xl px-6 py-8">
        <div className="text-center mb-8">
          <h1 className="text-2xl font-bold text-gray-800 font-tiro">ফ্রেশ কর্নার</h1>
          <p className="text-gray-400 text-sm font-bangla mt-1">তাজা বাজার, দোরগোড়ায় ডেলিভারি</p>
        </div>

        {step === "phone" && (
          <div className="space-y-4">
            <div>
              <label className="text-xs text-gray-500 font-bangla mb-1.5 block">মোবাইল নম্বর</label>
              <div className="flex gap-2">
                <div className="flex items-center bg-gray-100 rounded-xl px-3 text-sm text-gray-600 font-bold">🇧🇩 +88</div>
                <input
                  type="tel"
                  placeholder="01XXXXXXXXX"
                  value={phone}
                  onChange={(e) => setPhone(e.target.value)}
                  className="flex-1 border border-gray-200 rounded-xl px-4 py-3 text-sm outline-none focus:border-[#2ECC71]"
                />
              </div>
            </div>
            <button onClick={sendOTP} disabled={loading || phone.length < 10} className="w-full bg-[#2ECC71] hover:bg-[#27AE60] disabled:opacity-50 text-white font-bold py-3.5 rounded-xl font-bangla">
              {loading ? "পাঠানো হচ্ছে..." : "OTP পাঠান"}
            </button>
          </div>
        )}

        {step === "otp" && (
          <div className="space-y-4">
            <div>
              <label className="text-xs text-gray-500 font-bangla mb-1.5 block">OTP কোড লিখুন</label>
              <input
                type="number"
                placeholder="6 সংখ্যার OTP"
                value={otp}
                onChange={(e) => setOtp(e.target.value)}
                maxLength={6}
                className="w-full border border-gray-200 rounded-xl px-4 py-3 text-center text-2xl font-bold outline-none focus:border-[#2ECC71] tracking-widest"
              />
            </div>
            <button onClick={verifyOTP} disabled={loading || otp.length < 6} className="w-full bg-[#2ECC71] hover:bg-[#27AE60] disabled:opacity-50 text-white font-bold py-3.5 rounded-xl font-bangla">
              {loading ? "যাচাই হচ্ছে..." : "যাচাই করুন"}
            </button>
            <button onClick={() => setStep("phone")} className="w-full text-gray-400 text-sm font-bangla">পেছনে যান</button>
          </div>
        )}

        {step === "register" && (
          <div className="space-y-4">
            <div>
              <label className="text-xs text-gray-500 font-bangla mb-1.5 block">আপনার নাম</label>
              <input
                type="text"
                placeholder="নাম লিখুন"
                value={name}
                onChange={(e) => setName(e.target.value)}
                className="w-full border border-gray-200 rounded-xl px-4 py-3 text-sm outline-none focus:border-[#2ECC71] font-bangla"
              />
            </div>
            <button onClick={handleRegister} disabled={loading || !name} className="w-full bg-[#2ECC71] hover:bg-[#27AE60] disabled:opacity-50 text-white font-bold py-3.5 rounded-xl font-bangla">
              {loading ? "নিবন্ধন হচ্ছে..." : "নিবন্ধন করুন"}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
