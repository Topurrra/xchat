# X Chat - Local & Cloud AI

A single-file, private-first AI chat app. Talk to **on-device** models (Chrome's built-in Gemini Nano / Gemma), your **local Ollama** models, or **cloud** models (OpenRouter, Groq, Cerebras, Mistral) — all from one charcoal-and-orange UI with no build step and no backend.

The entire app is one file: **`xchat.html`**.

---

## 🚀 Quick start

### 1. Serve the folder
On-device AI works on `file://`, but Ollama and the cloud providers need an `http`/`localhost` origin, so serving is recommended.

```bash
cd xchat
python -m http.server 8765
```

Then open **http://localhost:8765/xchat.html**

> **Windows shortcut:** double-click **`launch-ai-chat.bat`** — it starts the server and opens the app in a clean, isolated, app-mode Chrome window (no tabs/omnibox). First run, follow the flag steps printed in the file.

### 2. Pick a model (top-left model menu)

**On-device (Chrome built-in)** — needs **Chrome Dev/Canary** with these flags enabled (`chrome://flags`), then restart:
- `#prompt-api`
- `#prompt-api-multimodal-input` (image + audio)
- `#writer-api`, `#rewriter-api`, `#proofreader-api`, `#summarizer-api`
- `#gemma4-for-built-in-ai` *(optional — higher-quality model)* + `#on-device-model-litert-lm-backend` + `#on-device-model-speculative-decoding` *(faster)*
- Translator & Language Detector need **no flag**.

Then let the model download at `chrome://on-device-internals` (or it pulls on first use). Check status at `chrome://components`.

**Ollama** — install [Ollama](https://ollama.com), pull a model, and start it so the browser can reach it:
```bash
# macOS/Linux
OLLAMA_ORIGINS=* ollama serve
# Windows PowerShell
$env:OLLAMA_ORIGINS="*"; ollama serve
```
Then set the server URL in **Settings** if it isn't the default `http://localhost:11434`.

**Cloud** (OpenRouter / Groq / Cerebras / Mistral) — paste your API key(s) in **Settings → Cloud API keys**, then pick a provider + model in the Cloud tab. Free tiers are rate-limited.

---

## ✨ What's in it today

### Providers
- **On-device:** Gemini Nano / Gemma via Chrome's built-in Prompt API — fully private & offline.
- **Ollama:** any local model you've pulled (Llama, Mistral, Qwen, Phi, llava, …).
- **Cloud (OpenAI-compatible):** OpenRouter (with a *Free-only* filter), Groq, Cerebras, Mistral.
- **Per-conversation model** — each chat remembers its own model.

### Chat
- Token-by-token **streaming**, **stop**, **regenerate**.
- **Markdown** rendering: headings, lists, **bold**/*italic*, `inline code`, fenced code blocks with copy buttons, blockquotes, links, **tables**, `<br>`, rules — all XSS-safe.
- **Edit & resend** your own messages.
- **Multiple conversations:** sidebar with search, rename, pin, delete; auto-titled.

### Attachments & multimodal
- Attach **images, audio, PDF, and text/code files** — via the 📎 button, drag-and-drop, or paste.
- Images downscale automatically; click any image to zoom (lightbox).
- **Chat with a document:** text/code read natively; PDF via a lazy-loaded extractor.
- Per-provider encoding (Nano multimodal, OpenRouter vision, Ollama llava).

### On-device tools (the wand ✨ menu)
- **Proofread**, **Rewrite** (more formal / casual / shorter / longer), **Expand** a note into a draft.
- **Summarize chat**.
- **Translate** — translate your draft into 16 languages, or hit **Translate** on any message (auto-detects the source).

### Power features
- **Command palette** (`Ctrl/⌘+K`) — do anything by typing.
- **Personas** — saved system-prompt profiles; activate one and it drives every reply.
- **Prompt library** + **slash commands** — type `/` for saved prompts, personas, and quick actions.
- **Compare models** — run one prompt on two models side by side; **download each answer** as Markdown.
- **Read aloud** (text-to-speech) + **voice input** (speech-to-text).
- **Themes** — auto dark/light with a manual toggle.
- **Installable PWA** — works offline; "Install app" adds it as a standalone window.
- **WebMCP** — exposes the app's actions as tools for Chrome's AI agent (experimental).
- **Learn** — opens **https://themissingmanual.dev**, a completely free learning resource for anyone who wants to learn programming, software engineering, AI, and other technology topics in clear, human-friendly language. Whether you're a beginner or an experienced developer exploring something new, it's designed to make complex concepts easy to understand.
- **Backup** — export/import everything (conversations + settings) as one JSON file; per-chat export to Markdown.

### Storage & privacy
- Conversations live in **IndexedDB**; settings/keys in `localStorage` — all **on your device**, nothing leaves the browser except calls to the model provider you choose.
- On-device & Ollama are fully local. Cloud calls go only to that provider.

---

## ⌨️ Keyboard shortcuts

| Action | Shortcut |
|---|---|
| Command palette | `Ctrl/⌘ + K` |
| Send / newline | `Enter` / `Shift+Enter` |
| New chat | `Ctrl/⌘ + Shift + O` |
| Toggle sidebar | `Ctrl/⌘ + B` |
| Choose model | `Ctrl/⌘ + M` |
| Compare models | `Alt + C` |
| Library (personas & prompts) | `Alt + P` |
| Slash commands | type `/` |
| Writing tools | `Alt + W` |
| Translate / Voice / Attach | `Alt + R`(regen) · `Alt + V` · `Alt + A` |
| Settings · Export · Theme | `Ctrl/⌘ + ,` · `Ctrl/⌘ + E` · `Alt + T` |
| Stop generating | `Esc` |
| Shortcuts help | `Ctrl/⌘ + /` or `?` |

---

## 📁 Files

| File | Purpose |
|---|---|
| `xchat.html` | The entire app |
| `manifest.json`, `sw.js`, `icon-192.png`, `icon-512.png` | PWA (installable + offline) |
| `launch-ai-chat.bat` | Windows one-click launcher (server + app-mode Chrome) |
| `README.md` | This file |

---

## ⚠️ Notes & limitations
- **On-device AI** requires Chrome Dev/Canary with the flags above, enough disk (~22 GB free) and a capable GPU (>4 GB VRAM).
- **PDF** reading pulls a small library from a CDN the first time (needs internet once); text/code files work fully offline.
- **PWA/offline** needs the app served over `localhost`/`https` (the launcher does this) — not `file://`.
- **Storage is per-device/per-browser** — conversations and keys don't sync across machines.
- Putting it behind a tunnel (e.g. Cloudflare) serves the UI anywhere, but on-device AI runs in the *viewing* browser and `localhost` Ollama points at the *viewer's* machine — cloud providers are the portable option. Add auth (Cloudflare Access) if you expose it.

---
