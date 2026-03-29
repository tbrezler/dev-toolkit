# Git/GitHub Quick Reference

Quick commands and explanations for your daily Git workflow.

## Basic Daily Commands

### Status & Updates
```bash
git status              # See what's changed
git pull                # Get latest from GitHub
git log --oneline       # See recent commits
```

### Committing Your Work
```bash
git add .               # Stage all changes
git commit -m "Description of what changed"  # Commit with message
git push                # Push to GitHub
```

### Creating a Branch (for features/bug fixes)
```bash
git branch feature-name           # Create a new branch
git checkout feature-name         # Switch to that branch
# OR do both at once:
git checkout -b feature-name      # Create and switch in one command

git push -u origin feature-name   # Push branch to GitHub (first time only)
git push                          # Push subsequent commits to the branch
```

### Merging a Branch Back to Main
```bash
git checkout main       # Switch to main
git pull                # Get latest main
git merge feature-name  # Merge your branch into main
git push                # Push merged changes
git branch -d feature-name  # Delete the branch locally (optional)
```

## Your Workflow

### For Small Fixes (commit to main)
```bash
# Make changes
git status
git add .
git commit -m "Fix: description of fix"
git push
```

### For New Features (use a branch)
```bash
# Create a branch
git checkout -b feature/my-feature

# Make changes, commit
git add .
git commit -m "Feature: description"
git push -u origin feature/my-feature

# When ready, merge back to main
git checkout main
git pull
git merge feature/my-feature
git push
git branch -d feature/my-feature
```

## Common Commands Explained

| Command | What it does |
|---------|-------------|
| `git status` | Shows which files changed, what's staged |
| `git add .` | Stages all changes for commit |
| `git add filename` | Stages a specific file |
| `git commit -m "message"` | Records changes with a description |
| `git push` | Sends commits to GitHub |
| `git pull` | Gets latest changes from GitHub |
| `git branch` | Lists all branches |
| `git checkout branch-name` | Switches to a different branch |
| `git checkout -b branch-name` | Creates and switches to new branch |
| `git merge branch-name` | Merges a branch into current branch |
| `git log --oneline` | Shows recent commits |

## Undo/Fix Things

### "I committed to the wrong branch"
```bash
# If you haven't pushed yet:
git reset HEAD~1        # Undo the last commit (keeps changes)
git checkout -b correct-branch-name
git add .
git commit -m "message"
```

### "I want to undo my last commit"
```bash
git reset HEAD~1        # Undo last commit (keeps changes)
git reset --hard HEAD~1 # Undo last commit (loses changes - be careful!)
```

### "I pushed something wrong to main and need to undo it"
```bash
git revert HEAD          # Creates a new commit that undoes the last one
git push                 # This is safer than reset for pushed commits
```

### "I forgot to add a file to my last commit"
```bash
git add forgotten-file
git commit --amend      # Add to previous commit instead of making new one
git push                # (only if you haven't pushed yet; if you did, use --force-with-lease)
```

### "I accidentally committed a file I shouldn't have"

**If you haven't pushed yet:**
```bash
git reset HEAD~1        # Undo the last commit (keeps changes)
# Remove the file from staging
git reset filename
# Commit again without that file
git add .
git commit -m "message"
```

**If you already pushed (file is on GitHub):**
```bash
# Remove the file from Git tracking (but keep it locally)
git rm --cached filename
# Add the filename to .gitignore if not already there
echo "filename" >> .gitignore
# Commit and push
git add .gitignore
git commit -m "Remove: filename from tracking"
git push
```

**Important:** If you accidentally committed a `.env` file with credentials:
1. Follow the steps above to remove it
2. Rotate your credentials (generate new keys, passwords, etc.)
3. The file is still in Git history — treat credentials as compromised

For sensitive files, consider using `git-filter-branch` or `BFG Repo-Cleaner` to remove from history, but that's advanced. Focus on preventing it with .gitignore.

## Branch Naming (suggestions for future)

When you're ready, you might use:
- `feature/feature-name` – new features
- `bugfix/bug-name` – bug fixes
- `hotfix/urgent-fix` – urgent production fixes

For now, just use clear names like `update-dashboard` or `add-caching`.

## Things to Remember

- **Always pull before you push** – avoid conflicts
- **Use clear commit messages** – "Fix: username validation" beats "update"
- **Commit early and often** – small commits are easier to debug
- **Don't commit .env files** – they're in .gitignore for a reason
- **Test before pushing** – especially to main