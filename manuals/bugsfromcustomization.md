# PicoClaw Customization Bugs & Troubleshooting

This document catalogs the various technical roadblocks, crashes, and bugs encountered while replacing the Go-based TUI with a pure Windows Batch Script (`PicoClaw_TUI.bat`) and customizing the project's directory structure. Use this as a reference to prevent or debug future integration issues.

---

## 1. Batch Script ASCII Art Crashing (Unescaped Pipes)

### What it is
Windows Batch (`.bat`) scripts process the pipe character (`|`) as a command-line pipeline operator (redirecting the output of one command into the input of another). When attempting to `echo` a large block of ASCII art (like the "PICOCLAW" logo) containing `|` characters without escaping them, the batch processor encounters a syntax error (`| was unexpected at this time.`) and instantly crashes, closing the terminal window immediately.

### How to fix it
Always escape special batch characters (like `|`, `<`, `>`, and `&`) by prefixing them with a caret (`^`). 
- **Incorrect:** `echo   / /| | | /| / /`
- **Correct:**   `echo   / /^| ^| ^| /^| / /`

### Future considerations
If you decide to change the TUI's ASCII art or add custom colored banners in the future, carefully review the art block for unescaped pipes or angle brackets.

---

## 2. Inline PowerShell Quoting & Parsing Errors

### What it is
The TUI script relies on inline PowerShell commands (`powershell -Command "..."`) to dynamically parse and edit the complex `config.json` file. Because these commands are embedded inside a standard Windows Command Prompt `for /f` loop, string escaping gets wildly complicated. Nested double quotes (e.g. `Write-Output """$var"""`) cause the batch processor to prematurely terminate strings, resulting in command syntax errors during Model Selection (`Option 1`).

### How to fix it
Avoid inline double-quote nesting entirely. Instead of attempting to parse the entire output stream in memory through `for /f`, route the PowerShell JSON parsing output to a temporary file, and then instruct the batch script to read from that file.
```bat
:: Safe approach avoiding quote-escaping hell
powershell -Command "... { Write-Output ('{0}. {1}' -f $i, $m.name) } ..." > "%TEMP%\pico_models.tmp"
for /f "delims=" %%A in (%TEMP%\pico_models.tmp) do ( ... )
```

### Future considerations
If you add more arrays or objects to `config.json` that need to be read by `.bat` scripts, always output the PowerShell queries to a temporary file (`%TEMP%`) and pipe them back in to ensure stability.

---

## 3. PowerShell Object Property Assignment Errors

### What it is
During the `Edit Model` phase, the script attempted to mutate individual properties of a nested JSON object (e.g., `$config.model_list[0].proxy = "..."`). However, if the user leaves an optional parameter blank during creation, that JSON key is entirely omitted from `config.json`. PowerShell throws a fatal `SetValueInvocationException` if you attempt to assign a value to an object property that doesn't technically exist yet.

### How to fix it
Instead of mutating existing object fields, completely rebuild the custom PSObject from scratch using the new inputs, injecting default values (like `0` for RPM) where necessary, and forcefully overwrite the array index:
```ps1
$nm = [PSCustomObject]@{model_name='New'; model='gpt-4'; proxy=''; rpm=0}
$c.model_list[$idx] = $nm
```

### Future considerations
When adding new configuration keys to `config.json` (such as specialized API hooks for Yumi), always assume the key might be missing and enforce object reconstruction in your PowerShell editors.

---

## 4. Broken Relative Paths (The `LAUNCHERS` Directory Migration)

### What it is
The interactive core of PicoClaw (`picoclaw.exe agent`) relies heavily on matching its execution context to the workspace/configuration directories. When the user manually moved `Chat_With_Pico.bat` and `TUI to add new models.bat` out of the root repo folder and into a `LAUNCHERS` subfolder, the relative paths inside the scripts broke. 
- Attempting to run `.\picoclaw.exe` from inside the `LAUNCHERS` folder failed because the executable was actually located in `LAUNCHERS\Prebuilt\picoclaw.exe`.
- The Gateway monitor output (`> gateway.log`) was being dumped in the wrong folder directory.

### How to fix it
You must explicitly declare the working directory at the very top of relocated batch scripts using the `%~dp0` variable (which resolves to the drive/path of the executing script itself). 
```bat
:: Forces the executing terminal to change directory to the repository root
cd /d "%~dp0.."
```
Secondly, absolute internal paths to the relocated executables (`.\LAUNCHERS\Prebuilt\picoclaw.exe`) must be explicitly declared.

### Future considerations
If you ever move the `Prebuilt` executable, or refactor the repository into a standalone execution package, all Batch/PowerShell `.bat` files will immediately break. You must manually audit all `cd` and `.\` execution paths.

---

## 5. Non-TTY EOF Abort (Automated Testing Bug)

### What it is
During automated backend testing of the UI scripts, `picoclaw.exe agent` instantly aborted and printed 'Goodbye!'. The Interactive CLI is programmed to constantly listen for keyboard inputs via standard input (`stdin`). When the agent is spawned in a headless, purely programmatic environment (without a physical terminal buffer attached), it instantly receives an invisible End-Of-File (EOF) signal and terminates gracefully.

### How to fix it
This is expected behavioral safety. It requires no fix. To properly verify interactive features, developers must test the `.bat` scripts natively by double-clicking them in a physical Windows environment.

## Conclusion
PicoClaw's architecture requires absolute precision when bridging native Golang parsing mechanisms with rigid Windows Batch scripting. This stable configuration protects the environment for complex agents like 37 and Yumi.
