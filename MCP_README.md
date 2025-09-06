# MCP (Model Context Protocol) Setup for Edestory Platform

## Overview
This project is configured with MCP to enhance AI-assisted development capabilities.

## Installed MCP Servers

### Standard Servers
- **filesystem**: File system operations within the project
- **github**: GitHub integration for repository management
- **postgres**: PostgreSQL database operations for Saleor
- **puppeteer**: Web browser automation for testing
- **memory**: Persistent memory across sessions

### Custom E-commerce Servers
- **saleor**: Saleor GraphQL API integration
- **n8n**: Workflow automation integration
- **aliexpress**: AliExpress dropshipping integration

## Configuration

1. Copy `.env.mcp.example` to `.env.mcp` and fill in your credentials:
   ```bash
   cp .env.mcp.example .env.mcp
   ```

2. Edit `.env.mcp` with your actual API keys and tokens

3. Restart Claude Code to apply MCP configuration

## Usage

MCP servers are automatically available in Claude Code. You can:
- Query Saleor products and orders
- Trigger n8n workflows
- Search and import AliExpress products
- Access PostgreSQL database
- Interact with GitHub repositories

## Testing

Run the test script to verify MCP configuration:
```bash
./scripts/test-mcp.sh
```

## Troubleshooting

If MCP servers are not working:
1. Check that all npm packages are installed
2. Verify environment variables in `.env.mcp`
3. Restart Claude Code
4. Check logs in `~/.config/claude/logs/`

## Custom Server Development

To add new MCP servers:
1. Create a new server file in `mcp-servers/`
2. Add server configuration to `~/.config/claude/mcp_config.json`
3. Install required npm packages
4. Restart Claude Code
