import { EditorView } from "@codemirror/view"
import { HighlightStyle } from "@codemirror/language"
import { tags } from "@lezer/highlight"

// Tokyo Night syntax highlighting for CodeMirror 6
export const tokyoNightHighlight = HighlightStyle.define([
  { tag: tags.keyword, color: "#bb9af7" },
  { tag: tags.function(tags.variableName), color: "#7aa2f7" },
  { tag: tags.variableName, color: "#a9b1d6" },
  { tag: tags.string, color: "#9ece6a" },
  { tag: tags.number, color: "#ff9e64" },
  { tag: tags.bool, color: "#ff9e64" },
  { tag: tags.null, color: "#f7768e" },
  { tag: tags.comment, color: "#565f89", fontStyle: "italic" },
  { tag: tags.operator, color: "#89ddff" },
  { tag: tags.punctuation, color: "#89ddff" },
  { tag: tags.className, color: "#e0af68" },
  { tag: tags.definition(tags.typeName), color: "#e0af68" },
  { tag: tags.typeName, color: "#e0af68" },
  { tag: tags.constant(tags.name), color: "#ff9e64" },
  { tag: tags.regexp, color: "#b4f9f8" },
  { tag: tags.self, color: "#f7768e" }
])

// Tokyo Night editor theme for CodeMirror 6
export const tokyoNightTheme = EditorView.theme({
  "&": {
    color: "#a9b1d6",
    backgroundColor: "#1a1b26"
  },
  ".cm-content": {
    caretColor: "#bb9af7",
    fontFamily: "'JetBrains Mono', 'Fira Code', 'Courier New', monospace",
    fontSize: "14px",
    lineHeight: "1.6"
  },
  "&.cm-focused .cm-cursor": {
    borderLeftColor: "#bb9af7"
  },
  "&.cm-focused .cm-selectionBackground, ::selection": {
    backgroundColor: "#6f7bb640"
  },
  ".cm-activeLine": {
    backgroundColor: "#24283b"
  },
  ".cm-selectionMatch": {
    backgroundColor: "#6f7bb640"
  },
  ".cm-gutters": {
    backgroundColor: "#1a1b26",
    color: "#565f89",
    border: "none",
    paddingRight: "8px"
  },
  ".cm-activeLineGutter": {
    backgroundColor: "#24283b",
    color: "#a9b1d6"
  },
  ".cm-lineNumbers .cm-gutterElement": {
    padding: "0 8px 0 5px"
  }
}, { dark: true })

// Export both as named exports and a combined object
export default {
  highlight: tokyoNightHighlight,
  theme: tokyoNightTheme
}
