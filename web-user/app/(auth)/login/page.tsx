"use client";
import { useState } from "react";
import { RecaptchaVerifier, signInWithPhoneNumber, ConfirmationResult } from "firebase/auth";
import { auth } from "@/lib/firebase";
import api from "@/lib/api";
import { useRouter } from "next/navigation";
import toast from "react-hot-toast";
import Link from "next/link";

declare global {
  interface Window {
    recaptchaVerifier: RecaptchaVerifier;
    confirmationResult: ConfirmationResult;
  }
}

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
      await window.confirmationResult.confirm(otp);
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
    <div className="login-page">
      <div id="recaptcha-container" />
      <div className="login-card">
        <div style={{ textAlign: "center", marginBottom: "2rem" }}>
          <div style={{
            width: 64, height: 64, background: "var(--g1)", borderRadius: 18,
            display: "flex", alignItems: "center", justifyContent: "center",
            fontSize: "2rem", margin: "0 auto 1rem"
          }}>🌿</div>
          <h1 style={{ fontSize: "1.5rem", fontWeight: 700, color: "var(--g1)", fontFamily: "'Tiro Bangla', serif" }}>
            ফ্রেশ কর্নার
          </h1>
          <p style={{ color: "var(--text2)", fontSize: "0.875rem", marginTop: "0.25rem" }} className="font-bangla">
            তাজা বাজার, দোরগোড়ায় ডেলিভারি
          </p>
        </div>

        {step === "phone" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
            <div>
              <label style={{ fontSize: "0.78rem", color: "var(--text2)", display: "block", marginBottom: "0.4rem" }} className="font-bangla">
                মোবাইল নম্বর
              </label>
              <div style={{ display: "flex", gap: "0.5rem" }}>
                <div style={{
                  display: "flex", alignItems: "center",
                  background: "var(--bg)", border: "1px solid var(--border)",
                  borderRadius: 12, padding: "0 0.875rem",
                  fontSize: "0.875rem", color: "var(--text2)", fontWeight: 700
                }}>+88</div>
                <input
                  type="tel" placeholder="01XXXXXXXXX"
                  value={phone} onChange={(e) => setPhone(e.target.value)}
                  style={{ flex: 1 }}
                />
              </div>
            </div>
            <button
              onClick={sendOTP}
              disabled={loading || phone.length < 10}
              className="btn-primary font-bangla"
              style={{ justifyContent: "center", opacity: loading || phone.length < 10 ? 0.5 : 1 }}
            >
              {loading ? "পাঠানো হচ্ছে..." : "OTP পাঠান"}
            </button>
            <p style={{ textAlign: "center", fontSize: "0.85rem", color: "var(--text2)" }} className="font-bangla">
              একাউন্ট নেই?{" "}
              <Link href="/register" style={{ color: "var(--g1)", textDecoration: "none" }}>নিবন্ধন করুন</Link>
            </p>
          </div>
        )}

        {step === "otp" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
            <input
              type="number" placeholder="6 সংখ্যার OTP"
              value={otp} onChange={(e) => setOtp(e.target.value)}
              maxLength={6}
              style={{ textAlign: "center", fontSize: "1.5rem", fontWeight: 700, letterSpacing: "0.25em" }}
            />
            <button
              onClick={verifyOTP}
              disabled={loading || otp.length < 6}
              className="btn-primary font-bangla"
              style={{ justifyContent: "center" }}
            >
              {loading ? "যাচাই হচ্ছে..." : "যাচাই করুন"}
            </button>
            <button
              onClick={() => setStep("phone")}
              style={{ background: "transparent", border: "none", color: "var(--text2)", cursor: "pointer", fontSize: "0.875rem" }}
              className="font-bangla"
            >
              পেছনে যান
            </button>
          </div>
        )}

        {step === "register" && (
          <div style={{ display: "flex", flexDirection: "column", gap: "1rem" }}>
            <input
              type="text" placeholder="নাম লিখুন"
              value={name} onChange={(e) => setName(e.target.value)}
              className="font-bangla"
            />
            <button
              onClick={handleRegister}
              disabled={loading || !name}
              className="btn-primary font-bangla"
              style={{ justifyContent: "center" }}
            >
              {loading ? "নিবন্ধন হচ্ছে..." : "নিবন্ধন করুন"}
            </button>
          </div>
        )}
      </div>
    </div>
  );
}
