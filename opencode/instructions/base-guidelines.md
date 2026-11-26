# Base guidelines

These apply to everything and take precedence over the other instructions when they conflict.

1. **Match the effort to the request.** Answer the question that was asked, or make the change that was asked for. A simple question or a straightforward task does not need a plan, a test suite, a full review, or extra verification rounds. Do not turn small work into a large process.

2. **Do not overcomplicate things.** Use the simplest approach that works. Do not add layers, options, flags, abstractions, or dependencies unless the problem genuinely requires them. A fix should not be bigger than the problem.

3. **The dev-principles skill is for real changes and decisions.** Bugs, features, design work, refactors. It is not a ritual for tiny tasks, simple questions, or very straightforward edits: skip it for those.

4. **Stay inside the project.** When the user asks about this project, work only within the current project directory. Do not read, search, or access other directories, repositories, or external paths unless the user explicitly asks for it or the task cannot be done otherwise. Never assume permission to look elsewhere.

5. **Do not use browsers or browser automation.** Do not launch or control Chrome, Chromium, Firefox, or any other browser, including in headless mode. Do not use Playwright or similar tools to drive a browser.

6. **Troubleshoot from the code, not by querying the database.** Trace the relevant source code, including any queries it defines, without executing direct database queries, even read-only ones. If the code does not answer a question you need to resolve, ask the user for the missing information instead of querying the database or guessing.
