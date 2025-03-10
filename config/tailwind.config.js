const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './app/views/**/*.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  darkMode: 'class',
  theme: {
    extend: {
      fontFamily: {
        sans: ['Lato', ...defaultTheme.fontFamily.sans],
        heading: ['Montserrat', ...defaultTheme.fontFamily.sans],
        mono: ['Fira Code', ...defaultTheme.fontFamily.mono],
      },
      colors: {
        // Tokyo Night theme colors
        'tokyo': {
          // Light theme
          'light': {
            'bg': '#d5d6db',
            'fg': '#343b58',
            'selection': '#c0c0c0',
            'comment': '#565a6e',
            'red': '#8c4351',
            'orange': '#965027',
            'yellow': '#8f5e15',
            'green': '#33635c',
            'cyan': '#0f4b6e',
            'blue': '#34548a',
            'purple': '#5a4a78',
          },
          // Dark theme
          'dark': {
            'bg': '#1a1b26',
            'fg': '#a9b1d6',
            'selection': '#28344a',
            'comment': '#565f89',
            'red': '#f7768e',
            'orange': '#ff9e64',
            'yellow': '#e0af68',
            'green': '#9ece6a',
            'cyan': '#7dcfff',
            'blue': '#7aa2f7',
            'purple': '#bb9af7',
          }
        }
      },
      typography: theme => ({
        DEFAULT: {
          css: {
            color: theme('colors.tokyo.light.fg'),
            a: {
              color: theme('colors.tokyo.light.blue'),
              '&:hover': {
                color: theme('colors.tokyo.light.cyan'),
              },
            },
            'h1, h2, h3, h4, h5, h6': {
              color: theme('colors.tokyo.light.fg'),
            },
            code: {
              color: theme('colors.tokyo.light.purple'),
            },
            pre: {
              backgroundColor: theme('colors.tokyo.light.selection'),
            },
          },
        },
        dark: {
          css: {
            color: theme('colors.tokyo.dark.fg'),
            a: {
              color: theme('colors.tokyo.dark.blue'),
              '&:hover': {
                color: theme('colors.tokyo.dark.cyan'),
              },
            },
            'h1, h2, h3, h4, h5, h6': {
              color: theme('colors.tokyo.dark.fg'),
            },
            code: {
              color: theme('colors.tokyo.dark.purple'),
            },
            pre: {
              backgroundColor: theme('colors.tokyo.dark.selection'),
            },
          },
        },
      }),
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
  ],
} 