import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        green: {
          primary: "#2ECC71",
          dark: "#27AE60",
          light: "#D5F5E3",
          deep: "#1A4731",
        },
        orange: {
          primary: "#FF6B35",
          light: "#FF8C61",
        },
      },
      fontFamily: {
        bangla: ["Hind Siliguri", "sans-serif"],
        tiro: ["Tiro Bangla", "serif"],
      },
    },
  },
  plugins: [],
};

export default config;
