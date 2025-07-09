## Project Overview

This extension provides a resilient, provider-agnostic Spring Cache integration (targeting Redis via Lettuce by default) that:

- **Fails soft** when the cache is unavailable (reads fall back to executing the method, writes/evicts are buffered).
- **Replays** buffered cache operations in strict FIFO order upon reconnect.
- Supports **per-cache** default TTLs and **per-entry** TTL overrides via a `cacheExpireIn: Duration` field on cached objects.
- Hooks into **Spring Boot Actuator** to keep the application `UP` even when the cache provider is down (for Kubernetes readiness).

[...]

(See the full README content in your editor; it’s already updated for **at.wnw** coordinates.)
