function linkify(text) {
  // Process line by line
  const lines = text.split('\n')
  
  const processedLines = lines.map(line => {
    if (!line.trim()) return '' // Skip empty lines
    
    // Match entire patterns with labels
    // Email with label: "📧 Email: email@example.com"
    const emailLineRegex = /(.*?)\s*([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)/i
    // URL with label: "🐙 GitHub: https://..."
    const urlLineRegex = /(.*?)\s*(https?:\/\/[^\s]+)/i
    // File path with label: "📄 CV: /CV.pdf"
    const fileLineRegex = /(.*?)\s*(\/[A-Za-z0-9._/-]+\.(pdf|docx|txt|md|html|jpg|png|gif))/i
    
    // Check which pattern matches and replace accordingly
    let match
    
    if ((match = line.match(emailLineRegex))) {
      const label = match[1]
      const email = match[2]
      return `<div style="white-space: nowrap; margin-bottom: 0.25rem;">${label} <a href="mailto:${email}" style="color: #7aa2f7; text-decoration: underline; cursor: pointer;">${email}</a></div>`
    } else if ((match = line.match(fileLineRegex))) {
      const label = match[1]
      const file = match[2]
      return `<div style="white-space: nowrap; margin-bottom: 0.25rem;">${label} <a href="${file}" target="_blank" rel="noopener noreferrer" style="color: #7aa2f7; text-decoration: underline; cursor: pointer;">${file}</a></div>`
    } else if ((match = line.match(urlLineRegex))) {
      const label = match[1]
      const url = match[2]
      return `<div style="white-space: nowrap; margin-bottom: 0.25rem;">${label} <a href="${url}" target="_blank" rel="noopener noreferrer" style="color: #7aa2f7; text-decoration: underline; cursor: pointer;">${url}</a></div>`
    }
    
    return line
  })
  
  // Join without newlines since we're using divs now
  return processedLines.join('')
}

export default async function cat(args, context) {
  const { fs, cwd } = context
  const sh = fs.promises

  if (args.length === 0) {
    throw new Error("cat: missing file operand")
  }

  const results = []

  for (const file of args) {
    const filePath = file.startsWith("/") ? file : `${cwd}/${file}`.replace(/\/+/g, "/")

    try {
      const stats = await sh.stat(filePath)

      if (stats.type === "DIRECTORY") {
        results.push(`cat: ${file}: Is a directory`)
        continue
      }

      const content = await sh.readFile(filePath, "utf8")
      // Linkify URLs and emails in the content
      const linkedContent = linkify(content)
      results.push(linkedContent)
    } catch (error) {
      if (error.code === "ENOENT") {
        results.push(`cat: ${file}: No such file or directory`)
      } else {
        results.push(`cat: ${file}: ${error.message}`)
      }
    }
  }

  return results.join("\n")
}
