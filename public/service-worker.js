const CACHE_NAME = 'crm-manager-cache-v1';
const urlsToCache = [
    '/',
    '/dashboard',
    '/campaigns',
    '/clients',
    '/appointments',
    '/assets/application-e445755d41f50e6c5c7a123de3397343bf5b58d59e70f8457561c73c852d3671.css',
    '/assets/application-f0ada170118b9e00ae7036ef568c0363868f3cacf7a61b7b42a137357fe50b76.js',
    '/icons/icon-192x192.png',
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return Promise.all(
        urlsToCache.map((url) => {
          return cache.add(url).catch((error) => {
            console.warn('Failed to cache:', url, error);
          });
        })
      );
    })
  );
});

self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      return response || fetch(event.request).catch(() => {
        return caches.match('/fallback-page.html'); // Optional fallback page
      });
    })
  );
});
