# Use the official Bun image as a base
FROM oven/bun:1.1-slim

# Set the working directory
WORKDIR /app

# 1. Install system dependencies
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 2. Download and extract the application
# We use --strip-components=1 if it were a tar, but since it's a zip, 
# we'll move the contents manually to keep the WORKDIR clean.
RUN wget https://github.com/hackthedev/dcts-shipping/archive/refs/tags/v1.5.6.6.zip \
    && unzip v1.5.6.6.zip \
    && mv dcts-shipping-1.5.6.6/* . \
    && mv dcts-shipping-1.5.6.6/.* . 2>/dev/null || true \
    && rm -rf dcts-shipping-1.5.6.6 v1.5.6.6.zip

# 3. Install Bun dependencies
# Now that package.json is in /app, this will work
RUN bun install

# 4. Expose ports
EXPOSE 3000 3306

# 5. Startup script
# Ensure we are in the right spot and start the services
CMD service mariadb start && bun .
