#!/usr/bin/env bash
set -e

# 1) Root project folder (run this inside an empty directory)
mkdir -p src/{main,test}/{java,resources}

# 2) Create pom.xml
cat > pom.xml <<'EOF'
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>
  <groupId>at.wnw</groupId>
  <artifactId>cache-resilient</artifactId>
  <version>0.1.0-SNAPSHOT</version>

  <properties>
    <java.version>21</java.version>
    <spring.boot.version>3.5.0</spring.boot.version>
  </properties>

  <dependencyManagement>
    <dependencies>
      <dependency>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-dependencies</artifactId>
        <version>${spring.boot.version}</version>
        <type>pom</type>
        <scope>import</scope>
      </dependency>
    </dependencies>
  </dependencyManagement>

  <dependencies>
    <!-- Core -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-actuator</artifactId>
    </dependency>
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-data-jpa</artifactId>
    </dependency>
    <dependency>
      <groupId>io.lettuce</groupId>
      <artifactId>lettuce-core</artifactId>
    </dependency>

    <!-- Logging & Metrics -->
    <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-api</artifactId>
    </dependency>
    <dependency>
      <groupId>io.micrometer</groupId>
      <artifactId>micrometer-core</artifactId>
    </dependency>

    <!-- JCache API -->
    <dependency>
      <groupId>javax.cache</groupId>
      <artifactId>cache-api</artifactId>
      <version>1.1.1</version>
    </dependency>

    <!-- Testing -->
    <dependency>
      <groupId>org.springframework.boot</groupId>
      <artifactId>spring-boot-starter-test</artifactId>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.testcontainers</groupId>
      <artifactId>redis</artifactId>
      <version>1.18.3</version>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.mockito</groupId>
      <artifactId>mockito-core</artifactId>
      <scope>test</scope>
    </dependency>
    <dependency>
      <groupId>org.assertj</groupId>
      <artifactId>assertj-core</artifactId>
      <scope>test</scope>
    </dependency>
  </dependencies>

  <build>
    <plugins>
      <plugin>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-maven-plugin</artifactId>
      </plugin>
      <plugin>
        <groupId>org.apache.maven.plugins</groupId>
        <artifactId>maven-compiler-plugin</artifactId>
        <configuration>
          <source>${java.version}</source>
          <target>${java.version}</target>
        </configuration>
      </plugin>
    </plugins>
  </build>
</project>
EOF

# 3) Create package dirs
BASE_PKG=at/wnw/cache/resilient
for sub in config manager decorator buffer/inmemory buffer/jpa health ttl util; do
  mkdir -p src/main/java/$BASE_PKG/$sub
done
mkdir -p src/test/java/$BASE_PKG/buffer/inmemory

# 4) README.md
cat > README.md <<'EOF'
## Project Overview

This extension provides a resilient, provider-agnostic Spring Cache integration (targeting Redis via Lettuce by default) that:

- **Fails soft** when the cache is unavailable (reads fall back to executing the method, writes/evicts are buffered).
- **Replays** buffered cache operations in strict FIFO order upon reconnect.
- Supports **per-cache** default TTLs and **per-entry** TTL overrides via a `cacheExpireIn: Duration` field on cached objects.
- Hooks into **Spring Boot Actuator** to keep the application `UP` even when the cache provider is down (for Kubernetes readiness).

[...]

(See the full README content in your editor; it’s already updated for **at.wnw** coordinates.)
EOF

# 5) Stub a single example class (you can repeat for others)
cat > src/main/java/$BASE_PKG/config/ResilientCacheProperties.java <<'EOF'
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
EOF

# (…similarly stub out AutoConfiguration, Manager, Decorator, Buffer, TTL, HealthIndicator…)

echo "✅ Scaffold generated. Now:"
echo "   git init"
echo "   git add ."
echo "   git commit -m 'Initial resilient-cache scaffold'"
echo "   git branch -M main"
echo "   git remote add origin git@github.com:YOUR_USER/cache-resilient.git"
echo "   git push -u origin main"

