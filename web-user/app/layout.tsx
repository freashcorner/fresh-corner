import "./globals.css";
import { Hind_Siliguri, Tiro_Bangla } from "next/font/google";

const hind = Hind_Siliguri({ subsets: ["bengali"], weight: "400" });
const tiro = Tiro_Bangla({ subsets: ["bengali"], weight: "400" });

export const metadata = {
  title: "ফ্রেশ কর্নার - তাজা বাজার দোরগোড়ায়",
  description: "বাংলাদেশের সবচেয়ে বিশ্বস্ত অনলাইন কৃষি বাজার",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="bn">
      <body className={hind.className}>
        {children}
      </body>
    </html>
  );
}
