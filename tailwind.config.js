/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      fontFamily: {
        'sans': ['Lato', 'system-ui', 'sans-serif'],
        'serif': ['Georgia', 'Cambria', 'Times New Roman', 'serif'],
        'mono': ['Fira Code', 'Monaco', 'Consolas', 'Liberation Mono', 'Courier New', 'monospace'],
        'display': ['Montserrat', 'system-ui', 'sans-serif']
      },
      colors: {
        tokyo: {
          bg: '#1a1b26',
          'bg-darker': '#16161e',
          fg: '#a9b1d6',
          blue: '#7aa2f7',
          purple: '#bb9af7',
          cyan: '#7dcfff',
          green: '#9ece6a',
          orange: '#ff9e64',
          red: '#f7768e'
        }
      }
    },
  },
  plugins: [],
}