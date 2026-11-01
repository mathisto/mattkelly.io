# mattkelly.io

Rails 8 portfolio site with a browser terminal emulator (ViewComponent, Stimulus, importmap, no Node build). This file is public on GitHub: write nothing private here. The site overhaul (first-person Rust/WASM world) lives in `~/projects/mattkelly-world`; this repo is the live Rails site.

Read `docs/contributing/agents-guide.md` before touching JavaScript, the terminal or importmap pins. The wiki index is `docs/README.md` (served at `/docs` in development only).

Never:
- use relative imports or `.js` extensions in importmap modules (`import x from "lib/file"`)
- importmap a UMD library (use a script tag and `window.LibraryName`)
- store state in the DOM, or update the UI before the state and position
- commit `.secrets` or credentials
- push from an agent session: this repo's only remote is GitHub, so commit locally and let Matt push
