# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin "@rails/actioncable", to: "https://cdn.jsdelivr.net/npm/@rails/actioncable@7.2.200/+esm"
pin_all_from "app/javascript/controllers", under: "controllers", preload: true
pin_all_from "app/javascript/channels", under: "channels", preload: false
pin_all_from "app/javascript/lib", under: "lib", preload: false

# CodeMirror 6 - Modern code editor
pin "codemirror", to: "https://cdn.jsdelivr.net/npm/codemirror@6.0.1/dist/index.js"
pin "@codemirror/state", to: "https://cdn.jsdelivr.net/npm/@codemirror/state@6.4.1/dist/index.js"
pin "@codemirror/view", to: "https://cdn.jsdelivr.net/npm/@codemirror/view@6.34.1/dist/index.js"
pin "@codemirror/commands", to: "https://cdn.jsdelivr.net/npm/@codemirror/commands@6.7.0/dist/index.js"
pin "@codemirror/language", to: "https://cdn.jsdelivr.net/npm/@codemirror/language@6.10.3/dist/index.js"
pin "@codemirror/lang-javascript", to: "https://cdn.jsdelivr.net/npm/@codemirror/lang-javascript@6.2.2/dist/index.js"
pin "@codemirror/theme-one-dark", to: "https://cdn.jsdelivr.net/npm/@codemirror/theme-one-dark@6.1.2/dist/index.js"
pin "@codemirror/autocomplete", to: "https://cdn.jsdelivr.net/npm/@codemirror/autocomplete@6.18.1/dist/index.js"
pin "@codemirror/lint", to: "https://cdn.jsdelivr.net/npm/@codemirror/lint@6.8.2/dist/index.js"
pin "@codemirror/search", to: "https://cdn.jsdelivr.net/npm/@codemirror/search@6.5.6/dist/index.js"
pin "@lezer/common", to: "https://cdn.jsdelivr.net/npm/@lezer/common@1.2.2/dist/index.js"
pin "@lezer/highlight", to: "https://cdn.jsdelivr.net/npm/@lezer/highlight@1.2.1/dist/index.js"
pin "@lezer/lr", to: "https://cdn.jsdelivr.net/npm/@lezer/lr@1.4.2/dist/index.js"
pin "@lezer/javascript", to: "https://cdn.jsdelivr.net/npm/@lezer/javascript@1.4.19/dist/index.js"
pin "style-mod", to: "https://cdn.jsdelivr.net/npm/style-mod@4.1.2/src/style-mod.js"
pin "w3c-keyname", to: "https://cdn.jsdelivr.net/npm/w3c-keyname@2.2.8/index.js"
pin "crelt", to: "https://cdn.jsdelivr.net/npm/crelt@1.0.6/index.js"

# CodeMirror Ruby Language Support (using legacy mode)
pin "@codemirror/legacy-modes", to: "https://cdn.jsdelivr.net/npm/@codemirror/legacy-modes@6.4.1/dist/index.js"
pin "@codemirror/legacy-modes/mode/ruby", to: "https://cdn.jsdelivr.net/npm/@codemirror/legacy-modes@6.4.1/mode/ruby.js"
