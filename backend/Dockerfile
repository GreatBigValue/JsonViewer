FROM oven/bun:latest

WORKDIR /app

# Copy package.json and lockfile first for better caching
COPY package.json bun.lockb* ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy the rest of the source code
COPY . .

# Build the application
RUN bun run build

EXPOSE 3001

# Use the start:dev script in production for better reliability during development
CMD ["bun", "run", "start:dev"]
