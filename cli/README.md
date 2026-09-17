# Live.link CLI

Published as the npm package `live-link` (Node 22.12 or newer) and the skill `Melade-Inc/live-link-skill`:

```sh
npx skills add Melade-Inc/live-link-skill --skill live-link   # persistent skill for coding agents
npx -y live-link@0.1.1 go ./dist                              # private draft, returns a dashboard review URL
npx -y live-link@0.1.1 go ./dist --yes --slug my-app --audience public   # publish after approval; later --yes updates the same link
npx -y live-link@0.1.1 connect ./dist                         # credential-free local stdio MCP config
```

Verify the pin before use; never run an unpinned package. From an authorized source checkout with workspace dependencies installed, the same commands run as:

```sh
node packages/cli/bin/live-link.mjs --help
node packages/cli/bin/live-link.mjs doctor
node packages/cli/bin/live-link.mjs init /path/to/project
node packages/cli/bin/live-link.mjs upload /path/to/project/dist --title "My app"
```

Supply `LIVE_LINK_TOKEN` through the host's secret environment. Never include its value in a command argument, project file, prompt or transcript. Create a scoped credential in [Settings](https://app.live.link/settings). The CLI never logs the credential or arbitrary API error bodies and never forwards authorization through redirects.

Upload returns a private artifact ID and version ID. Review in the dashboard, then explicitly publish:

```sh
node packages/cli/bin/live-link.mjs publish ARTIFACT_UUID --version VERSION_UUID --slug my-app --audience owner --confirm
```

Replace the ID placeholders with the returned UUIDs. Owner, recipients and public are the implemented audiences; recipients requires `--recipients` with comma-separated addresses. No OAuth consent or hosted MCP installation is automated.

`init` preserves existing files byte for byte. It creates `.live-link/AGENTS.md`, architecture, capabilities and acceptance notes only when missing. It creates a root `AGENTS.md` only if none exists; otherwise the host must explicitly read `.live-link/AGENTS.md` alongside its own instructions. Repeat initialization fills only missing files and never rewrites local notes.

`upload` accepts a real built output directory and preserves nested paths. It rejects symlinks, hardlinks, traversal, duplicate case-insensitive paths, unsupported formats and possible credentials; it excludes hidden files, known secret filenames, dependency directories and source maps. Detection does not prove that content has no secrets. The server remains authoritative for format, signatures, hashes, size, scope and workspace validation.

The current transport is one atomic JSON version request: at most 30 files, 3 MiB decoded bytes and 4 MiB request bytes including base64 overhead. This CLI does not implement ZIP extraction, source builds, staged uploads or arbitrary server hosting.

Recovery metadata lives in `~/.local/state/live-link` with private file permissions, never the project. It contains IDs, hashes, idempotency keys and the publication request (including recipient emails), but no credential or uploaded file content. An identical upload retries the original request and returns the original saved version. Changed input starts a distinct save; use `--artifact` for a revision. A publication retry preserves its original concurrency pointer and will not overwrite a later publication or revive a completed operation after revocation. Use the dashboard for an intentional subsequent republish. Commands serialize on a private lock; after an interrupted process, confirm it has exited before removing its corresponding `.lock` file to resume. State removal loses retry protection; do not delete it during an uncertain write.

Run `pnpm --filter @live-link/cli test` for real local HTTP protocol and filesystem tests. Fresh/repeat/resumed runs in Codex, Claude Code, Cursor, Hermes and remote connectors remain separate acceptance gates. `doctor` finds executables without running them and sends no credential; discovery is not a host integration test.

## Guarded same-link command (source preparation)

`go ./dist` saves privately. After preview and explicit publication authority,
`go ./dist --yes --slug my-app --audience public` publishes; later `go ./dist --yes`
keeps that project, slug and audience. Configure the scoped credential once through
LIVE_LINK_TOKEN. No credential is automatically minted. Use `--artifact UUID` only
when deliberately adopting an existing project with the matching publication
settings. An unresolved command must be retried with its exact files/options and
credential; never delete its journal to bypass an error.

This command requires the reviewed publication-revision server guard for --yes.
Current public beta has not accepted that rollout yet. Private-first preparation
works against the old API; no public install/unattended-readiness claim follows.
See docs/operations/AGENT_PUBLISH_GUARD.md for migration and hosted acceptance gates.

## Terminal MCP setup (local source candidate)

An installed reviewed checkout can prepare a setup packet for an existing built
folder, without modifying project or host configuration:

```sh
node packages/cli/bin/live-link.mjs connect /absolute/path/to/product/dist
```

Use `claudeCode` from the returned JSON as the Claude Code MCP configuration,
merging its `live-link` entry with any existing servers. It references
`${LIVE_LINK_TOKEN}` literally; never replace that reference with a credential in a
project file. Supply the credential through the launching host's secret environment.
Claude Code must approve loading the server according to its normal trust controls.
Other terminal hosts use the `mcp` configuration with their own secret forwarding.
No config writes or host commands run automatically. Absolute paths require this
reviewed checkout and Node installation to remain at their current locations.

The local server starts with `live-link mcp /absolute/path/to/product/dist` and
exposes `live_link_check`, `live_link_save`, and `live_link_publish`. Only the startup
folder is accessible. Save is private; review its dashboard handoff before publishing.
First publication requires explicit `confirm: true`, slug and audience. Revisions
reuse the same link and the CLI's persistent retry journal. Concurrent actions are
rejected, not queued. This does not launch build commands or host backend processes.

`configuration-prepared` means only that the files passed local preparation, not
that the account, remote guard or public release was verified. An empty project
must first be created or the correct existing built folder selected. No placeholder
is automatically published. No guest signup or credential minting occurs.

The public install, guarded publication migration/management rollout, named-host
acceptance, and hosted OAuth/cloud-chat MCP remain separate release gates. A pasted
link can guide an authorized terminal agent; it cannot bypass account consent or a
host's tool-installation permissions. See `docs/operations/TERMINAL_AGENT_CONNECT.md`.
