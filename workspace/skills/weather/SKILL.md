---
name: weather
description: Get current weather and forecasts (no API key required).
homepage: https://wttr.in/:help
metadata: {"nanobot":{"emoji":"🌤️","requires":{"bins":["curl"]}}}
---

# Weather

Two free services, no API keys needed.

## wttr.in (primary)

Quick single line:
Use the `web_fetch` tool to fetch: `https://wttr.in/London?format=3`

Compact format:
Use the `web_fetch` tool to fetch: `https://wttr.in/London?format=%l:+%c+%t+%h+%w`

Full forecast:
Use the `web_fetch` tool to fetch: `https://wttr.in/London?T`

Format codes: `%c` condition · `%t` temp · `%h` humidity · `%w` wind · `%l` location · `%m` moon

Tips:
- URL-encode spaces: `https://wttr.in/New+York`
- Airport codes: `https://wttr.in/JFK`
- Units: `?m` (metric) `?u` (USCS)
- Today only: `?1` · Current only: `?0`

## Open-Meteo (fallback, JSON)

Free, no key, good for programmatic use:
Use the `web_fetch` tool to fetch: `https://api.open-meteo.com/v1/forecast?latitude=51.5&longitude=-0.12&current_weather=true`

Find coordinates for a city using `web_search_duckduckgo`, then query. Returns JSON with temp, windspeed, weathercode.

Docs: https://open-meteo.com/en/docs
