# Cursor Editor Git Commit Message Rules

## Format Structure

- **Subject Line**: 
  - Capitalized
  - 50 characters or less (aim for 30-40)
  - Written in imperative mood: "Fix bug" not "Fixed bug" or "Fixes bug"
  - No period at the end
  - Followed by a blank line if a body exists
  - Should complete this sentence: "If applied, this commit will..."

- **Body**:
  - Wrap text at 72 characters
  - Separate paragraphs with blank lines
  - Use detailed explanatory text to describe WHY the change was made
  - Focus on motivation and impact rather than implementation details
  - Additional paragraphs come after blank lines
  - NEVER use multiple -m flags for multiline messages
  - ALWAYS use git commit -e or your configured editor for multiline commits

- **Bullet Points** (optional):
  - Preceded by blank lines
  - Use hyphens or asterisks followed by a single space
  - Separate each bullet point with a blank line
  - Use hanging indents for multi-line bullet points (indent 2 spaces)
  - Great for technical details and testing notes

## Creating Multiline Messages

For commits that require detailed explanations:

1. Stage your changes: `git add .`
2. Open editor: `git commit` (or `git commit -e`)
3. Write your message in the editor following the format:
   ```
   Subject line

   Detailed explanation of why this change is being made.
   Wrap at 72 characters. Use blank lines between paragraphs.

   - Bullet points if needed
   - More details here
   ```
4. Save and close the editor

DO NOT use multiple -m flags (e.g., `git commit -m "subject" -m "body"`).
This creates malformed commit messages and breaks proper formatting. 