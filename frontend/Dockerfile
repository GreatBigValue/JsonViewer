FROM oven/bun:latest

WORKDIR /app

# Copy package.json and lockfile first for better caching
COPY package.json bun.lockb* ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy the rest of the source code
COPY . .

# Build the application in development mode for easier debugging
RUN bun run build || echo "Build failed, but continuing for development mode"

EXPOSE 3000

# Use development mode for troubleshooting
CMD ["bun", "run", "dev"]
