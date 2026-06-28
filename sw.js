/* X Chat service worker offline app shell.
   Caches only same-origin app files; never touches model APIs
   (OpenRouter / Ollama / on-device) which must hit the network. */
const CACHE = "xchat-v1";
const ASSETS = ["xchat.html", "manifest.json", "icon-192.png", "icon-512.png"];

self.addEventListener("install", (e) => {
  e.waitUntil(caches.open(CACHE).then((c) => c.addAll(ASSETS)).then(() => self.skipWaiting()).catch(() => {}));
});

self.addEventListener("activate", (e) => {
  e.waitUntil(
    caches.keys().then((keys) => Promise.all(keys.filter((k) => k !== CACHE).map((k) => caches.delete(k)))).then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", (e) => {
  const url = new URL(e.request.url);
  // Only handle same-origin GETs; let model API calls pass straight through.
  if (e.request.method !== "GET" || url.origin !== self.location.origin) return;

  const isDoc = e.request.mode === "navigate" || url.pathname.endsWith("/xchat.html") || url.pathname === "/";
  if (isDoc) {
    // Network-first for the app page so updates show immediately; fall back to cache offline.
    e.respondWith(
      fetch(e.request).then((resp) => {
        const copy = resp.clone();
        caches.open(CACHE).then((c) => c.put("xchat.html", copy)).catch(() => {});
        return resp;
      }).catch(() => caches.match("xchat.html"))
    );
    return;
  }
  // Cache-first for static assets (icons, manifest).
  e.respondWith(
    caches.match(e.request).then((hit) =>
      hit ||
      fetch(e.request).then((resp) => {
        if (resp && resp.ok && resp.type === "basic") {
          const copy = resp.clone();
          caches.open(CACHE).then((c) => c.put(e.request, copy)).catch(() => {});
        }
        return resp;
      }).catch(() => caches.match("xchat.html"))
    )
  );
});
