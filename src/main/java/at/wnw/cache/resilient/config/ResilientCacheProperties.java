package at.wnw.cache.resilient.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import java.time.Duration;
import java.util.Map;

@ConfigurationProperties(prefix = "at.wnw.cache.resilient")
public class ResilientCacheProperties {
    private boolean bufferPersistence = false;
    private String jpaEntityPackage;
    private Duration replayInterval = Duration.ofSeconds(10);
    private Duration defaultTtl = Duration.ofMinutes(5);
    private Map<String, Duration> ttls;

    // getters & setters omitted for brevity
}
