export default async function ls(args, context) {
  const { fs, cwd } = context
  const sh = fs.promises

  let showHidden = false
  let longFormat = false
  let targetPath = cwd

  // Parse flags
  for (const arg of args) {
    if (arg.startsWith("-")) {
      if (arg.includes("a")) showHidden = true
      if (arg.includes("l")) longFormat = true
    } else {
      targetPath = arg.startsWith("/") ? arg : `${cwd}/${arg}`.replace(/\/+/g, "/")
    }
  }

  try {
    const files = await sh.readdir(targetPath)
    let filtered = showHidden ? files : files.filter(f => !f.startsWith("."))

    if (filtered.length === 0) {
      return ""
    }

    if (!longFormat) {
      return filtered.join("  ")
    }

    // Long format: fetch stats for each file
    const details = await Promise.all(
      filtered.map(async (file) => {
        try {
          const fullPath = `${targetPath}/${file}`.replace(/\/+/g, "/")
          const stats = await sh.stat(fullPath)
          const isDir = stats.type === "DIRECTORY"
          const isExec = !isDir && (stats.mode & 0o111) !== 0
          
          let permissions = isDir ? "d" : "-"
          permissions += (stats.mode & 0o400) ? "r" : "-"
          permissions += (stats.mode & 0o200) ? "w" : "-"
          permissions += (stats.mode & 0o100) ? "x" : "-"
          permissions += (stats.mode & 0o040) ? "r" : "-"
          permissions += (stats.mode & 0o020) ? "w" : "-"
          permissions += (stats.mode & 0o010) ? "x" : "-"
          permissions += (stats.mode & 0o004) ? "r" : "-"
          permissions += (stats.mode & 0o002) ? "w" : "-"
          permissions += (stats.mode & 0o001) ? "x" : "-"

          const size = String(stats.size).padStart(8)
          const name = isDir ? `<span style="color: #7aa2f7">${file}</span>` 
                      : isExec ? `<span style="color: #9ece6a">${file}</span>`
                      : file

          return `${permissions} ${size}  ${name}`
        } catch (e) {
          return `?????????? ????????  ${file}`
        }
      })
    )

    return details.join("\n")
  } catch (error) {
    if (error.code === "ENOENT") {
      throw new Error(`ls: cannot access '${targetPath}': No such file or directory`)
    }
    if (error.code === "ENOTDIR") {
      throw new Error(`ls: cannot access '${targetPath}': Not a directory`)
    }
    throw error
  }
}
