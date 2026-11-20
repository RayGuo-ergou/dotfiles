# Coding guidelines

1. **Do not use browsers or browser automation.** Do not launch or control Chrome, Chromium, Firefox, or any other browser, including in headless mode. Do not use Playwright or similar tools to drive a browser.
2. **Troubleshoot from the code, not by querying the database.** Trace the relevant source code, including any queries it defines, without executing direct database queries, even read-only ones. If the code does not answer a question you need to resolve, ask the user for the missing information instead of querying the database or guessing.
