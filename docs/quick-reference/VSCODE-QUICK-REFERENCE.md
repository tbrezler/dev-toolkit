# VS Code Quick Reference (macOS)

Shortcuts and workflows for Python development on VS Code.

## Essential Keyboard Shortcuts

### Command Palette (your best friend)
```
Cmd + Shift + P          Open Command Palette (search anything)
```

### File & Navigation
```
Cmd + P                  Quick file search and open
Cmd + Shift + O          Go to symbol in file
Cmd + G                  Go to line number
Cmd + /                  Toggle comment
Cmd + B                  Toggle sidebar
Cmd + J                  Toggle terminal panel
```

### Editing
```
Cmd + X                  Cut line
Cmd + C                  Copy line (without selecting)
Cmd + D                  Select next occurrence (multi-select)
Cmd + Shift + L          Select all occurrences
Cmd + Shift + K          Delete line
Cmd + K Cmd + C          Add line comment
Cmd + K Cmd + U          Remove line comment
Option + Up/Down         Move line up/down
Shift + Option + Up/Down Duplicate line
```

### Search & Replace
```
Cmd + F                  Find
Cmd + H                  Find and Replace
Cmd + Shift + F          Find in all files
Cmd + Shift + H          Replace in all files
```

### Split Editor
```
Cmd + \                  Split editor horizontally
Cmd + K Cmd + Left/Right Switch editor panes
```

## Markdown Support

### Viewing Markdown as Formatted Text
```
Cmd + Shift + V          Open markdown preview
Cmd + K V                Open markdown preview to the side (split view)
```

**Use case:** Great for viewing README files, documentation, or markdown notes with proper formatting, headers, bold/italic text, and links rendered.

**Side-by-side workflow:**
- Open `.md` file
- Press `Cmd + K V` to see preview on the right
- Edit on left, see formatted output on right in real-time

### Markdown Editing Tips
```
Cmd + B                  Bold selected text (with extension)
Cmd + I                  Italic selected text (with extension)
Cmd + Shift + V          Paste as markdown (converts from clipboard)
```

**Navigation in markdown:**
```
Cmd + Shift + O          Jump to heading in markdown file
```

**Recommended extensions:**
- **Markdown Preview Enhanced** – Better preview with TOC, code execution
- **Markdownlint** – Catches markdown formatting issues

## Python-Specific Workflows

### Selecting & Using the Right Python Interpreter
```
Cmd + Shift + P
> Python: Select Interpreter
Choose .venv (the one with your project path)
```

**Why this matters:** VS Code needs to know which Python to use for linting, debugging, and tests.

### Running Tests from VS Code

**View the Test Explorer:**
```
Cmd + Shift + P
> Testing: Focus on Test Explorer View
```

Or click the test icon in the left sidebar (looks like a flask/beaker).

**Running tests:**
- Click the play button next to individual tests
- Click play button at top to run all tests
- Right-click a test file → "Run Tests"

**Terminal alternative (if you prefer):**
```bash
pytest
pytest tests/test_file.py
pytest tests/test_file.py::test_function_name -v
pytest --cov
```

### Debugging Python Code

**Setting a breakpoint:**
- Click left of the line number to add a red dot

**Starting the debugger:**
```
Cmd + Shift + D          Open Run & Debug
Click "Create launch.json" if it doesn't exist
Select "Python" as environment
Click the play button to start debugging
```

**During debugging:**
```
F10                      Step over (execute current line)
F11                      Step into (go inside function)
Shift + F11              Step out (exit current function)
F5 or Cmd + F5           Continue execution
Shift + F5               Stop debugging
```

**Debug workflow:**
1. Set breakpoint at the line you want to inspect
2. Run debugger (Cmd + Shift + D, then play button)
3. Execution pauses at breakpoint
4. Hover over variables to see values
5. Use F10/F11 to step through code
6. Watch pane shows variable values as you step

### Python File Structure

```
Cmd + Shift + O          Jump to function/class in file
Breadcrumb shows current location in file structure
```

## Using Your Extensions

