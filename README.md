# Live.link skill and CLI

Publish a built folder, an HTML file or a document to one stable live link. Private draft first; publish only after review. Guide for agents: https://live.link/start

- Skill for coding agents: `npx skills add Melade-Inc/live-link-skill --skill live-link`
- CLI (Node 22.12 or newer): `npx -y live-link@0.1.2 go ./dist` saves a private draft; `npx -y live-link@0.1.2 go ./dist --yes --slug my-app --audience public` publishes after approval, and later `go ./dist --yes` updates the same link
- Local MCP for terminal agents: `npx -y live-link@0.1.2 connect ./dist` prints a credential-free stdio server config
- Global install: `npm install -g live-link@0.1.2` or `sh install.sh`

Credentials stay in the host secret environment as LIVE_LINK_TOKEN (create one at https://app.live.link/settings). Never put a credential in chat, a project file or a command argument.

Copyright 2026 Melade, Inc. Owned public distribution files are Apache-2.0 licensed; see LICENSE and NOTICE. Bundled third-party notices are in THIRD_PARTY_NOTICES. The private platform is outside this grant.

This repository is generated from the reviewed Live.link source at release time; open issues here, but changes land upstream. Version: 0.1.2.
