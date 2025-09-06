#!/bin/bash

echo "🧪 Testing MCP Configuration..."

# Test filesystem server
echo "Testing filesystem server..."
npx @modelcontextprotocol/server-filesystem --test

# Test GitHub server (requires token)
if [ ! -z "$GITHUB_TOKEN" ]; then
  echo "Testing GitHub server..."
  npx @modelcontextprotocol/server-github --test
else
  echo "⚠️  GitHub server test skipped (no token)"
fi

# Test PostgreSQL server (requires connection)
if [ ! -z "$DATABASE_URL" ]; then
  echo "Testing PostgreSQL server..."
  npx @modelcontextprotocol/server-postgres --test
else
  echo "⚠️  PostgreSQL server test skipped (no connection)"
fi

echo "✅ MCP test complete!"