### autoDocstring
```
Cmd + Shift + P
> Generate docstring
Generates docstring templates for functions
```

### Better Comments
Add different comment styles to organize your thinking:
```python
# ! Important alert
# ? Question or clarification
# TODO: Something to do
# * Highlight/star something
```

### Black Formatter
```
Cmd + Shift + P
> Format Document
Or: Cmd + K Cmd + F (format selection)
Runs automatically on save (configured in settings.json)
```

### REST Client
Create a `.http` or `.rest` file:
```http
GET https://api.example.com/endpoint
Authorization: Bearer YOUR_TOKEN

###

POST https://api.example.com/endpoint
Content-Type: application/json

{
  "key": "value"
}
```

Click "Send Request" above each request. Responses appear in a side panel.

### Rainbow CSV
Open a CSV file and each column gets a different color. Makes reading CSVs much easier.

### Sort Extension
```
Cmd + Shift + P
> Sort Lines
Sorts selected lines alphabetically
```

## Common Workflows

### Rename Something Throughout Your Project
```
Right-click variable/function name
> Rename Symbol
Type new name
All occurrences update
```

### Find All References
```
Right-click variable/function name
> Go to References
Shows all places it's used
```

### Quick Documentation
```
Hover over any function/variable
Tooltip shows docstring and type info
```

### Format on Save
Already configured in your `.vscode/settings.json`. Black runs automatically when you save.

### Terminal in VS Code
```
Cmd + J                  Toggle terminal
Ctrl + Grave             New terminal tab
```

The terminal automatically activates your `.venv` because it's in your settings.

### Debugging Python Code

**Setting a breakpoint:**
- Click left of the line number to add a red dot

**Conditional Breakpoints:**

Useful when debugging loops or when you only want to break on specific conditions.

1. Right-click on the line number (where you'd add a normal breakpoint)
2. Select "Add Conditional Breakpoint"
3. Enter a condition, e.g.:
   - `i == 5` (break when i equals 5)
   - `user_id == 123` (break when user_id is 123)
   - `len(items) > 10` (break when list length exceeds 10)
4. Press Enter

**Example use case:**
```python
for i in range(1000):
    process_item(i)
    # Conditional breakpoint: i == 500
    # Execution pauses only when i reaches 500, not on every iteration
```

**Conditional breakpoint expression ideas:**
```
# Check variable values
x > 100
name == "admin"
status != "complete"

# Check list/dict properties
len(items) == 0
"error" in response

# Combine conditions
i > 50 and value < 100
user_id == target_id or admin == True
```

**Editing an existing conditional breakpoint:**
- Right-click the red dot on the line number
- Select "Edit Breakpoint"
- Modify the condition

**Starting the debugger:**
```
Cmd + Shift + D          Open Run & Debug
Click "Create launch.json" if it doesn't exist
Select "Python" as environment
Click the play button to start debugging
```

**During debugging:**
```
F10                      Step over (execute current line)
F11                      Step into (go inside function)
Shift + F11              Step out (exit current function)
F5 or Cmd + F5           Continue execution
Shift + F5               Stop debugging
```

**Debug workflow:**
1. Set breakpoint (or conditional breakpoint) at the line you want to inspect
2. Run debugger (Cmd + Shift + D, then play button)
3. Execution pauses at breakpoint
4. Hover over variables to see values
5. Use F10/F11 to step through code
6. Watch pane shows variable values as you step

Conditional breakpoints save you from stepping through hundreds of iterations to find the one that matters.

## Things to Remember

- **Format on save is enabled** – Don't manually format, just save
- **Pre-commit hooks run before commit** – Fix any issues they flag before trying again
- **Linting shows errors in Problems tab** – Red squiggles = problems to fix
- **Ctrl + Grave opens a new terminal** – Useful when you need multiple terminal tabs
- **Cmd + K clears the terminal** – Cleans up after running commands
- **Command Palette is your friend** – If you forget a shortcut, Cmd + Shift + P and search
- **Cmd + K V for markdown preview** – Great for viewing documentation side-by-side with editing