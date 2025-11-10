export default async function cd(args, context) {
  const { fs, cwd, setCwd, prevDir, setPrevDir } = context
  const sh = fs.promises

  let targetPath

  if (args.length === 0 || args[0] === "~") {
    targetPath = "/"
  } else if (args[0] === "-") {
    if (!prevDir) {
      throw new Error("cd: OLDPWD not set")
    }
    targetPath = prevDir
    console.log(targetPath) // Print directory like bash does
  } else {
    targetPath = args[0]
  }

  // Resolve path
  if (!targetPath.startsWith("/")) {
    targetPath = `${cwd}/${targetPath}`.replace(/\/+/g, "/")
  }

  // Normalize path (handle .. and .)
  const parts = targetPath.split("/").filter(p => p && p !== ".")
  const normalized = []
  
  for (const part of parts) {
    if (part === "..") {
      normalized.pop()
    } else {
      normalized.push(part)
    }
  }

  const finalPath = "/" + normalized.join("/")

  // Check if directory exists
  try {
    const stats = await sh.stat(finalPath)
    if (stats.type !== "DIRECTORY") {
      throw new Error(`cd: ${args[0]}: Not a directory`)
    }
  } catch (error) {
    if (error.code === "ENOENT") {
      throw new Error(`cd: ${args[0]}: No such file or directory`)
    }
    throw error
  }

  // Update paths
  setPrevDir(cwd)
  setCwd(finalPath)

  return "" // cd produces no output on success
}
