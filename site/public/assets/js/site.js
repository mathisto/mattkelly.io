(() => {
  "use strict"

  const root = document.documentElement
  const menuButton = document.querySelector(".nav-toggle")
  const menuPanel = document.querySelector("#nav-panel")

  root.classList.add("js")

  if (menuButton && menuPanel) {
    menuButton.hidden = false
    menuPanel.hidden = window.matchMedia("(max-width: 52rem)").matches

    menuButton.addEventListener("click", () => {
      const isOpen = menuButton.getAttribute("aria-expanded") === "true"
      menuButton.setAttribute("aria-expanded", String(!isOpen))
      menuPanel.hidden = isOpen
    })

    window.matchMedia("(min-width: 52.001rem)").addEventListener("change", (event) => {
      menuPanel.hidden = !event.matches
      menuButton.setAttribute("aria-expanded", "false")
    })
  }

  const normalizedPath = window.location.pathname.replace(/index\.html$/, "")
  let currentRouteFound = false
  document.querySelectorAll(".nav-panel a").forEach((link) => {
    const linkPath = new URL(link.href, window.location.origin).pathname
    const isCurrent = !currentRouteFound && linkPath === normalizedPath && link.origin === window.location.origin

    if (isCurrent) {
      link.setAttribute("aria-current", "page")
      currentRouteFound = true
    }
  })

  const form = document.querySelector("[data-command-form]")
  const input = document.querySelector("[data-command-input]")
  const output = document.querySelector("[data-command-output]")

  if (!form || !input || !output) return

  const routes = {
    work: "/work/",
    lab: "/lab/",
    writing: "/writing/",
    about: "/about/",
    now: "/now/",
    history: "/site-history/",
    provenance: "/provenance/",
    proof: "/references/",
    references: "/references/",
    source: "https://github.com/mathisto/mattkelly.io",
    resume: "/resume/"
  }

  form.addEventListener("submit", (event) => {
    event.preventDefault()

    const command = input.value.trim().toLowerCase()

    if (command === "help" || command === "routes" || command === "") {
      output.textContent = "Commands: work, lab, writing, about, resume, references, now, provenance, history, source"
      return
    }

    if (!Object.hasOwn(routes, command)) {
      output.textContent = `Unknown command: ${command}. Run help for the route list.`
      return
    }

    output.textContent = `Opening ${command}...`
    window.location.assign(routes[command])
  })
})()
