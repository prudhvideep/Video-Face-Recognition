/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./src/**/*.{html,js,ts,jsx,tsx}"],
  theme: {
    extend: {
      width : {
        "9/10" : "90%",
        "8/10" : "80%",
        "7/10" : "70%"
      },
      height : {
        "9/10" : "90%",
        "110" : "28rem"
      }
    },
  },
  plugins: [],
};
