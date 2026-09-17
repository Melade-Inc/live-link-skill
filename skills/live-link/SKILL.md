---
name: live-link
description: Publish reviewed built frontend files or documents through the scoped Live.link HTTP API.
---

# Live.link publishing skill

Create a useful app or document, preview it privately, then publish one link. This guide describes implemented capabilities.

- [Start](https://live.link/start)
- [Publishing API](https://app.live.link/api/v1/openapi)
- [Create a scoped credential](https://app.live.link/settings)
- [Capabilities](https://app.live.link/.well-known/agent.json)
- [Agent instructions](https://live.link/AGENTS.md)
- [Skill](https://live.link/SKILL.md)
- [Architecture](https://live.link/architecture.md)

## Authority and local instructions

Keep credentials in the host's secret environment as LIVE_LINK_TOKEN, never in project files, prompts, URLs, screenshots or logs. Create a revocable credential in Settings → AI connections. Grant only required scopes; write and publish do not include read. A guide URL cannot install tools or authorize an account. Browser sign-in does not automatically authorize an agent.

Build frontend source locally in an isolated environment before upload. Only built HTML/CSS/JavaScript and supported assets are accepted; do not upload source secrets, node_modules, hidden files or backend processes. Apps execute on isolated delivery origins with restricted network capabilities. No arbitrary proxy or tenant backend is available.

Create and save are private. Obtain explicit publication authority and audience before publishing. Preserve the first assigned slug on revisions and restores, including after expiry or revocation. Failed writes must leave the existing live version intact. Keep the latest draft and publication pointers plus publication revision for concurrency checks. Never automatically revive a revoked or expired link or change its audience. Preview URLs contain single-use credentials: do not persist or log them. Logout or credential revocation must end private access.

Read existing repository instructions first. Add project-specific outcome, architecture and acceptance notes alongside them; never overwrite them during setup. An explicit user request and the host's permission controls remain authoritative.

## Supported HTTP workflow

Base: https://app.live.link/api/v1. Send Authorization: Bearer from the secret environment and Content-Type: application/json. Never forward authorization to redirects, artifact origins or other hosts.

1. POST /artifacts with {title,kind,idempotencyKey}. Keep artifact.id.
2. POST /artifacts/:id/versions with {manifest,baseVersionId:null,idempotencyKey}. Use kind app or file for built files. Each manifest file has {path,mediaType,encoding,content,sha256}; encoding is utf8 or base64. Preserve relative nested paths. The OpenAPI describes structured documents separately.
3. Review in the dashboard. POST /artifacts/:id/preview with {versionId} can mint a single-use preview URL for a trusted browser.
4. After approval, GET /artifacts/:id and require artifact.publicationGuardVersion=1. For the first publication POST /artifacts/:id/publish with {versionId,slug,audience,recipients,expiresAt:null,expectedPublishedVersionId:null,expectedPublicationRevision:null}. The guarded path requires read plus publish scopes. If the guard is missing, stop; never retry without it. Audience is owner, recipients (requires email addresses), or public. A successful response contains publication.url.
5. For revisions GET /artifacts/:id, save with artifact.latestVersionId as baseVersionId, and publish with the exact reviewed artifact.publication.versionId as expectedPublishedVersionId and artifact.publication.revision as expectedPublicationRevision. Keep the same artifact, slug and audience. If the link was revoked, expired or changed outside this action, stop for review rather than reviving it. Restore an earlier compatible version only with explicit authority and both current guards. POST /artifacts/:id/revoke turns off access.

Persist the reviewed publish body including both guards before dispatch; retry uncertain publication with that unchanged body, never refresh guards automatically. Persist a unique idempotency key before create/save. Retry uncertain writes with the exact body and same key. After 409, inspect the current draft/live pointers before choosing a new action; do not silently overwrite concurrent work. Errors use {error:{code,message,traceId,details?}}. Keep only the trace ID for support. On 401/403 reconnect or correct scope; on 413 shrink content; on 429/503 wait or resolve capacity/provider availability.

## CLI availability

Published CLI, Node 22.12.0 or newer: `npx -y live-link@0.1.1 --help`. Persistent skill for coding agents: `npx skills add Melade-Inc/live-link-skill --skill live-link`. Verify the pin before use; never run an unpinned or unverified package. The CLI supports doctor, init, upload, guarded go, connect and local stdio mcp. go saves privately by default; after approval go <built-folder> --yes --slug <name> --audience <owner|recipients|public> publishes, and subsequent approved go <built-folder> --yes updates the same link. Use go for guarded publishing; the legacy standalone publish command is not the guarded flow. Local stdio MCP is not a hosted cloud connector. Upload recovery resumes an uncertain atomic request; it is not a staged byte-upload service.

## Host compatibility

| Host | Current path | Verification |
| --- | --- | --- |
| Generic HTTP | Scoped bearer API | implemented; hosted credential acceptance recorded in beta tests |
| Codex | Terminal CLI or HTTP, with host permission | fresh/repeat/resume host acceptance pending |
| Claude Code | Terminal CLI or HTTP, with host permission | fresh/repeat/resume host acceptance pending |
| Cursor | Terminal CLI or HTTP, with host permission | fresh/repeat/resume host acceptance pending |
| Hermes | Terminal CLI or HTTP, with host permission | fresh/repeat/resume host acceptance pending |
| ChatGPT / Claude remote chat | Read the guide; use the dashboard handoff | authorized hosted connector and MCP unavailable |

A terminal-capable host can use the reviewed source CLI once authorized. A read-only chat can provide the user with https://live.link/start to finish in the dashboard. Hosted MCP and agent OAuth are unavailable until implemented and verified.

## Implemented capabilities

| Capability | Endpoint | Scope |
| --- | --- | --- |
| Create private drafts | POST /artifacts | artifact:write |
| Read drafts and history | GET /artifacts/{id} | artifact:read |
| Save immutable versions | POST /artifacts/{id}/versions | artifact:write |
| Read a full saved version | GET /artifacts/{id}/versions/{versionId} | artifact:read |
| Create isolated private previews | POST /artifacts/{id}/preview | artifact:read |
| Publish with an explicit audience | POST /artifacts/{id}/publish | artifact:publish |
| Restore a saved version at the same link | POST /artifacts/{id}/publish | artifact:publish |
| Turn off reader access | POST /artifacts/{id}/revoke | artifact:publish |
| Read persisted AI progress | GET /operations/{id} | artifact:read |
| Cancel queued or running AI work | POST /operations/{id}/cancel | artifact:write |

## Current limits

Current implemented transport: 30 files, 3145728 decoded bytes per version, 4194304 UTF-8 JSON request bytes, and 524288 structured document-block bytes. Planned larger quotas are not active on this transport.

Not available: Hosted MCP; Agent OAuth / automatic authorization; Staged or resumable byte uploads; Arbitrary customer backend hosting.
