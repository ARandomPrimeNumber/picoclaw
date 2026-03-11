---
name: remember
description: "Save facts, preferences, and important notes to long-term memory. Use when the user asks to 'remember this', 'take note of', or 'save this fact'."
---

# Long-Term Memory (remember)

This skill allows you to save persistent information about the user so you don't forget it across different conversations. It achieves this by directly modifying the `workspace/memory/MEMORY.md` file.

## Why this works so fast

Because `MEMORY.md` is automatically injected into your system prompt on every turn, **you already know what is inside of it!** 

In most cases, you do *not* need to read the file first. You can just recreate the file's contents with the new fact intelligently appended to the correct section, and use your `write_file` tool to save it.

## The Rules of MEMORY.md

When you rewrite `workspace/memory/MEMORY.md`, you **MUST** strictly follow this exact markdown structure. Do not remove or change these four headers:

```markdown
# Long-term Memory

This file stores important information that should persist across sessions.

## User Information

(Important facts about user)

## Preferences

(User preferences learned over time)

## Important Notes

(Things to remember)

## Configuration

- Model preferences
- Channel settings
- Skills enabled
```

## How to execute this skill

1. **Analyze the user's request:** Determine what fact they want you to remember.
2. **Classify the fact:** Does it belong under `## User Information` (e.g., "I am a data engineer"), `## Preferences` (e.g., "I like Python"), `## Important Notes` (e.g., "Remember to develop Yumi persona later"), or `## Configuration`?
3. **Draft the new file:** Take the *current* contents of your long-term memory (which you can see in your system prompt right now), and add the new fact as a `- bullet point` under the correct exact header.
4. **Save it:** You MUST use the exact `write_file` tool to overwrite `workspace/memory/MEMORY.md` with the newly drafted content in its entirety. DO NOT just say you did it; you must physically execute the `write_file` tool with the `path` and `content` arguments. DO NOT use the `append_file` tool, as appending a new header to the bottom of the file ruins the strict markdown formatting order.
5. **Confirm:** Tell the user exactly what you saved and to which section!

### Example Tool Execution

You must invoke the tool exactly like this:
Tool name: `write_file`
Arguments:
```json
{
  "path": "workspace/memory/MEMORY.md",
  "content": "# Long-term Memory\n\nThis file stores important information that should persist across sessions.\n\n## User Information\n\n(Important facts about user)\n- I am a data engineer\n\n## Preferences\n\n(User preferences learned over time)\n\n## Important Notes\n\n(Things to remember)\n\n## Configuration\n\n- Model preferences\n- Channel settings\n- Skills enabled"
}
```
