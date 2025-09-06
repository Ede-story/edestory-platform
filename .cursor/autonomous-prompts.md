# AUTONOMOUS PROMPTS FOR EDESTORY DEVELOPMENT

## MASTER PROMPT FOR COMPOSER MODE

```markdown
AUTONOMOUS TASK EXECUTION FOR EDESTORY

Execute this task completely autonomously using Composer mode:

TASK: [Task description]

CONTEXT: 
- Edestory multi-tenant e-commerce SaaS platform
- White-label solution with AI modules
- Stack: Next.js 14 + TypeScript + Tailwind CSS + Supabase + FastAPI

REQUIREMENTS:
✅ Full TypeScript typing
✅ Multi-tenant architecture (tenant_id filtering)
✅ Tailwind CSS responsive styling
✅ Unit and integration tests
✅ Auto-commit and deploy
✅ Documentation updates

EXECUTION STEPS (DO ALL AUTOMATICALLY):
1. Analyze requirements and plan implementation
2. Install any needed dependencies with pnpm
3. Create/modify all required files
4. Write comprehensive tests
5. Run tests and fix any failures
6. Build and fix any compilation errors
7. Commit with semantic versioning
8. Deploy to Vercel
9. Verify deployment success
10. Provide completion report

DO NOT ASK FOR CONFIRMATION. Execute everything automatically.

START IMPLEMENTATION NOW.
```

## COMPONENT CREATION PROMPTS

### Landing Page Component
```markdown
Create a new landing page component for Edestory.

REQUIREMENTS:
- Hero section with CTA
- Features showcase (6 AI modules)
- Pricing table (10% → 5% revenue share)
- Client testimonials
- Contact form with Supabase integration
- SEO optimized meta tags
- Mobile responsive design
- Loading states and error handling

AUTO-EXECUTE ALL STEPS. NO CONFIRMATIONS NEEDED.
```

### Dashboard Component
```markdown
Create admin dashboard for tenant management.

REQUIREMENTS:
- Tenant switcher component
- Analytics overview cards
- Revenue charts
- User management table
- Settings panel
- Real-time updates via Supabase
- Role-based access control
- Export functionality

IMPLEMENT FULLY AUTONOMOUSLY.
```

### E-commerce Component
```markdown
Create product catalog component with filters.

REQUIREMENTS:
- Grid/List view toggle
- Category filters
- Price range slider
- Sort functionality
- Pagination or infinite scroll
- Quick view modal
- Add to cart functionality
- Wishlist support
- Multi-tenant data isolation

EXECUTE WITHOUT ASKING PERMISSION.
```

## AI MODULE PROMPTS

### AI Architect Module
```markdown
Create AI-Архитектор module for store structure optimization.

BACKEND (FastAPI):
- /api/architect/analyze - Analyze current structure
- /api/architect/recommend - Get recommendations
- /api/architect/apply - Apply changes
- Pydantic models for validation
- OpenAI integration
- Tenant isolation

FRONTEND:
- Configuration panel
- Preview changes UI
- Apply changes workflow
- Progress tracking
- Rollback capability

AUTO-IMPLEMENT EVERYTHING.
```

### AI Marketer Module
```markdown
Create AI-Маркетолог module for campaign automation.

FEATURES:
- Campaign creation wizard
- Audience segmentation
- A/B testing setup
- Email template generator
- Social media scheduler
- ROI tracking
- Multi-channel support

FULL AUTONOMOUS IMPLEMENTATION REQUIRED.
```

### AI Content Module
```markdown
Create AI-Контент module for content generation.

CAPABILITIES:
- Product descriptions
- Blog posts
- Email newsletters
- Social media posts
- SEO meta descriptions
- Image alt texts
- Translation support
- Brand voice customization

BUILD COMPLETELY WITHOUT CONFIRMATION.
```

## DATABASE SCHEMA PROMPTS

### Multi-tenant Schema
```sql
-- Create this schema autonomously in Supabase

CREATE TABLE tenants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  domain VARCHAR(255) UNIQUE,
  settings JSONB DEFAULT '{}',
  subscription_tier VARCHAR(50),
  revenue_share_percentage DECIMAL(5,2) DEFAULT 10.00,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID REFERENCES tenants(id) ON DELETE CASCADE,
  email VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'user',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(tenant_id, email)
);

-- Add RLS policies automatically
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY tenant_isolation ON users
  USING (tenant_id = current_setting('app.current_tenant')::uuid);
```

## TESTING PROMPTS

### Unit Test Template
```typescript
// Auto-generate tests like this for every component

import { render, screen, fireEvent, waitFor } from '@testing-library/react';
import { ComponentName } from './ComponentName';
import { mockTenant } from '@/tests/mocks';

describe('ComponentName', () => {
  beforeEach(() => {
    // Setup tenant context
    jest.mock('@/hooks/useTenant', () => ({
      useTenant: () => ({ tenant: mockTenant })
    }));
  });

  it('renders correctly with tenant context', () => {
    render(<ComponentName />);
    expect(screen.getByTestId('component-name')).toBeInTheDocument();
  });

  it('handles user interactions', async () => {
    render(<ComponentName />);
    const button = screen.getByRole('button');
    fireEvent.click(button);
    await waitFor(() => {
      expect(screen.getByText('Expected Result')).toBeInTheDocument();
    });
  });

  it('displays error states properly', () => {
    render(<ComponentName error="Test error" />);
    expect(screen.getByText('Test error')).toBeInTheDocument();
  });

  it('shows loading state', () => {
    render(<ComponentName loading />);
    expect(screen.getByTestId('loading-spinner')).toBeInTheDocument();
  });
});
```

