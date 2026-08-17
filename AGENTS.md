# Agent Context & Token Efficiency Guidelines

## Conciseness Rules
- Output minimal, direct responses without filler, greetings, or post-action narration.
- Do not repeat file contents or restate obvious command outputs.
- Limit explanations to 1–3 short bullet points.

## Command Execution
- Common commands (`git`, `ls`, `pytest`, `npm`, `docker`, `cargo`, `uv`, `pip`, `gh`) are pre-wrapped with RTK for automatic token optimization.
- Avoid dumping large outputs; inspect files with line ranges or filtered views.
