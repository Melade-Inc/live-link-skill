# live.link skill and CLI

Publish a built folder, an HTML file or a document to one stable live link. Private draft first; publish the reviewed version only with the user's explicit authorization. Complete supported work in the current agent conversation. Guide for agents: https://live.link/start

- Skill for coding agents: `npx skills add Melade-Inc/live-link-skill --skill live-link`
- CLI (Node 22.12 or newer): `npx -y live-link@0.1.5 go ./dist` saves a private draft; `npx -y live-link@0.1.5 go ./dist --yes --slug my-app --audience public` publishes after approval, and later `go ./dist --yes` updates the same link
- Local MCP for terminal agents: `npx -y live-link@0.1.5 connect ./dist` prints a credential-free stdio server config
- Global install: `npm install -g live-link@0.1.5` or `sh install.sh`

Reuse a usable authorized connection. For the CLI, credentials stay in the host secret environment as LIVE_LINK_TOKEN; create one at https://app.live.link/settings only when the required scoped credential is missing. Never put a credential in chat, a project file or a command argument. A connection alone does not authorize publication.

Copyright 2026 Melade, Inc. Owned public distribution files are Apache-2.0 licensed; see LICENSE and NOTICE. Bundled third-party notices are in THIRD_PARTY_NOTICES. The private platform is outside this grant.

This repository is generated from the reviewed live.link source at release time; open issues here, but changes land upstream. Version: 0.1.5.
