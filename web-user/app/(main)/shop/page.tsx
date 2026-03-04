"use client";
import { useState } from "react";
import { useProducts, useCategories } from "@/hooks/useProducts";
import ProductCard from "@/components/product/ProductCard";
import { Search } from "lucide-react";

export default function ShopPage() {
  const [activeCategory, setActiveCategory] = useState("all");
  const [searchQuery, setSearchQuery] = useState("");

  const { products, loading: productsLoading } = useProducts();
  const { categories, loading: catsLoading } = useCategories();

  const filtered = products.filter((p) => {
    const matchCat = activeCategory === "all" || p.categoryId === activeCategory;
    const matchSearch = p.name.toLowerCase().includes(searchQuery.toLowerCase());
    return matchCat && matchSearch;
  });

  return (
    <div className="shop-layout">
      {/* Sidebar */}
      <aside className="shop-sidebar">
        <div className="sidebar-section">
          <h3 className="font-bangla">ক্যাটাগরি</h3>
          <button
            className={`sidebar-item font-bangla ${activeCategory === "all" ? "active" : ""}`}
            onClick={() => setActiveCategory("all")}
          >
            🛒 সব পণ্য
            <span className="count-badge">{products.length}</span>
          </button>
          {categories.map((c) => {
            const count = products.filter((p) => p.categoryId === c.id).length;
            return (
              <button
                key={c.id}
                className={`sidebar-item font-bangla ${activeCategory === c.id ? "active" : ""}`}
                onClick={() => setActiveCategory(c.id)}
              >
                {c.icon || "📦"} {c.name}
                <span className="count-badge">{count}</span>
              </button>
            );
          })}
        </div>
      </aside>

      {/* Main */}
      <main>
        {/* Search */}
        <div className="search-bar">
          <Search size={18} style={{ color: "var(--text3)", flexShrink: 0 }} />
          <input
            type="text"
            placeholder="পণ্য খুঁজুন..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="font-bangla"
          />
        </div>

        {/* Mobile category chips */}
        <div style={{ display: "flex", gap: "0.5rem", overflowX: "auto", paddingBottom: "1rem", marginBottom: "1rem" }}>
          <button
            className={`order-tab font-bangla ${activeCategory === "all" ? "active" : ""}`}
            onClick={() => setActiveCategory("all")}
            style={{ whiteSpace: "nowrap" }}
          >সব</button>
          {categories.map((c) => (
            <button
              key={c.id}
              className={`order-tab font-bangla ${activeCategory === c.id ? "active" : ""}`}
              onClick={() => setActiveCategory(c.id)}
              style={{ whiteSpace: "nowrap" }}
            >
              {c.icon} {c.name}
            </button>
          ))}
        </div>

        {/* Header */}
        <div className="section-header">
          <h2 className="font-bangla">
            {activeCategory === "all" ? "সব পণ্য" : categories.find((c) => c.id === activeCategory)?.name}
            <span style={{ fontSize: "0.9rem", fontWeight: 400, color: "var(--text2)", marginLeft: "0.5rem" }}>
              ({filtered.length}টি)
            </span>
          </h2>
        </div>

        {productsLoading ? (
          <div style={{ color: "var(--text2)", textAlign: "center", padding: "3rem" }} className="font-bangla">
            লোড হচ্ছে...
          </div>
        ) : filtered.length === 0 ? (
          <div className="empty-state">
            <div className="icon">🔍</div>
            <p className="font-bangla">কোনো পণ্য পাওয়া যায়নি</p>
          </div>
        ) : (
          <div className="products-grid">
            {filtered.map((p) => <ProductCard key={p.id} {...p} />)}
          </div>
        )}
      </main>
    </div>
  );
}
