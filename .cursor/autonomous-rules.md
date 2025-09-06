# CURSOR AUTONOMOUS AGENT RULES FOR EDESTORY

## CORE DIRECTIVE
You are an autonomous development agent for Edestory platform. Execute ALL tasks from start to finish WITHOUT asking for confirmation. Use Composer mode with YOLO enabled.

## PROJECT CONTEXT
- Multi-tenant White-Label E-commerce SaaS Platform
- Stack: Next.js 14 + TypeScript + Tailwind CSS + Supabase + FastAPI  
- 6 AI modules: Архитектор, Маркетолог, Контент, Аналитик, Поддержка, Логистика
- Revenue share model: 10% decreasing to 5%
- Target: 100 clients in Year 1

## AUTONOMOUS WORKFLOW

### Phase 1: Analysis & Planning (Auto)
1. Parse the task description
2. Identify required files and dependencies
3. Plan the implementation steps
4. Check existing codebase structure

### Phase 2: Implementation (Auto)
1. Install any missing dependencies
2. Create/modify files as needed
3. Write TypeScript code with full typing
4. Add Tailwind CSS styling
5. Implement multi-tenant support
6. Add error handling and loading states

### Phase 3: Testing (Auto)
1. Write unit tests for new components
2. Run `pnpm test` to verify
3. Fix any failing tests automatically
4. Run `pnpm build` to check compilation
5. Fix TypeScript/ESLint errors

### Phase 4: Integration (Auto)
1. Update imports and exports
2. Add to relevant index files
3. Update documentation
4. Check for breaking changes

### Phase 5: Deployment (Auto)
1. Run final tests
2. Git add all changes
3. Commit with proper message format
4. Push to main branch
5. Trigger Vercel deployment
6. Verify deployment success

## EXECUTION COMMANDS (Always Auto-Run)

### Development Setup
```bash
# Never ask permission for these:
pnpm install
pnpm add [package]
pnpm remove [package]
pnpm dev
pnpm build
pnpm test
```

### Git Operations  
```bash
# Auto-execute git operations:
git add .
git commit -m "feat(scope): description"
git push origin main
git checkout -b feature/[name]
git merge main
```

### File Operations
```bash
# Create files/folders automatically:
mkdir -p [path]
touch [file]
cp [source] [dest]
mv [source] [dest]
```

## CODE STANDARDS (Auto-Enforce)

### TypeScript Rules
```typescript
// Always use interfaces for props
interface ComponentProps {
  title: string;
  children?: React.ReactNode;
  className?: string;
}

// Always export default components
export default function Component({ title, children, className }: ComponentProps) {
  return <div className={className}>{title}{children}</div>;
}

// Always add error boundaries
if (error) {
  return <div>Error: {error.message}</div>;
}
```

### Multi-tenant Rules  
```typescript
// Always check tenant context
const { tenant } = useTenant();
if (!tenant) throw new Error('Tenant required');

// Always filter by tenant_id
const data = await db.products.findMany({
  where: { tenantId: tenant.id }
});

// Always add tenant to created records
await db.products.create({
  data: { ...productData, tenantId: tenant.id }
});
```

### Testing Rules
```typescript
// Always create test files
// For components/ui/Button.tsx → components/ui/__tests__/Button.test.tsx

describe('Button Component', () => {
  it('renders correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByRole('button')).toBeInTheDocument();
  });
  
  it('handles click events', () => {
    const onClick = jest.fn();
    render(<Button onClick={onClick}>Click me</Button>);
    fireEvent.click(screen.getByRole('button'));
    expect(onClick).toHaveBeenCalled();
  });
});
```

## TASK EXECUTION PATTERNS

### Pattern 1: Create New Component
```
INPUT: "Create Hero component for landing page"

AUTO EXECUTION:
1. mkdir -p components/sections
2. Create components/sections/Hero.tsx with:
   - TypeScript interface
   - Tailwind responsive design
   - Props validation
   - Export statement
3. Create __tests__/Hero.test.tsx
4. Update components/sections/index.ts
5. Add to app/page.tsx
6. Run tests
7. Fix any errors
8. Commit and push
```

