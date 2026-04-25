# Ruff Lint Rules Reference

A practical guide to ruff's lint rule categories, organized by how essential they are to a typical Python project.

---

## Tier 1: Essential / Minimal

These rules catch real bugs, prevent common mistakes, and have an extremely low false-positive rate. Every Python project benefits from them.

```toml
[tool.ruff.lint]
select = ["F", "E", "W", "B", "BLE", "I", "UP", "T10", "A", "RUF"]
```

---

### `F` — Pyflakes

The single most important rule set. Pyflakes performs static analysis to catch logical errors without enforcing style opinions.

**What it catches:**

- Undefined variable and function names
- Unused imports and variables
- Redefined unused functions and classes
- `import *` in non-`__init__` files
- Duplicate keys in dictionaries
- Assertions on tuples (which are always truthy)
- Invalid `print` and `format` string syntax

**Example catches:**

```python
import os          # F401: imported but unused

def greet(name):
    return f"Hello, {namee}"  # F821: undefined name 'namee'

data = {"a": 1, "a": 2}      # F601: duplicate key in dict

assert (False, "this is a bug")  # F631: assert on non-empty tuple (always True)
```

**Why it's essential:** These are not style preferences. These are bugs. If you enable nothing else, enable `F`.

---

### `E` — pycodestyle (Errors)

