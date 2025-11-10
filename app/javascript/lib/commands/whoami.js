export default async function whoami(args, context) {
  const { fs } = context
  const sh = fs.promises

  try {
    const script = await sh.readFile("/whoami", "utf8")
    
    // Extract the ASCII art from the heredoc
    const match = script.match(/cat << 'EOF'\n([\s\S]*?)\nEOF/)
    if (match) {
      return `<span style="color: #bb9af7;">${match[1]}</span>`
    }
    
    return script
  } catch (error) {
    throw new Error("whoami: command failed")
  }
}
