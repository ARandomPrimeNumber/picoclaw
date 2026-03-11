# Available Skills (Claws)

This document describes all the skills (Claws) currently available to the PicoClaw agent in the workspace. These include both prebuilt skills and custom-built skills.

## Custom-Built Skills

### 1. `doc-summarize`
**Description:** Extract text from Office documents (.docx, .xlsx, .pptx, .pdf, .csv) and summarize or analyze their content.
**Use case:** Use when you need to read, summarize, or extract information from a document file. Can output to the screen or to a specific file.

### 2. `remember`
**Description:** Save facts, preferences, and important notes to long-term memory.
**Use case:** Use when you need to 'remember this', 'take note of', or 'save this fact'. It natively directly modifies the `MEMORY.md` file to preserve information across sessions.

## Prebuilt Skills

### 3. `github`
**Description:** Interact with GitHub using the `gh` CLI.
**Use case:** Use `gh issue`, `gh pr`, `gh run`, and `gh api` to manage and review issues, Pull Requests, CI runs, and perform advanced queries.

### 4. `hardware`
**Description:** Read and control I2C and SPI peripherals on Sipeed boards (LicheeRV Nano, MaixCAM, NanoKVM).
**Use case:** Use when needing to interface directly with hardware sensors or displays using the `i2c` and `spi` tools.

### 5. `skill-creator`
**Description:** Create or update AgentSkills based on best practices.
**Use case:** Use when designing, structuring, or packaging new skills with scripts, references, and assets. Includes initialization and packaging scripts.

### 6. `summarize`
**Description:** Summarize or extract text/transcripts from URLs, podcasts, and local files.
**Use case:** A fast CLI fallback for operations like “transcribe this YouTube/video” or “summarize this URL/article”. 

### 7. `tmux`
**Description:** Remote-control tmux sessions for interactive CLIs by sending keystrokes and scraping pane output.
**Use case:** Use when you need an interactive TTY, or to orchestrate multiple long-running coding agents in parallel.

### 8. `weather`
**Description:** Get current weather and forecasts for a location.
**Use case:** Utilizes `wttr.in` and `open-meteo.com` to fetch the forecast (no API keys required).
