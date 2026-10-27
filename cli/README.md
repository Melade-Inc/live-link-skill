# live.link CLI

This README describes version **0.1.4** of the `live-link` CLI (Node 22.12 or newer)
and its matching `Melade-Inc/live-link-skill` guidance. A source checkout or dry run
does not establish npm or skill publication. Verify that the exact pin is available
and reviewed before running these installation examples; never use an unpinned CLI package.

```sh
npx skills add Melade-Inc/live-link-skill --skill live-link   # persistent skill for coding agents
npx -y live-link@0.1.4 go ./dist                              # private draft; optional dashboard review URL
npx -y live-link@0.1.4 go ./dist --yes --slug my-app --audience public   # use exact publication authority; later --yes keeps the same link
npx -y live-link@0.1.4 connect ./dist                         # credential-free local stdio MCP config
```

The existing skill installer follows the public repository's default branch; it
is not a version-pinned installer. Release verification checks the generated skill
against the matching version tag separately. Local preparation does not update
an already installed skill or the public repository.

For local preparation, use an authorized source checkout with workspace dependencies installed:

```sh
node packages/cli/bin/live-link.mjs --help
node packages/cli/bin/live-link.mjs doctor
node packages/cli/bin/live-link.mjs init /path/to/project
node packages/cli/bin/live-link.mjs upload /path/to/project/dist --title "My app"
```

Reuse a usable scoped `LIVE_LINK_TOKEN` through the host's secret environment. Never include its value in a command argument, project file, prompt or transcript. If a credential is missing or invalid, use the supported credential setup in [Settings](https://app.live.link/settings); the CLI does not mint credentials. A scope denial requires checking the workspace and grant, not routine reconnection. The CLI never logs the credential or arbitrary API error bodies and never forwards authorization through redirects.

Use `go` for the guarded save-and-publish workflow. Without `--yes`, it saves privately and returns a version ID and optional dashboard review URL. Review that exact saved version using available authorized preview tools. The CLI does not render previews or return private reader credentials; report a missing preview capability instead of claiming a review occurred. Publish only under explicit user authority for the reviewed content, slug and audience. Reuse existing matching authority; ask only for missing or changed scope:

```sh
npx -y live-link@0.1.4 go ./dist --yes --slug my-app --audience owner
```

Owner, recipients and public are the implemented audiences; recipients requires `--recipients` with comma-separated addresses. The legacy standalone `publish` command is not the guarded flow; use `go` instead. Hosted OAuth consent is a separate browser flow and does not configure CLI authentication.

`init` preserves existing files byte for byte. It creates `.live-link/AGENTS.md`, architecture, capabilities and acceptance notes only when missing. It creates a root `AGENTS.md` only if none exists; otherwise the host must explicitly read `.live-link/AGENTS.md` alongside its own instructions. Repeat initialization fills only missing files and never rewrites local notes.

`upload` accepts a real built output directory and preserves nested paths. It rejects symlinks, hardlinks, traversal, duplicate case-insensitive paths, unsupported formats and possible credentials; it excludes hidden files, known secret filenames, dependency directories and source maps. Detection does not prove that content has no secrets. The server remains authoritative for format, signatures, hashes, size, scope and workspace validation.

The current transport is one atomic JSON version request: at most 30 files, 3 MiB decoded bytes and 4 MiB request bytes including base64 overhead. This CLI does not implement ZIP extraction, source builds, staged uploads or arbitrary server hosting.

Recovery metadata lives in `~/.local/state/live-link` with private file permissions, never the project. It contains IDs, hashes, idempotency keys and the publication request (including recipient emails), but no credential or uploaded file content. An identical upload retries the original request and returns the original saved version. Changed input starts a distinct save; use `--artifact` for a revision. A publication retry preserves its original concurrency pointer and will not overwrite a later publication or revive a completed operation after revocation. Inspect current state with available authorized tools or the optional dashboard before an intentional subsequent publication through a supported workflow. Commands serialize on a private lock; after an interrupted process, confirm it has exited before removing its corresponding `.lock` file to resume. State removal loses retry protection; do not delete it during an uncertain write.

Run `pnpm --filter @live-link/cli test` for real local HTTP protocol and filesystem tests. Fresh/repeat/resumed runs in Codex, Claude Code, Cursor, Hermes and remote connectors remain separate acceptance gates for this version. `doctor` finds executables without running them and sends no credential; discovery is not a host integration test.

## Guarded same-link command

`go ./dist` saves privately. With preview evidence and exact publication authority,
`go ./dist --yes --slug my-app --audience public` publishes; later `go ./dist --yes`
keeps that project, slug and audience. Configure the scoped credential once through
LIVE_LINK_TOKEN. No credential is automatically minted. Use `--artifact UUID` only
when deliberately adopting an existing project with the matching publication
settings. An unresolved command must be retried with its exact files/options and
credential; never delete its journal to bypass an error. A replacement credential
cannot resume an unresolved `go` operation bound to the old credential.

`go` cannot automatically recover a revoked or expiring link, a changed publication,
or a mismatched recovery record. Report the blocker and inspect current state with
available authorized tools or the optional dashboard. Do not promise that another
CLI retry, a new credential or changed arguments will resolve these cases.

