export default async function help(args, context) {
  return `<span style="color: #7aa2f7; font-weight: bold;">Available Commands:</span>

<span style="color: #9ece6a;">File System:</span>
  ls [-la] [path]     List directory contents
  cat <file>          Display file contents
  cd <path>           Change directory
  pwd                 Print working directory
  mkdir <dir>         Create directory
  touch <file>        Create empty file
  rm <file>           Remove file
  cp <src> <dst>      Copy file
  mv <src> <dst>      Move/rename file

<span style="color: #9ece6a;">Information:</span>
  whoami              Display ASCII art name
  help                Show this help message
  history             Show command history
  man <command>       Show manual page

<span style="color: #9ece6a;">Utilities:</span>
  clear               Clear terminal output
  echo <text>         Print text to output

<span style="color: #bb9af7;">Tips:</span>
  - Use <span style="color: #e0af68;">Tab</span> to autocomplete files and commands
  - Use <span style="color: #e0af68;">↑/↓</span> arrow keys to navigate command history
  - Try <span style="color: #e0af68;">ls -la</span> to see hidden files
  - Explore the <span style="color: #e0af68;">.secrets/</span> directory for easter eggs
`
}
