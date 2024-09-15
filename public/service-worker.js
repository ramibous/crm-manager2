const CACHE_NAME = 'crm-manager-cache-v1';
const urlsToCache = [
    '/',                          // Cache the home page
    '/dashboard',                 // Cache the dashboard
    '/campaigns',                 // Cache campaigns page
    '/clients',                   // Cache clients page
    '/appointments',              // Cache appointments page
    '/assets/application.css',    // Update this to your correct CSS path
    '/assets/application.js',     // Update this to your correct JS path
    '/icons/icon-192x192.png',    // Cache the app icon
    '/fallback-page.html',        // Optional fallback page when offline
];

// Install event - caching static assets
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(urlsToCache).catch((error) => {
        console.warn('Failed to cache:', error);
      });
    })
  );
  console.log('Service worker installed');
});

// Activate event - cleaning up old caches
self.addEventListener('activate', (event) => {
  const cacheWhitelist = [CACHE_NAME];
  event.waitUntil(
    caches.keys().then((cacheNames) => {
      return Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheWhitelist.indexOf(cacheName) === -1) {
            return caches.delete(cacheName);  // Delete old cache
          }
        })
      );
    })
  );
  console.log('Service worker activated');
});

// Fetch event - serving cached content if available
self.addEventListener('fetch', (event) => {
  event.respondWith(
    caches.match(event.request).then((response) => {
      // Return cached response if available, else fetch from network
      return response || fetch(event.request).catch(() => {
        // Return fallback page if offline and request fails
        return caches.match('/fallback-page.html');
      });
    })
  );
  console.log('Service worker intercepting fetch request for:', event.request.url);
});
