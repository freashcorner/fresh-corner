import { collection, getDocs, query, where, orderBy, limit } from "firebase/firestore";
import { db } from "@/lib/firebase";
import ProductCard from "@/components/product/ProductCard";
import Link from "next/link";

export const revalidate = 3600;

async function getHomeData() {
  try {
    const [catsSnap, featuredSnap] = await Promise.all([
      getDocs(query(collection(db, "categories"), where("isActive", "==", true), orderBy("order"), limit(10))),
      getDocs(query(collection(db, "products"), where("isActive", "==", true), where("isFeatured", "==", true), limit(8))),
    ]);
    return {
      categories: catsSnap.docs.map((d) => ({ id: d.id, ...d.data() })) as any[],
      featured: featuredSnap.docs.map((d) => ({ id: d.id, ...d.data() })) as any[],
    };
  } catch (error) {
    console.error("Error fetching home data:", error);
    return { categories: [], featured: [] };
  }
}

export default async function HomePage() {
  const { categories, featured } = await getHomeData();

  return (
    <div>
      {/* Hero Section */}
      <section className="hero">
        <div className="hero-glow" />
        <div className="hero-content" style={{ paddingTop: "64px" }}>
          <div className="hero-text">
            <div className="hero-badge">
              <span className="pulse" />
              ১০০% তাজা ও সতেজ
            </div>
            <h1 className="font-tiro">
              তাজা বাজার
              <br />
              <span className="text-gradient">দোরগোড়ায়</span>
            </h1>
            <p className="hero-desc font-bangla">
              সেরা মানের শাকসবজি, ফল ও মুদিখানা পণ্য এখন আপনার হাতের নাগালে। 
              দ্রুত ডেলিভারি, সেরা দাম।
            </p>
            <div className="hero-actions">
              <Link href="/shop" className="btn-primary font-bangla">
                কেনাকাটা শুরু করুন →
              </Link>
              <Link href="/tracking" className="btn-outline font-bangla">
                অর্ডার ট্র্যাক করুন
              </Link>
            </div>
            <div className="hero-stats">
              <div className="hst">
                <div className="hst-v">৫০,০০০+</div>
                <div className="hst-l">সন্তুষ্ট গ্রাহক</div>
              </div>
              <div className="hst">
                <div className="hst-v">১,০০০+</div>
                <div className="hst-l">পণ্যের ধরন</div>
              </div>
              <div className="hst">
                <div className="hst-v">৩০ মিনিট</div>
                <div className="hst-l">ফ্রি ডেলিভারি</div>
              </div>
            </div>
          </div>
          <div className="hero-visual">
            <div className="mock-phone">
              <div className="mock-notch" />
              <div className="mock-screen">
                <div className="ms-status">
                  <span>🥬 FreshCorner</span>
                  <span>🛒 3</span>
                </div>
                <div className="ms-head">
                  <div className="ms-loc">Deliver to</div>
                  <div className="ms-loc-main">Home - Bashundhara R/A</div>
                </div>
                <div className="ms-card">
                  <div className="ms-prod">
                    <div className="ms-p-img">🥬</div>
                    <div>
                      <div className="ms-p-n">সবুজ শসা</div>
                      <div className="ms-p-p">৳৪০/কেজি</div>
                    </div>
                  </div>
                  <div className="ms-prod">
                    <div className="ms-p-img">🍅</div>
                    <div>
                      <div className="ms-p-n">টমেটো</div>
                      <div className="ms-p-p">৳৬০/কেজি</div>
                    </div>
                  </div>
                  <button className="ms-cta">অর্ডার করুন</button>
                </div>
                <div className="ms-cart">
                  <span className="ms-c-l">৩টি পণ্য</span>
                  <span className="ms-c-r">৳৪৫০</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Trust Bar */}
      <div className="trust-bar">
        <div className="trust-item">
          <span className="trust-i">🚚</span>
          <div>
            <div className="trust-t">দ্রুত ডেলিভারি</div>
            <div className="trust-d">৩০ মিনিটে</div>
          </div>
        </div>
        <div className="trust-item">
          <span className="trust-i">🥬</span>
          <div>
            <div className="trust-t">১০০% তাজা</div>
            <div className="trust-d">খামার থেকে</div>
          </div>
        </div>
        <div className="trust-item">
          <span className="trust-i">💰</span>
          <div>
            <div className="trust-t">সেরা দাম</div>
            <div className="trust-d">গ্যারান্টি</div>
          </div>
        </div>
        <div className="trust-item">
          <span className="trust-i">🔒</span>
          <div>
            <div className="trust-t">নিরাপদ পেমেন্ট</div>
            <div className="trust-d">বিকাশ/নগদ</div>
          </div>
        </div>
      </div>

      {/* Categories */}
      <div className="page-container" style={{ paddingTop: 0 }}>
        <div className="section-header">
          <h2 className="font-bangla">ক্যাটাগরি</h2>
          <Link href="/shop" className="font-bangla" style={{ color: "var(--g1)", fontSize: "0.875rem" }}>
            সব দেখুন →
          </Link>
        </div>
        <div className="cat-grid">
          {categories.length > 0 ? categories.map((c: any) => (
            <Link key={c.id} href={`/category/${c.slug}`} className="cat-card">
              <div className="cat-icon">{c.icon || "🛒"}</div>
              <div className="cat-name font-bangla">{c.name}</div>
            </Link>
          )) : (
            [
              { icon: "🥬", name: "শাকসবজি", slug: "vegetables" },
              { icon: "🍎", name: "ফলমূল", slug: "fruits" },
              { icon: "🐟", name: "মাছ", slug: "fish" },
              { icon: "🍖", name: "মাংস", slug: "meat" },
              { icon: "🍚", name: "চাল ও ডাল", slug: "rice" },
              { icon: "🫙", name: "মসলা", slug: "spices" },
              { icon: "🥛", name: "দুগ্ধ পণ্য", slug: "dairy" },
              { icon: "🧃", name: "পানীয়", slug: "drinks" },
            ].map((c) => (
              <Link key={c.slug} href={`/category/${c.slug}`} className="cat-card">
                <div className="cat-icon">{c.icon}</div>
                <div className="cat-name font-bangla">{c.name}</div>
              </Link>
            ))
          )}
        </div>
      </div>

      {/* Featured Products */}
      <div className="page-container" style={{ paddingTop: "1rem" }}>
        <div className="section-header">
          <h2 className="font-bangla">বিশেষ অফার</h2>
          <Link href="/shop" className="font-bangla" style={{ color: "var(--g1)", fontSize: "0.875rem" }}>
            সব দেখুন →
          </Link>
        </div>
        <div className="products-grid">
          {featured.length > 0 ? featured.map((p: any) => (
            <ProductCard key={p.id} {...p} />
          )) : (
            [
              { id: "1", name: "সবুজ শসা", price: 40, unit: "কেজی", imageUrl: "", categoryId: "vegetables" },
              { id: "2", name: "টমেটো", price: 60, unit: "কেজি", imageUrl: "", categoryId: "vegetables" },
              { id: "3", name: "ব্রোকলি", price: 80, unit: "পিস", imageUrl: "", categoryId: "vegetables" },
              { id: "4", name: "গাজর", price: 50, unit: "কেজি", imageUrl: "", categoryId: "vegetables" },
              { id: "5", name: "আপেল", price: 150, unit: "কেজি", imageUrl: "", categoryId: "fruits" },
              { id: "6", name: "কমলা", price: 100, unit: "কেজি", imageUrl: "", categoryId: "fruits" },
              { id: "7", name: "কলা", price: 60, unit: "পিস", imageUrl: "", categoryId: "fruits" },
              { id: "8", name: "আঙুর", price: 200, unit: "কেজি", imageUrl: "", categoryId: "fruits" },
            ].map((p) => <ProductCard key={p.id} {...p} />)
          )}
        </div>
      </div>

      {/* Footer */}
      <footer className="footer">
        <div className="footer-grid">
          <div className="footer-col">
            <h4>ফ্রেশ কর্নার</h4>
            <p style={{ fontSize: ".85rem", color: "rgba(255,255,255,.5)", lineHeight: 1.6 }}>
              বাংলাদেশের সবচেয়ে বিশ্বস্ত অনলাইন কৃষি বাজার। তাজা শাকসবজি ও ফল সরাসরি আপনার দোরগোড়ায়।
            </p>
          </div>
          <div className="footer-col">
            <h4>দ্রুত লিংক</h4>
            <Link href="/">হোম</Link>
            <Link href="/shop">সব পণ্য</Link>
            <Link href="/tracking">অর্ডার ট্র্যাকিং</Link>
            <Link href="/about">আমাদের সম্পর্কে</Link>
          </div>
          <div className="footer-col">
            <h4>গ্রাহক সেবা</h4>
            <Link href="/contact">যোগাযোগ করুন</Link>
            <Link href="/faq">সাধারণ প্রশ্ন</Link>
            <Link href="/refund">রিফান্ড নীতি</Link>
            <Link href="/delivery">ডেলিভারি তথ্য</Link>
          </div>
          <div className="footer-col">
            <h4>যোগাযোগ</h4>
            <a href="tel:16xxx">📞 ১৬xxx (৯ঃ০০ - ১০ঃ০০)</a>
            <a href="mailto:support@freshcorner.com">📧 support@freshcorner.com</a>
            <a href="#">📍 ঢাকা, বাংলাদেশ</a>
          </div>
        </div>
        <div className="footer-bottom">
          © ২০২৪ ফ্রেশ কর্নার। সর্বস্বত্ব সংরক্ষিত।
        </div>
      </footer>
    </div>
  );
}