This command requires the reviewed publication-revision server guard for --yes.
The production guarded publishing rollout is active. The client requires both
publication guards and stops when the server lacks them or reports a conflict.
Never retry a conflict by refreshing the guards automatically. This does not prove
unattended operation in every agent host; named-host acceptance is recorded separately.

## Terminal MCP setup

The CLI can prepare a setup packet for an existing built
folder, without modifying project or host configuration:

```sh
npx -y live-link@0.1.4 connect /absolute/path/to/product/dist
```

Use `claudeCode` from the returned JSON as the Claude Code MCP configuration,
merging its `live-link` entry with any existing servers. It references
`${LIVE_LINK_TOKEN}` literally; never replace that reference with a credential in a
project file. Supply the credential through the launching host's secret environment.
Honor Claude Code's normal server trust controls; reuse an already usable setup.
Other terminal hosts use the `mcp` configuration with their own secret forwarding.
No config writes or host commands run automatically. The installed package prints
the pinned `npx -y live-link@0.1.4 mcp` invocation. A source-checkout invocation
instead requires that checkout and Node installation to remain in place.

The local server starts with `live-link mcp /absolute/path/to/product/dist` and
exposes `live_link_check`, `live_link_save`, and `live_link_publish`. Only the startup
folder is accessible. This stdio transport is for terminal hosts; cloud chat hosts
use the hosted connector below. Save is private and its dashboard review URL is
optional. Review the exact saved version with available authorized preview tools;
the local server has no preview tool. Publication requires `confirm: true` under
the user's explicit authority, with slug and audience on the first call. Existing
matching authority is sufficient; connection consent alone is not. Revisions
reuse the same link and the CLI's persistent retry journal. Concurrent actions are
rejected, not queued. This does not launch build commands or host backend processes.

`configuration-prepared` means only that the files passed local preparation, not
that the account, remote guard or public release was verified. An empty project
must first be created or the correct existing built folder selected. No placeholder
is automatically published. No guest signup or credential minting occurs.

## Connect from Claude.ai, ChatGPT or Grok

Reuse a usable hosted connection and its current authorized tools. Only when the
connection is missing, add `https://app.live.link/mcp` as a custom connector using OAuth and public-client
dynamic registration. In Claude.ai select **Sign in now** and **Register automatically**.
ChatGPT requires developer mode. No dashboard token or client secret is needed;
Client ID Metadata Documents (CIMD) are not supported. Sign in and review the client,
redirect target and scopes before approving. Renew authentication only when it is
missing or invalid, and request additional consent only for required missing scope.
Connection consent alone is not publication authority. Review the exact private
version and reuse existing publication authority that covers its content, slug and
audience; ask only when that authority is missing or materially changes.

Hosted MCP and consent-based OAuth are active. The following historical evidence
does not establish named-host acceptance of version 0.1.4. On September 17, 2026, Claude.ai,
ChatGPT developer mode and Grok passed private save, preview handoff, approved
public publication, one same-link revision, controlled stale-guard rejection and
revocation. Natural rotation passed at 16:29:13 UTC (Claude.ai), 17:15:24 UTC
(ChatGPT), and proactively at 17:25:18 UTC (Grok, followed by a tool read after
17:28 UTC; expiry-trigger timing NOT OBSERVABLE). All three passed originating-session
sign-out denial after 17:28:23 UTC and Settings disconnect at 17:29–17:30 UTC.
Reconnection passed at 22:18 UTC (Claude.ai and ChatGPT) and 22:20 UTC (Grok),
with actual reads at 22:21 UTC and one live grant each at 22:23 UTC. Grok required
one retry after a failure before authorization; its explicit cancel was NOT OBSERVABLE.
Fresh signed-out login inside each host redirect was NOT OBSERVABLE.
ChatGPT's default “Allow low-risk actions” setting published on a one-line user instruction without a separate host confirmation dialog. Connection consent is
not publication authority. Publication authority must cover the exact version, audience and publication intent.
The CLI still uses `LIVE_LINK_TOKEN`; this release adds no login command. A pasted
link cannot bypass account consent or host permissions.

## Change requests

Read requests before editing, take work before saving it, and resolve done only
with the saved version ID. A queued change request does not itself grant publication
authority; reuse separately established matching authority when it is still valid.

```sh
live-link requests list --artifact UUID
live-link requests pull --artifact UUID --take --limit 10
live-link requests resolve --artifact UUID --request UUID --outcome done --version UUID --expected-access-epoch N
live-link requests resolve --artifact UUID --request UUID --outcome declined --expected-access-epoch N
```

`pull` without `--take` reads without taking. List/pull need `artifact:read`; take
needs both read and write, and resolve needs `artifact:write`. Supply the exact
`accessEpoch` returned on the taken request as `--expected-access-epoch` when the
server requires guarded requests; never refresh it to escape stale authority.
If a continuity-aware save closed the request atomically using its requestId, do
not send a second done resolution. No watch loop, lease or attempt protocol is
implemented. Authentication remains LIVE_LINK_TOKEN in the environment.