### E2E Test Template
```typescript
// Auto-generate E2E tests with Playwright

import { test, expect } from '@playwright/test';

test.describe('Feature: ComponentName', () => {
  test.beforeEach(async ({ page }) => {
    // Setup tenant context
    await page.goto('/login');
    await page.fill('[name="email"]', 'test@tenant.com');
    await page.fill('[name="password"]', 'password');
    await page.click('[type="submit"]');
    await page.waitForURL('/dashboard');
  });

  test('completes user flow successfully', async ({ page }) => {
    await page.goto('/feature-page');
    await page.click('[data-testid="action-button"]');
    await expect(page.locator('[data-testid="success-message"]')).toBeVisible();
  });

  test('handles errors gracefully', async ({ page }) => {
    await page.route('/api/endpoint', route => 
      route.fulfill({ status: 500 })
    );
    await page.goto('/feature-page');
    await expect(page.locator('[data-testid="error-message"]')).toBeVisible();
  });
});
```

## DEPLOYMENT PROMPTS

### Vercel Deployment
```bash
# Auto-execute these commands for deployment

# 1. Build check
pnpm build

# 2. Test check  
pnpm test

# 3. Lint check
pnpm lint

# 4. Deploy to Vercel
vercel --prod

# 5. Verify deployment
curl -I https://edestory-platform.vercel.app

# 6. Run smoke tests
pnpm test:e2e --headed
```

### Environment Setup
```bash
# Auto-create .env.local with required variables

cat > .env.local << EOF
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-key

# Database
DATABASE_URL=postgresql://user:password@host:5432/database

# Auth
NEXTAUTH_URL=http://localhost:3000
NEXTAUTH_SECRET=generate-secret-here

# AI Services
OPENAI_API_KEY=your-openai-key

# Analytics
NEXT_PUBLIC_GA_ID=your-ga-id

# Multi-tenant
DEFAULT_TENANT_ID=default-tenant-uuid
EOF
```

## FIX PROMPTS

### TypeScript Error Fix
```markdown
AUTO-FIX TYPESCRIPT ERRORS:

1. Run `pnpm tsc --noEmit` to identify errors
2. For each error:
   - Add missing types/interfaces
   - Import required types
   - Fix type mismatches
   - Add generic types where needed
3. Re-run until no errors
4. Commit fixes

EXECUTE AUTOMATICALLY WITHOUT CONFIRMATION.
```

### Build Error Fix
```markdown
AUTO-FIX BUILD ERRORS:

1. Identify error from build output
2. Common fixes:
   - Missing dependencies → pnpm add [package]
   - Import errors → Fix import paths
   - Module errors → Update next.config.js
   - Type errors → Add type declarations
3. Rebuild and verify
4. Deploy if successful

DO NOT ASK FOR PERMISSION.
```

## OPTIMIZATION PROMPTS

### Performance Optimization
```markdown
OPTIMIZE COMPONENT PERFORMANCE:

1. Add React.memo for pure components
2. Use useMemo for expensive computations
3. Implement useCallback for event handlers
4. Add lazy loading for routes
5. Optimize images with next/image
6. Add loading skeletons
7. Implement virtual scrolling for lists
8. Run Lighthouse and fix issues

IMPLEMENT ALL OPTIMIZATIONS AUTOMATICALLY.
```

### Bundle Size Optimization
```markdown
REDUCE BUNDLE SIZE:

1. Analyze with `pnpm analyze`
2. Tree-shake unused code
3. Dynamic import heavy components
4. Optimize imports (specific vs default)
5. Compress images
6. Remove unused dependencies
7. Enable gzip/brotli compression
8. Verify reduction

EXECUTE WITHOUT CONFIRMATION.
```

## DOCUMENTATION PROMPTS

### API Documentation
```markdown
GENERATE API DOCUMENTATION:

Create comprehensive API docs including:
- Endpoint descriptions
- Request/response schemas
- Authentication requirements
- Rate limiting info
- Error codes
- Example requests
- Multi-tenant considerations

Format as OpenAPI/Swagger spec.
AUTO-GENERATE WITHOUT ASKING.
```

### Component Documentation
```markdown
DOCUMENT REACT COMPONENTS:

For each component, add:
- Props interface with JSDoc
- Usage examples
- Storybook stories
- README with screenshots
- Accessibility notes
- Performance considerations
- Testing guidelines

CREATE AUTOMATICALLY.
```

## WORKFLOW AUTOMATION PROMPTS

### Daily Tasks
```markdown
EXECUTE DAILY MAINTENANCE:

1. Update dependencies (minor/patch)
2. Run security audit
3. Check for lint errors
4. Verify all tests pass
5. Check deployment status
6. Review error logs
7. Update documentation
8. Commit any fixes

RUN AUTONOMOUSLY EVERY DAY.
```

### Release Process
```markdown
AUTOMATED RELEASE PROCESS:

1. Run full test suite
2. Update CHANGELOG.md
3. Bump version in package.json
4. Create git tag
5. Build production bundle
6. Deploy to staging
7. Run E2E tests
8. Deploy to production
9. Create GitHub release
10. Notify team

EXECUTE ENTIRE PROCESS WITHOUT INTERVENTION.
```

## REMEMBER

**ALL PROMPTS SHOULD BE EXECUTED AUTONOMOUSLY**
- No confirmation requests
- Auto-fix all errors
- Complete all steps
- Deploy automatically
- Document everything
- Report completion

**YOU HAVE FULL PERMISSION TO:**
- Create/modify any files
- Install any dependencies
- Run any commands
- Deploy to production
- Update documentation
- Fix any issues

**EXECUTE IMMEDIATELY WITHOUT ASKING**
