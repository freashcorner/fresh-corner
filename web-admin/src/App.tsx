import { useEffect } from "react";
import { Routes, Route, Navigate } from "react-router-dom";
import { onAuthStateChanged } from "firebase/auth";
import { Toaster } from "react-hot-toast";
import { auth } from "./lib/firebase";
import { useAuthStore } from "./store/authStore";
import Layout from "./components/Layout";
import LoginPage from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import LiveMonitor from "./pages/LiveMonitor";
import Orders from "./pages/Orders";
import Dispatch from "./pages/Dispatch";
import Returns from "./pages/Returns";
import Products from "./pages/Products";
import Inventory from "./pages/Inventory";
import Categories from "./pages/Categories";
import Customers from "./pages/Customers";
import Riders from "./pages/Riders";
import Vendors from "./pages/Vendors";
import Staff from "./pages/Staff";
import Promos from "./pages/Promos";
import Notifications from "./pages/Notifications";
import Banners from "./pages/Banners";
import Finance from "./pages/Finance";
import Payouts from "./pages/Payouts";
import Analytics from "./pages/Analytics";
import Reports from "./pages/Reports";
import Support from "./pages/Support";
import Settings from "./pages/Settings";
import ActivityLogs from "./pages/ActivityLogs";

function ProtectedRoute({ children }: { children: React.ReactNode }) {
  const { user, loading, role } = useAuthStore();
  if (loading) return <div className="flex h-screen items-center justify-center bg-bg text-white">লোড হচ্ছে...</div>;
  if (!user || role !== "admin") return <Navigate to="/login" replace />;
  return <>{children}</>;
}

export default function App() {
  const { setUser, setLoading } = useAuthStore();

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (user) => {
      if (user) {
        const token = await user.getIdTokenResult();
        setUser(user, token.claims.role as string);
      } else {
        setUser(null);
      }
      setLoading(false);
    });
    return unsub;
  }, [setUser, setLoading]);

  return (
    <>
      <Toaster position="top-right" toastOptions={{ style: { background: "#2D2D2D", color: "#F2F2F2" } }} />
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        <Route
          path="/"
          element={
            <ProtectedRoute>
              <Layout />
            </ProtectedRoute>
          }
        >
          {/* প্রধান */}
          <Route index element={<Dashboard />} />
          <Route path="live-monitor" element={<LiveMonitor />} />
          {/* অর্ডার */}
          <Route path="orders" element={<Orders />} />
          <Route path="dispatch" element={<Dispatch />} />
          <Route path="returns" element={<Returns />} />
          {/* পণ্য */}
          <Route path="products" element={<Products />} />
          <Route path="inventory" element={<Inventory />} />
          <Route path="categories" element={<Categories />} />
          {/* ব্যবহারকারী */}
          <Route path="customers" element={<Customers />} />
          <Route path="riders" element={<Riders />} />
          <Route path="vendors" element={<Vendors />} />
          <Route path="staff" element={<Staff />} />
          {/* মার্কেটিং */}
          <Route path="promos" element={<Promos />} />
          <Route path="notifications" element={<Notifications />} />
          <Route path="banners" element={<Banners />} />
          {/* অর্থ */}
          <Route path="finance" element={<Finance />} />
          <Route path="payouts" element={<Payouts />} />
          {/* বিশ্লেষণ */}
          <Route path="analytics" element={<Analytics />} />
          <Route path="reports" element={<Reports />} />
          {/* সিস্টেম */}
          <Route path="support" element={<Support />} />
          <Route path="settings" element={<Settings />} />
          <Route path="activity-logs" element={<ActivityLogs />} />
          {/* Redirects for old routes */}
          <Route path="users" element={<Navigate to="/customers" replace />} />
          <Route path="delivery" element={<Navigate to="/dispatch" replace />} />
        </Route>
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </>
  );
}
