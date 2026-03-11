---
name: doc-summarize
description: "Extract text from Office documents (.docx, .xlsx, .pptx, .pdf, .csv) and summarize or analyze their content. Use when the user asks to read, summarize, or extract information from a document file. Can output to the screen or to a specific file."
---

# Document Summarizer (doc-summarize)

This skill allows you to read binary document files (Word, Excel, PowerPoint, PDF) by extracting their raw text so you can read, summarize, and analyze them.

## When to use

Use this skill immediately when the user provides a file path and asks to:
- "Summarize this document"
- "What does this Excel sheet say?"
- "Read this PowerPoint"
- "Analyze this PDF"

## 1. Extract the Text

Use the bundled `extract_text.py` script to pull the text out of the document.

Use your `exec` tool to run the python script:
```bash
python "workspace/skills/doc-summarize/scripts/extract_text.py" "path/to/the/document.docx"
```

*Note: The script automatically handles .docx, .xlsx, .pptx, .pdf, and .csv files. It will automatically cap the output for massive spreadsheets to prevent you from being overwhelmed with too much data.*

## 2. Summarize and Output

After running the script, the text will be returned to you in stdout.

1. **Analyze:** Read the extracted output and use your intelligence to build a cohesive summary or answer the user's specific questions about the document.
2. **Output Logic:**
   - **If the user specified an output file:** Determine the final summary/analysis text, then use your `write_file` tool to save it to the path requested by the user. Do not print out the full summary in the chat, just confirm it was written.
   - **If the user did NOT specify an output file:** Simply print the summary politely out into the chat.
   
## Example Interaction

**User:** "Summarize C:\Data\Q3_Report.pptx and write the results to C:\Output\summary.txt"
**You:** (Run `exec` on extract script) -> (Read stdout) -> (Run `write_file` to save your summary to summary.txt) -> "I parsed the presentation and wrote a summary to C:\Output\summary.txt!"
