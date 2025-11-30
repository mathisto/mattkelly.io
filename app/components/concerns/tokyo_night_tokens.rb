module TokyoNightTokens
  extend ActiveSupport::Concern

  COLORS = {
    blue: "#7aa2f7",
    purple: "#bb9af7",
    cyan: "#7dcfff",
    green: "#9ece6a",
    orange: "#ff9e64",
    red: "#f7768e",
    yellow: "#e0af68",
    magenta: "#9d7cd8",

    fg: "#a9b1d6",
    fg_dark: "#787c99",
    bg: "#1a1b26",
    bg_dark: "#16161e",
    bg_float: "#1f2335",
    comment: "#565f89",
    border: "#29293f",

    success: "#9ece6a",
    warning: "#e0af68",
    error: "#f7768e",
    info: "#7dcfff"
  }.freeze

  SHADOWS = {
    sm: "0 1px 2px 0 rgba(0, 0, 0, 0.05)",
    md: "0 4px 6px -1px rgba(0, 0, 0, 0.1)",
    lg: "0 10px 15px -3px rgba(0, 0, 0, 0.1)",
    glow_blue: "0 0 20px rgba(122, 162, 247, 0.3)",
    glow_purple: "0 0 20px rgba(187, 154, 247, 0.3)"
  }.freeze

  GRADIENTS = {
    rainbow: "linear-gradient(45deg, #f7768e, #ff9e64, #9ece6a, #7aa2f7, #bb9af7)",
    border: "linear-gradient(90deg, #7aa2f7 0%, #bb9af7 16.67%, #7dcfff 33.33%, #9ece6a 50%, #ff9e64 66.67%, #f7768e 83.33%, #9d7cd8 91.67%, #7aa2f7 100%)"
  }.freeze
end
