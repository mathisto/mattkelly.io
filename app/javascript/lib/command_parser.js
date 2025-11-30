export class CommandParser {
  constructor() {
    this.commands = new Map()
  }

  register(name, handler) {
    this.commands.set(name, handler)
  }

  parse(input) {
    const trimmed = input.trim()
    if (!trimmed) return { command: null, args: [] }

    const parts = this.splitArgs(trimmed)
    const command = parts[0]
    const args = parts.slice(1)

    return { command, args, raw: trimmed }
  }

  splitArgs(str) {
    const args = []
    let current = ""
    let inQuotes = false
    let quoteChar = null

    for (let i = 0; i < str.length; i++) {
      const char = str[i]
      const nextChar = str[i + 1]

      if ((char === '"' || char === "'") && !inQuotes) {
        inQuotes = true
        quoteChar = char
      } else if (char === quoteChar && inQuotes) {
        inQuotes = false
        quoteChar = null
      } else if (char === " " && !inQuotes) {
        if (current) {
          args.push(current)
          current = ""
        }
      } else {
        current += char
      }
    }

    if (current) args.push(current)
    return args
  }

  async execute(input, context) {
    const { command, args, raw } = this.parse(input)

    if (!command) {
      return { output: "", error: null }
    }

    const handler = this.commands.get(command)
    
    if (!handler) {
      return {
        output: "",
        error: `command not found: ${command}`
      }
    }

    try {
      const output = await handler(args, context)
      return { output, error: null }
    } catch (error) {
      return {
        output: "",
        error: error.message || String(error)
      }
    }
  }

  getCommands() {
    return Array.from(this.commands.keys())
  }
}

export default new CommandParser()