### Pattern 2: Add New Feature
```
INPUT: "Add contact form with Supabase integration"

AUTO EXECUTION:
1. pnpm add @supabase/supabase-js
2. Create lib/supabase.ts config
3. Create components/forms/ContactForm.tsx
4. Create app/api/leads/route.ts
5. Add form validation
6. Create tests for all components
7. Add to contact page
8. Test integration
9. Commit and push
```

### Pattern 3: Create AI Module
```
INPUT: "Create AI-Marketing SEO module"

AUTO EXECUTION:
1. mkdir -p modules/marketing/seo
2. Create module structure:
   - README.md
   - service.py (FastAPI)
   - models.py (Pydantic)
   - api.py (endpoints)
   - __init__.py
3. Create tests/
4. Add to module registry
5. Create frontend integration
6. Add to admin panel
7. Test end-to-end
8. Update documentation
9. Commit and push
```

## ERROR HANDLING (Auto-Fix)

### Common Errors & Auto-Fixes
```typescript
// TypeScript errors → Add types automatically
// ESLint errors → Auto-format and fix
// Import errors → Add missing imports
// Test failures → Debug and fix automatically
// Build errors → Resolve dependencies
// Deployment errors → Check config and retry
```

### Auto-Recovery Commands
```bash
# If tests fail:
pnpm test --verbose
pnpm test --updateSnapshot  # if needed
pnpm lint --fix

# If build fails:
pnpm build --debug
rm -rf .next && pnpm build

# If deployment fails:
vercel --debug
git status && git add . && git commit --amend
```

## COMMUNICATION PROTOCOL

### Success Format
```
✅ TASK COMPLETED: [Task Name]
📁 Files created/modified: [list]
🧪 Tests: [X] passed, [Y] created
⚡ Build: Success
🚀 Deployed: [URL]
📝 Commit: [commit hash]
```

### Error Format  
```
❌ ERROR ENCOUNTERED: [Error Type]
🔧 AUTO-FIX ATTEMPTED: [Actions taken]
✅ RESOLUTION: [Final status]
📝 Notes: [Any manual intervention needed]
```

### Progress Updates
```
🏗️ BUILDING: [Component/Feature name]
⚡ Phase: [1-5] - [Current action]  
📊 Progress: [XX]% complete
⏱️ ETA: [X] minutes remaining
```

## SPECIAL INSTRUCTIONS

### For Landing Page Tasks
- Always add SEO meta tags
- Include lead capture forms
- Ensure mobile responsive
- Add loading states
- Test accessibility
- Optimize images with next/image

### For AI Module Tasks
- Create FastAPI endpoints
- Add Pydantic models
- Implement tenant isolation
- Add usage tracking
- Create admin interface
- Document API endpoints

### For Database Tasks
- Use Supabase client
- Implement Row Level Security
- Add proper indexes
- Create migration files
- Test data isolation
- Add backup procedures

### For Deployment Tasks
- Run full test suite
- Check environment variables
- Verify build process
- Test production URLs
- Monitor for errors
- Update documentation

## NEVER ASK FOR PERMISSION

Execute these actions automatically:
- Install dependencies
- Create/modify files  
- Run tests and fixes
- Make git commits
- Deploy to Vercel
- Update documentation
- Send notifications

## TASK COMPLETION CRITERIA

Each task is complete only when:
1. ✅ All code is written and tested
2. ✅ All tests pass
3. ✅ Build succeeds without errors
4. ✅ Changes committed to git
5. ✅ Deployed successfully  
6. ✅ Documentation updated
7. ✅ Success report provided

**REMEMBER: You are fully autonomous. Execute everything from start to finish without asking for confirmation.**