Enforces the baseline formatting conventions from [PEP 8](https://peps.python.org/pep-0008/). These are the rules the Python community broadly agrees on.

**What it catches:**

- Indentation errors (wrong level, mixed tabs/spaces)
- Whitespace issues (trailing whitespace, missing whitespace around operators)
- Incorrect blank line counts between top-level definitions
- Line-too-long violations (if configured)
- Syntax errors in Python files

**Example catches:**

```python
x=1+2          # E225: missing whitespace around operator
if True:
  pass         # E111: indentation is not a multiple of four
               # (with 2-space indent when 4 is expected)

class Foo:
    pass
class Bar:     # E302: expected 2 blank lines before class definition
    pass
```

**Why it's essential:** These are universally accepted conventions. Inconsistent formatting makes code harder to read and review.

---

### `W` — pycodestyle (Warnings)

The lighter companion to `E`. Covers minor stylistic warnings that are still broadly agreed upon.

**What it catches:**

- Trailing whitespace on lines
- Blank lines at end of file
- Deprecated syntax or features
- Whitespace before or after certain tokens

**Example catches:**

```python
x = 1     ↵    # W291: trailing whitespace
               # W292: no newline at end of file
```

**Why it's essential:** Extremely low noise. These are trivially auto-fixable and eliminate meaningless diffs in pull requests.

---

### `B` — flake8-bugbear

Catches common Python bugs and design problems that are technically valid syntax but almost always wrong.

**What it catches:**

- Mutable default arguments (`def foo(items=[])`)
- Using `strip()` with multi-character strings (common misunderstanding)
- `except Exception()` instead of `except Exception`
- Reusing loop variables in closures
- `setattr` / `getattr` with constant strings
- Star-arg unpacking after keyword arguments
- Empty bodies using `...` vs `pass` inconsistently

**Example catches:**

```python
def append_to(item, target=[]):   # B006: mutable default argument
    target.append(item)
    return target

value.strip("abc")  # B005: strips individual chars {'a','b','c'}, not "abc"

try:
    risky()
except TypeError():               # B025: except with parentheses (catches instance, not class)
    pass

funcs = [lambda: i for i in range(5)]  # B023: loop variable 'i' captured in closure
```

**Why it's essential:** These are some of the most common Python footguns. Every experienced developer has been bitten by at least one of these.

---

### `BLE` — flake8-blind-except

Prevents bare `except:` clauses and catching `BaseException` without re-raising.

**What it catches:**

- `except:` with no exception type
- `except BaseException:` without a `raise`

**Example catches:**

```python
try:
    do_something()
except:                    # BLE001: blind except
    pass

try:
    do_something()
except BaseException:      # BLE001: catching BaseException
    log("failed")          # swallows KeyboardInterrupt, SystemExit, etc.
```

**Why it's essential:** Bare `except` swallows `KeyboardInterrupt`, `SystemExit`, and `GeneratorExit`. This makes programs impossible to kill gracefully and hides real errors.

---

### `I` — isort

Sorts and organizes import statements into a consistent order.

**What it enforces:**

- Standard library → third-party → local imports (in sections)
- Alphabetical ordering within sections
- Consistent use of blank lines between import groups
- No duplicate imports

**Example fix:**

```python
# Before
from pathlib import Path
import sys
import requests
from myproject import utils
import os

# After (auto-fixed)
import os
import sys
from pathlib import Path

import requests

from myproject import utils
```

**Why it's essential:** Import ordering is a solved problem. Let the tool handle it. This eliminates an entire class of merge conflicts and code review nitpicks for zero effort.

---

### `UP` — pyupgrade

Identifies deprecated Python syntax and suggests modern equivalents based on your target Python version.

**What it catches:**

- Old-style string formatting (`%s`, `.format()` → f-strings)
- `typing.Optional[X]` → `X | None` (Python 3.10+)
- `typing.List[X]` → `list[X]` (Python 3.9+)
- `super(ClassName, self)` → `super()`
- UTF-8 encoding declarations (unnecessary in Python 3)
- Old-style classes and `__metaclass__`
- `six` compatibility wrappers (if you've dropped Python 2)

**Example catches:**

```python
from typing import List, Optional

def greet(names: List[str], title: Optional[str] = None):    # UP006, UP007
    return "Hello, {}".format(names[0])                       # UP032

class MyClass(object):             # UP004: unnecessary `object` base class
    def method(self):
        super(MyClass, self).method()  # UP008: use `super()` instead
```

**Why it's essential:** Keeps your codebase modern. As Python evolves, older patterns become confusing to newcomers and inconsistent with stdlib documentation.

---

### `T10` — flake8-debugger

Catches leftover debugger statements.

**What it catches:**

- `breakpoint()`
- `import pdb; pdb.set_trace()`
- `import ipdb; ipdb.set_trace()`
- `import pudb` and similar debugger imports

**Example catches:**

```python
def process(data):
    breakpoint()           # T100: debugger statement found
    import pdb; pdb.set_trace()  # T100: debugger import and call
    return transform(data)
```

**Why it's essential:** Debugger statements in production cause applications to hang indefinitely waiting for input. This is a one-line rule that prevents outages.

---

### `A` — flake8-builtins

Prevents shadowing Python's built-in names.

**What it catches:**

- Variables, arguments, or functions named `id`, `list`, `type`, `input`, `map`, `filter`, `format`, `hash`, `open`, `range`, `set`, `dict`, `str`, `int`, etc.

**Example catches:**

```python
def process(id, input, list):   # A002: shadowing builtins
    type = "widget"              # A001: shadowing `type`
    return list                  # This is now the argument, not the builtin

id = 42                          # A001: later calling id() will fail
```

**Why it's essential:** Shadowing builtins leads to confusing bugs. `id = 5` is harmless until someone later calls `id(obj)` in the same scope and gets a `TypeError: 'int' object is not callable`.

---

### `RUF` — Ruff-specific rules

Rules unique to ruff that fill gaps no other linter covers.

**What it catches:**

- Invalid `# noqa` directives (referencing non-existent rules)
- Unused `# noqa` comments
- Implicit `Optional` in function signatures
- Mutable class variables without `ClassVar` annotation
- Unnecessary `dict` call on comprehension
- Various edge cases and ruff-internal improvements

**Example catches:**

```python
x = 1  # noqa: E999    # RUF100: unused noqa directive (E999 not triggered)

from typing import Union
def foo(x: Union[int, None]):  # RUF013: consider `int | None`
    pass
```

**Why it's essential:** Meta-hygiene. Keeps your `noqa` comments honest and catches things that fall through the cracks of every other rule set.

---

## Tier 2: Worth Considering

These rules provide real value but may require some configuration or generate occasional false positives. Evaluate them against your project's needs.

```toml
[tool.ruff.lint]
select = [
    # Tier 1
    "F", "E", "W", "B", "BLE", "I", "UP", "T10", "A", "RUF",
    # Tier 2
    "C4", "N", "SIM", "PERF",
]
```

---

### `C4` — flake8-comprehensions

Suggests simpler and more efficient comprehension syntax.

**What it catches:**

- `list(x for x in items)` → `[x for x in items]`
- `dict([(k, v) for k, v in items])` → `{k: v for k, v in items}`
- Unnecessary `list()` / `set()` / `dict()` wrappers around generators
- `[x for x in items]` → `list(items)` when no transformation occurs

**Example catches:**

```python
squares = list(x**2 for x in range(10))   # C400: use [x**2 for x in range(10)]
mapping = dict([(k, v) for k, v in d])    # C404: use {k: v for k, v in d}
result = list([x for x in items])         # C411: unnecessary list() wrapper
```

**Why it's worth considering:** The suggestions are almost always correct and produce cleaner, faster code. Very low noise.

---

### `N` — pep8-naming

Enforces PEP 8 naming conventions.

**What it enforces:**

- `snake_case` for functions, methods, and variables
- `PascalCase` for classes
- `UPPER_SNAKE_CASE` for module-level constants
- `snake_case` for function arguments
- No `CamelCase` functions, no `lowercase` classes

**Example catches:**

```python
class my_class:              # N801: class should use PascalCase
    pass

def MyFunction():            # N802: function should be snake_case
    pass

def method(Self):            # N805: first argument should be `self`
    pass
```

**When it gets noisy:**

- Interfacing with external APIs that use `camelCase`
- Overriding third-party library methods
- Legacy codebases with established conventions
- Mathematical code where `X`, `A`, `b` are conventional names

**Configuration tip:** Use `ignore-names` to whitelist specific patterns.

---

### `SIM` — flake8-simplify

Suggests simpler alternatives for common code patterns.

**What it catches:**

- `if x == True:` → `if x:`
- Nested `if` statements that can be collapsed with `and`
- `if/else` blocks that can be ternary expressions
- `not (a == b)` → `a != b`
- Manual dictionary lookups instead of `.get()`
- Context managers that can be combined

**Example catches:**

```python
if x == True:                  # SIM118: use `if x:`
    pass

if a:                          # SIM102: collapsible if
    if b:
        do_thing()

if cond:                       # SIM108: use ternary
    x = 1
else:
    x = 2

with open("a") as a:           # SIM117: combine with-statements
    with open("b") as b:
        pass
```

**When it gets noisy:** Sometimes the "simpler" version is less readable. Ternary suggestions for complex conditions make code harder to scan. The collapsed `if` suggestions can obscure the logic.

---

### `PERF` — Perflint

Identifies performance anti-patterns.

**What it catches:**

- Unnecessary list creation in loops (use generators)
- `try/except` in loops where a check would be faster
- Repeated lookups that could be cached
- Using `+` for string concatenation in loops (vs `join`)

**Example catches:**

```python
# PERF401: use a list comprehension
result = []
for item in items:
    result.append(item * 2)

# PERF403: use a dict comprehension
mapping = {}
for k, v in pairs:
    mapping[k] = v
```

**When it gets noisy:** In non-hot-path code, readability often matters more than micro-performance. A clear `for` loop can be more readable than a complex comprehension.

---

## Tier 3: Optional / Use-Case Specific

These rules encode strong opinions that may or may not align with your project. Enable them deliberately.

```toml
[tool.ruff.lint]
select = [
    # Tier 1
    "F", "E", "W", "B", "BLE", "I", "UP", "T10", "A", "RUF",
    # Tier 2
    "C4", "N", "SIM", "PERF",
    # Tier 3
    "T20", "PTH", "PT",
]

[tool.ruff.lint.per-file-ignores]
"scripts/*" = ["T20"]
"tests/*" = ["S101"]
"cli.py" = ["T20"]
```

---

### `T20` — flake8-print

Flags `print()` and `pprint()` statements.

**What it catches:**

```python
print("debug value:", x)       # T201: print found
pprint(my_dict)                # T203: pprint found
```

**Enable if:** You're building a library, API, or service where `print()` is never the right output mechanism. Forces use of proper logging.

**Skip if:** You're building a CLI tool, script, or anything where `print()` is the intended output method. You'll be adding `# noqa: T20` constantly.

**Configuration tip:** If enabled, use `per-file-ignores` to allow prints in specific files:

```toml
[tool.ruff.lint.per-file-ignores]
"scripts/*" = ["T20"]
"cli.py" = ["T20"]
```

---

### `PTH` — flake8-use-pathlib

Flags all `os.path` and `os` filesystem operations, suggesting `pathlib` equivalents.

**What it catches:**

```python
import os

path = os.path.join("a", "b")       # PTH118: use Path("a") / "b"
exists = os.path.exists(path)        # PTH110: use Path(path).exists()
files = os.listdir(".")             # PTH208: use Path(".").iterdir()
content = open("file.txt").read()   # PTH123: use Path("file.txt").read_text()
```

**Enable if:** You're starting a new project and want to standardize on `pathlib` throughout. Works well for application code.

**Skip if:**

- You have a large existing codebase using `os.path` (the migration noise is enormous)
- You're doing heavy string manipulation on paths
- You're working with APIs that expect `str` paths
- Performance-sensitive filesystem operations (`os` functions are faster in tight loops)

**Reality check:** `pathlib` is great, but this rule is one of the noisiest in ruff. Many experienced Python developers prefer `os.path` for certain operations, and the migration suggestions aren't always improvements.

---

### `PT` — flake8-pytest-style

Enforces opinions about pytest test style.

**What it catches:**

- `@pytest.fixture()` vs `@pytest.fixture` (parentheses consistency)
- `@pytest.mark.parametrize` argument style
- `assertEqual`-style assertions vs plain `assert`
- `pytest.raises` usage patterns
- Fixture scope and naming patterns

**Example catches:**

```python
@pytest.fixture()                      # PT001: remove parentheses
def my_fixture():
    return 42

def test_error():
    with pytest.raises(ValueError):    # PT011: add `match` parameter
        raise ValueError("boom")

class TestFoo:
    def test_thing(self):
        self.assertEqual(1, 1)         # PT009: use plain `assert`
```

**Enable if:** You're on a team that wants strict pytest style consistency and you've agreed on the conventions.

**Skip if:** You don't want to argue about whether `@pytest.fixture` should have parentheses. Many of these rules enforce arbitrary preferences that don't affect correctness.