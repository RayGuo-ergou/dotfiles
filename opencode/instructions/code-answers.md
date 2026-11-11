# Answer code questions with evidence

Apply when reading or explaining code in any language: answering why something happens, tracing execution or data flow, diagnosing an error, or explaining when state is created or changed. A question about behavior does not authorize changing it.

The user must be able to validate the answer without asking again for the code or its location. An unsupported summary is not enough.

## Investigate before answering

- Read the actual implementation and relevant callers; do not infer behavior from names, comments, documentation, or search matches alone.
- Trace the calls, branches, transformations, writes, and state changes that explain the behavior. Follow relevant boundaries across languages, processes, configuration, queries, and generated code when the path crosses them.
- Check alternative writers, creation paths, and dispatch targets before claiming something "always" happens or is "only" handled in one place.
- Distinguish source-proven behavior from runtime observations and hypotheses about particular data, environments, or incidents. Tests demonstrate the cases they exercise, not every possible execution.
- Do not invent historical intent. If the evidence does not establish why a design was chosen, say so.

## Make the answer verifiable

1. State the direct answer.
2. Show the relevant steps in execution or data-flow order, each with a clickable file-and-line reference and a short, exact code excerpt.
3. Explain what each excerpt proves, especially where values change or control flow diverges.
4. Identify relevant exceptions, early exits, alternative paths, and anything not verified.

- Link using the actual source path and verified current line numbers: `[path/to/file:42–48](path/to/file#L42-L48)`. Do not reuse stale line numbers after edits.
- Use the appropriate language for fenced code blocks. Quote actual source, not an invented equivalent; clearly mark omissions using syntax appropriate to the language or separate excerpts.
- Include enough context to show the condition and action, without pasting entire files.
- For data flow, show the producer, relevant transformations or mutations, and consumer. Distinguish in-memory state from persisted state, including reloads and transaction boundaries when relevant.
- For errors, show the failing expression and the caller or input path that reaches it.
- For asynchronous work, retries, or concurrency, distinguish attempts, objects, and tasks; establish ordering from evidence rather than assuming source order is execution order.
- If several paths could explain an observation, identify them rather than presenting one possibility as confirmed.

## Corrections and follow-ups

When challenged, reread the relevant code, acknowledge any incomplete or incorrect claim, and supply the missing evidence directly. Do not repeat an unsupported summary or make the user ask again for code and locations.

Keep the explanation focused, but prioritize verifiable evidence over brevity.
