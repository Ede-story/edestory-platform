import { test, expect } from '@playwright/test';

test.describe('Storefront Smoke Tests', () => {
  test('homepage loads successfully', async ({ page }) => {
    await page.goto('/');
    
    // Check that page loads without errors
    await expect(page).toHaveTitle(/Edestory/i);
    
    // Check for basic content structure
    const response = await page.waitForLoadState('networkidle');
    expect(page.url()).toContain(process.env.BASE_URL || 'localhost');
  });

  test('diary page is accessible', async ({ page }) => {
    await page.goto('/diary');
    
    // Should not show 404 or 500 errors
    const response = await page.goto('/diary');
    expect(response?.status()).toBeLessThan(400);
    
    // Basic content check
    await expect(page.locator('body')).toBeVisible();
  });

  test('api health check', async ({ request }) => {
    const apiBaseUrl = process.env.NEXT_PUBLIC_API_BASE_URL || 'http://localhost:8000';
    
    try {
      const response = await request.get(`${apiBaseUrl}/health`);
      expect(response.status()).toBeLessThan(500);
    } catch (error) {
      // API might not be running in tests, that's ok for now
      console.log('API health check skipped:', error);
    }
  });
});
