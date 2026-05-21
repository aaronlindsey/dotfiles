# AGENTS.md

## Working with Git and GitHub

- Prefer the `gh` cli for interacting with GitHub.
- ALWAYS create DRAFT PRs (not regular PRs).
- Make sure non default branch is used (i.e. do not push to main, master, etc).
- Branch names should be prefixed with my username followed by a dash: `alindsey-`
- If changes are uncommitted, then only add changes related to the current conversation.

### Commit Messages

Follow Chris Beams's style for writing good commit messages:
- Separate subject from body with a blank line
- Limit the subject line to 50 characters
- Capitalize the subject line
- Do not end the subject line with a period
- Use the imperative mood in the subject line
- Wrap the body at 72 characters
- Use the body to explain what and why vs. how

### PR Descriptions

Make the PR description similar to the commit message(s). Do not mention obvious next steps like "unit tests pass" or "monitor CI results before merging".

### PR Stacks

When working on a larger change:
- Prefer a PR stack over one large PR when the work can be split into multiple reviewable steps with clear dependencies
- Optimize for reviewer comprehension: each PR should be simple, focused, and quick to understand on its own
- In general, err toward smaller PRs, but avoid splitting work so aggressively that the overhead becomes silly or wastes reviewer time
- For a stack of `y` PRs, title each PR with a `[x/y] ` prefix where `x` is that PR's position in the stack
- Each PR description should include the full ordered list of PRs in the stack with their titles
- When PR URLs exist, the stack list in each PR description should use Markdown links to the actual PRs, not plain text
- In that list, clearly highlight which PR is the current one so the reviewer can orient themselves quickly
- If you create PRs before every URL is known, go back and update the descriptions once the stack exists so each item links to the right PR
