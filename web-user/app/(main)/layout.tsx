import Navbar from "@/components/layout/Navbar";
import BottomNav from "@/components/layout/BottomNav";

export default function MainLayout({ children }: { children: React.ReactNode }) {
  return (
    <div className="max-w-lg mx-auto min-h-screen bg-[#F4F6F8]">
      <Navbar />
      <main className="pb-20">{children}</main>
      <BottomNav />
    </div>
  );
}
