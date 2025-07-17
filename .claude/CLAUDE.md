# CLAUDE.md - Global Configuration

This file provides global guidance to Claude Code (claude.ai/code) across all projects.

## 言語設定

**日本語での対応**
- すべてのやり取りを日本語で行ってください
- Unless specifically asked to use another language, respond in Japanese
- 技術的な内容も日本語で説明してください

## IMPORTANT RULES

**NEVER COMMIT CODE WITHOUT EXPLICIT USER REQUEST**
- Do NOT run `git commit` unless the user explicitly asks to commit
- Do NOT run `git add` and `git commit` automatically
- Always ask for confirmation before committing changes
- The user wants to review changes before they are committed to version control
- This rule is non-negotiable and must be followed at all times

**GIT COMMIT POLICY - CRITICAL RULE**
- **ABSOLUTELY NEVER run `git add` when user says "git commit"**
- When user says "git commit", ONLY run `git commit` command
- Do NOT stage any files automatically - not even relevant files
- Do NOT run `git add` under any circumstances when user requests commit
- Only commit files that are already staged by the user
- If no files are staged, inform the user that there are no staged changes to commit
- This is a non-negotiable rule that must be followed exactly

**FILE CREATION POLICY**
- Do what has been asked; nothing more, nothing less
- NEVER create files unless they're absolutely necessary for achieving your goal
- ALWAYS prefer editing an existing file to creating a new one
- NEVER proactively create documentation files (*.md) or README files
- Only create documentation files if explicitly requested by the User

**SECURITY BEST PRACTICES**
- Always follow security best practices
- Never introduce code that exposes or logs secrets and keys
- Never commit secrets or keys to the repository

**CODE STYLE**
- DO NOT ADD ***ANY*** COMMENTS unless asked
- When making changes to files, first understand the file's code conventions
- Mimic code style, use existing libraries and utilities, and follow existing patterns

**RESTRICTED FILES**
- NEVER modify or touch ~/.config/git/ignore
- This file must remain untouched at all times
