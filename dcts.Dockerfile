# Use the official Bun image as a base
FROM oven/bun:1.1-slim

# Set the working directory
WORKDIR /app

# 1. Install system dependencies (MariaDB and unzip)
RUN apt-get update && apt-get install -y \
    mariadb-server \
    mariadb-client \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 2. Download and extract the application
RUN wget https://github.com/hackthedev/dcts-shipping/archive/refs/tags/v1.5.6.6.zip \
    && unzip v1.5.6.6.zip -d . \
    && rm v1.5.6.6.zip \
    && cd dcts-shipping-1.5.6.6

# 3. Install Bun dependencies
RUN bun install

# 4. Expose ports (adjust 3000 if your app uses a different port)
EXPOSE 3000 3306

# 5. Startup script
# Since MariaDB needs to be running for the app to work, 
# we use a shell command to start the DB service before the app.
CMD service mariadb start && bun .
