Redis Test Environment
======================

## Overview

This environment provides a Redis key-value store for testing Fess data crawling capabilities.

## Run Redis

```bash
docker compose up -d
```

## Stop Redis

```bash
docker compose down
```

## Redis Server Information

- **Host**: localhost
- **Port**: 6379
- **Password**: redis123
- **Persistence**: AOF (Append Only File) enabled

## Populate Test Data

Connect to Redis and add sample data:

```bash
# Connect to Redis CLI
docker compose exec redis redis-cli -a redis123

# Add sample key-value pairs
127.0.0.1:6379> SET doc:1 "Test document 1 - Redis is an in-memory data structure store"
127.0.0.1:6379> SET doc:2 "Test document 2 - Redis supports various data structures like strings, hashes, lists"
127.0.0.1:6379> SET doc:3 "Test document 3 - Redis can be used as a database, cache, and message broker"
127.0.0.1:6379> SET doc:4 "テストドキュメント4 - Redisは高速なキー・バリューストアです"
127.0.0.1:6379> SET doc:5 "Test document 5 - Redis provides built-in replication and persistence"

# Add hash data structure
127.0.0.1:6379> HSET article:1 title "Redis Introduction" content "Redis is an open source in-memory data structure store" url "http://localhost/article1"
127.0.0.1:6379> HSET article:2 title "Redis Features" content "Redis supports multiple data structures and persistence options" url "http://localhost/article2"

# List all keys
127.0.0.1:6379> KEYS *

# Exit
127.0.0.1:6379> EXIT
```

## Fess Configuration

### Data Store Configuration

Configure a Data Store in Fess with custom implementation:

| Name | Value |
|:-----|:------|
| Handler | Custom Redis DataStore (requires implementation) |
| Parameter | host=localhost<br>port=6379<br>password=redis123<br>database=0<br>keyPattern=doc:* |

**Note**: Redis integration requires custom implementation or plugins. You may need to:
1. Implement a custom DataStore handler for Redis
2. Use Redis client library (Jedis or Lettuce) in the implementation
3. Configure connection pooling for production use

### Example Redis Client Code

```java
// Example Redis connection
Jedis jedis = new Jedis("localhost", 6379);
jedis.auth("redis123");

// Get all keys matching pattern
Set<String> keys = jedis.keys("doc:*");

// Iterate and retrieve values
for (String key : keys) {
    String value = jedis.get(key);
    // Process and index in Fess
}
```

## Manual Redis Operations

### Basic Commands

```bash
# Connect to Redis
docker compose exec redis redis-cli -a redis123

# String operations
SET mykey "myvalue"
GET mykey
DEL mykey

# Check existence
EXISTS mykey

# Set with expiration (seconds)
SETEX tempkey 300 "expires in 5 minutes"

# Increment counter
INCR counter
INCRBY counter 10

# List all keys
KEYS *

# Get database info
INFO
```

### Hash Operations

```bash
# Set hash fields
HSET user:1000 name "John Doe" email "john@example.com" age 30

# Get all hash fields
HGETALL user:1000

# Get specific field
HGET user:1000 name

# Check if field exists
HEXISTS user:1000 email
```

### List Operations

```bash
# Push to list
LPUSH mylist "item1"
RPUSH mylist "item2" "item3"

# Get list items
LRANGE mylist 0 -1

# List length
LLEN mylist
```

## Load Sample Dataset

Use the provided script to load sample data:

```bash
docker compose exec redis sh -c 'redis-cli -a redis123 <<EOF
FLUSHDB
MSET doc:1 "Redis is an in-memory data structure store" \
     doc:2 "Redis supports strings, hashes, lists, sets, and more" \
     doc:3 "Redis provides persistence through RDB and AOF" \
     doc:4 "Redis can be used for caching, session storage, and queues" \
     doc:5 "Redis supports pub/sub messaging patterns"
HSET article:1 title "Getting Started with Redis" content "Redis is easy to install and use" tags "redis,tutorial" created_at "2025-01-01"
HSET article:2 title "Redis Data Types" content "Redis supports various data types for different use cases" tags "redis,datatypes" created_at "2025-01-02"
HSET article:3 title "Redis Persistence" content "Redis offers RDB snapshots and AOF logs" tags "redis,persistence" created_at "2025-01-03"
SAVE
KEYS *
EOF
'
```

## Data Persistence

Redis is configured with AOF (Append Only File) persistence:

- Every write operation is logged to `/data/appendonly.aof`
- Data persists across container restarts
- Use `BGSAVE` command to create RDB snapshots

## Performance Notes

- Redis stores all data in memory for fast access
- Suitable for caching, session storage, and real-time analytics
- For large datasets, consider memory requirements
- Default maxmemory is unlimited (uses all available RAM)

## Connection Testing

```bash
# Test connection
docker compose exec redis redis-cli -a redis123 PING
# Expected output: PONG

# Check Redis version
docker compose exec redis redis-cli -a redis123 INFO SERVER | grep redis_version

# Monitor commands in real-time
docker compose exec redis redis-cli -a redis123 MONITOR
```

## Notes

- Data is persisted in a Docker volume named `redis_data`
- Password authentication is enabled for security
- AOF persistence ensures durability
- Redis uses single-threaded architecture for atomicity
- Suitable for high-performance caching and real-time applications
