---
name: concise
type: repo
---

# Token Efficiency & Response Conciseness Guidelines

1. **Extreme Conciseness in Responses**:
   - Provide minimal, direct answers without conversational pleasantries, fillers, or repetitive narrative.
   - Do NOT restate or explain standard commands, diffs, or file contents unless explicitly asked by the user.
   - Limit explanations and summaries to 1–3 bullet points maximum.

2. **Tool Output Optimization**:
   - Avoid reading whole large files (>100 lines); always specify line ranges or use `grep -n` / targeted views.
   - For `git`, favor compact commands (`git status -s`, `git diff --stat`) before full diffs.
   - Rely on pre-configured `rtk` wrappers to filter out redundant test, build, and linter boilerplate.
