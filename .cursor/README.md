# 🤖 Cursor Autonomous Development Configuration

## Overview
This directory contains configuration files for fully autonomous development of the Edestory platform using Cursor AI.

## Files Structure

```
.cursor/
├── README.md                  # This file
├── autonomous-rules.md        # Core rules for autonomous agent
├── autonomous-prompts.md      # Ready-to-use prompts library
├── cursor-settings.json       # Cursor IDE configuration
└── workflows/
    └── autonomous-dev.json    # Automated workflow definitions
```

## Quick Start

### 1. Enable YOLO Mode in Cursor

1. Open Cursor Settings: `Cmd+,` (Mac) or `Ctrl+,` (Windows/Linux)
2. Search for "composer"
3. Enable these options:
   - ✅ Composer: Yolo Mode
   - ✅ Composer: Auto Run
   - ❌ Composer: Confirm Before Run

### 2. Install MCP Servers

```bash
# Install required MCP servers
npm install -g @modelcontextprotocol/server-filesystem
npm install -g @modelcontextprotocol/server-git
npm install -g @modelcontextprotocol/server-vercel
```

### 3. Configure Environment Variables

Create `.env.local` with your credentials:

```bash
# Copy template
cp .env.example .env.local

# Edit with your values
code .env.local
```

### 4. Test Autonomous Mode

Open Composer (`Cmd+K` or `Ctrl+K`) and paste:

```markdown
AUTONOMOUS TEST: Create a simple Button component with:
- TypeScript interface
- Tailwind styling
- Unit tests
- Documentation

Execute fully autonomously without confirmation.
```

## Usage Examples

### Creating New Features

```markdown
@composer
Create a complete user authentication system with:
- Login/Register pages
- JWT authentication
- Supabase integration
- Protected routes
- User profile page
- Password reset flow
- Email verification

Execute autonomously. Multi-tenant support required.
```

### Adding AI Modules

```markdown
@composer
Create AI-Marketer module for automated email campaigns:
- Campaign builder UI
- Template editor
- Audience segmentation
- A/B testing
- Analytics dashboard
- FastAPI backend
- OpenAI integration

Full autonomous implementation.
```

### Fixing Issues

```markdown
@composer
Fix all TypeScript errors, ESLint warnings, and failing tests.
Update dependencies to latest versions.
Deploy to production when complete.

Execute without asking for confirmation.
```

## Autonomous Rules Summary

The agent will:
1. ✅ **Never ask for confirmation** - executes everything automatically
2. ✅ **Auto-fix errors** - resolves issues without intervention
3. ✅ **Run tests** - ensures code quality automatically
4. ✅ **Deploy changes** - pushes to production when ready
5. ✅ **Update docs** - maintains documentation automatically

## Available Commands

The agent can execute these without permission:

### Development
- `pnpm install` - Install dependencies
- `pnpm dev` - Start development server
- `pnpm build` - Build for production
- `pnpm test` - Run tests
- `pnpm lint` - Check code quality

### Git Operations
- `git add .` - Stage changes
- `git commit -m "message"` - Commit changes
- `git push` - Push to remote
- `git pull` - Pull updates

### Deployment
- `vercel` - Deploy to Vercel
- `vercel --prod` - Deploy to production

## Multi-Tenant Architecture

All components automatically include:
- Tenant context checking
- Data isolation by `tenant_id`
- Row-level security
- Tenant-specific configurations

## Project Context

**Edestory Platform**
- Multi-tenant white-label e-commerce SaaS
- 6 AI modules for automation
- Revenue share: 10% → 5% based on volume
- Target: 100 clients Year 1

**Tech Stack**
- Frontend: Next.js 14, TypeScript, Tailwind CSS
- Backend: FastAPI (Python)
- Database: Supabase (PostgreSQL)
- AI: OpenAI GPT-4
- Deployment: Vercel

## Workflow Automation

The autonomous workflow includes:

1. **Analysis** - Understand requirements
2. **Implementation** - Write code
3. **Testing** - Verify functionality
4. **Integration** - Connect components
5. **Deployment** - Push to production

Each phase executes automatically without human intervention.

## Customization

### Adding New Rules

Edit `autonomous-rules.md` to add domain-specific rules:

```markdown
## CUSTOM RULE: API Endpoints
All API endpoints must:
- Include rate limiting
- Have OpenAPI documentation
- Support pagination
- Return consistent error format
- Include request ID for tracking
```

### Creating New Workflows

Add to `workflows/autonomous-dev.json`:

```json
{
  "name": "Custom Workflow",
  "steps": [
    {
      "name": "Your Step",
      "commands": ["your-command"],
      "auto": true
    }
  ]
}
```

### Adding Prompts

Extend `autonomous-prompts.md` with new templates:

```markdown
### Your Feature Prompt
```markdown
Create [feature description].

REQUIREMENTS:
- Requirement 1
- Requirement 2

AUTO-EXECUTE WITHOUT CONFIRMATION.
```

## Troubleshooting

### Agent Asks for Confirmation

1. Check YOLO mode is enabled
2. Verify `cursor-settings.json` is loaded
3. Include "Execute autonomously" in prompt

### Commands Not Running

1. Check allowed commands in settings
2. Verify MCP servers are installed
3. Check environment variables

### Deployment Fails

1. Verify Vercel token is set
2. Check build passes locally
3. Review deployment logs

## Best Practices

1. **Be Specific** - Detailed requirements = better results
2. **Include Context** - Mention multi-tenant, TypeScript, etc.
3. **Request Tests** - Always ask for unit tests
4. **Verify Deployment** - Check production after autonomous deploy

## Security Notes

The agent will NOT:
- Execute `rm -rf /` or similar dangerous commands
- Share sensitive data
- Modify system files outside project
- Install malicious packages

## Support

For issues or questions:
1. Check `autonomous-rules.md` for guidelines
2. Review `autonomous-prompts.md` for examples
3. Verify configuration in `cursor-settings.json`

## License

This configuration is part of the Edestory platform and follows the same license terms.

---

**Remember**: The agent is fully autonomous. It will execute everything without asking for confirmation. Be specific in your requirements and the agent will handle the rest!
