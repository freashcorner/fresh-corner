/** @type {import('tailwindcss').Config} */
export default {
  content: ["./index.html", "./src/**/*.{js,ts,jsx,tsx}"],
  theme: {
    extend: {
      colors: {
        "yaru-orange": "#E95420",
        "yaru-orange-light": "#F47956",
        "g1": "#26A269",
        "g2": "#1C7A4F",
        "bg": "#1C1C1C",
        "bg2": "#2D2D2D",
        "bg3": "#3C3C3C",
        "card": "#2D2D2D",
      },
      fontFamily: {
        ubuntu: ["Ubuntu", "sans-serif"],
        bangla: ["Hind Siliguri", "sans-serif"],
      },
    },
  },
  plugins: [],
};
