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
        <div className="hero-content">
          <div className="hero-text">
            <div className="hero-badge">
              <span className="pulse"></span>
              ১০০% তাজা ও সতেজ
            </div>
            <h1>
              তাজা বাজার
              <br />
              <span className="text-gradient">দোরগোড়ায়</span>
            </h1>
            <p className="hero-desc">
              সেরা মানের শাকসবজি, ফল ও মুদিখানা পণ্য এখন আপনার হাতের নাগালে। 
              দ্রুত ডেলিভারি, সেরা দাম।
            </p>
            <div className="hero-actions">
              <Link href="/shop" className="btn-primary">
                কেনাকাটা শুরু করুন →
              </Link>
              <Link href="/tracking" className="btn-outline">
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
            <div className="mock-phone" style={{
              width: "280px",
              background: "#0a1a10",
              border: "2px solid rgba(46,204,113,.22)",
              borderRadius: "40px",
              padding: "12px",
              boxShadow: "0 40px 90px rgba(0,0,0,.55)"
            }}>
              <div style={{ width: "72px", height: "5px", background: "rgba(255,255,255,.1)", borderRadius: "10px", margin: "0 auto 10px" }}></div>
              <div style={{ background: "#F4F6F8", borderRadius: "28px", overflow: "hidden", minHeight: "500px", color: "#0F1E14" }}>
                <div style={{ background: "#2ECC71", padding: "7px 14px", display: "flex", justifyContent: "space-between", fontSize: "8.5px", color: "#fff", fontWeight: "600" }}>
                  <span>🥬 FreshCorner</span>
                  <span>🛒 3</span>
                </div>
                <div style={{ background: "#2ECC71", padding: "10px 12px 20px" }}>
                  <div style={{ fontSize: "8px", color: "rgba(255,255,255,.8)", marginBottom: "3px" }}>Deliver to</div>
                  <div style={{ fontSize: "10px", fontWeight: "700" }}>Home - Bashundhara R/A</div>
                </div>
                <div style={{ background: "#fff", borderRadius: "12px", padding: "10px", margin: "8px", boxShadow: "0 2px 8px rgba(0,0,0,.08)" }}>
                  <div style={{ display: "flex", gap: "8px", alignItems: "center", marginBottom: "8px" }}>
                    <div style={{ width: "40px", height: "40px", background: "#D5F5E3", borderRadius: "8px", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "1.5rem" }}>🥬</div>
                    <div>
                      <div style={{ fontSize: "9px", fontWeight: "600" }}>সবুজ শসা</div>
                      <div style={{ fontSize: "8px", color: "#5D6D7E" }}>৳৪০/কেজি</div>
                    </div>
                  </div>
                  <div style={{ display: "flex", gap: "8px", alignItems: "center", marginBottom: "8px" }}>
                    <div style={{ width: "40px", height: "40px", background: "#D5F5E3", borderRadius: "8px", display: "flex", alignItems: "center", justifyContent: "center", fontSize: "1.5rem" }}>🍅</div>
                    <div>
                      <div style={{ fontSize: "9px", fontWeight: "600" }}>টমেটো</div>
                      <div style={{ fontSize: "8px", color: "#5D6D7E" }}>৳৬০/কেজি</div>
                    </div>
                  </div>
                  <button style={{ background: "#2ECC71", color: "#fff", border: "none", padding: "8px", borderRadius: "8px", fontSize: "8px", fontWeight: "600", width: "100%" }}>অর্ডার করুন</button>
                </div>
                <div style={{ display: "flex", justifyContent: "space-between", padding: "8px 12px", background: "#fff", borderRadius: "8px", margin: "8px" }}>
                  <span style={{ fontSize: "9px" }}>৩টি পণ্য</span>
                  <span style={{ fontSize: "9px", fontWeight: "700", color: "#2ECC71" }}>৳৪৫০</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Trust Bar */}
      <div className="trust-bar">
        <div className="trust-item">
          <span className="icon">🚚</span>
          <div>
            <h4>দ্রুত ডেলিভারি</h4>
            <p>৩০ মিনিটে</p>
          </div>
        </div>
        <div className="trust-item">
          <span className="icon">🥬</span>
          <div>
            <h4>১০০% তাজা</h4>
            <p>খামার থেকে</p>
          </div>
        </div>
        <div className="trust-item">
          <span className="icon">💰</span>
          <div>
            <h4>সেরা দাম</h4>
            <p>গ্যারান্টি</p>
          </div>
        </div>
        <div className="trust-item">
          <span className="icon">🔒</span>
          <div>
            <h4>নিরাপদ পেমেন্ট</h4>
            <p>বিকাশ/নগদ</p>
          </div>
        </div>
      </div>

      {/* Categories */}
      <div className="page-container">
        <div className="section-header">
          <h2>ক্যাটাগরি</h2>
          <Link href="/shop">সব দেখুন →</Link>
        </div>
        <div className="cat-grid">
          {categories.length > 0 ? categories.map((c: any) => (
            <Link key={c.id} href={`/category/${c.slug}`} className="cat-card">
              <div className="icon">{c.icon || "🛒"}</div>
              <div className="name">{c.name}</div>
            </Link>
           )) : null}
        </div>
      </div>

      {/* Featured Products */}
      <div className="page-container">
        <div className="section-header">
          <h2>বিশেষ অফার</h2>
          <Link href="/shop">সব দেখুন →</Link>
        </div>
        <div className="products-grid">
          {featured.length > 0 ? featured.map((p: any) => (
            <ProductCard key={p.id} {...p} />
          ) : (
            <div style={{ 
              gridColumn: '1/-1', 
              textAlign: 'center', 
              padding: '40px 20px',
              color: 'var(--text2)'
            }}>
              <div style={{ fontSize: '3rem', marginBottom: '12px' }}>🛒</div>
              <p className="font-bangla" style={{ fontSize: '16px' }}>
                শীঘ্রই পণ্য আসছে...
              </p>
            </div>
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
