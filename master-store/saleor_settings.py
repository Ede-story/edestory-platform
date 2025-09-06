"""
Saleor settings for Google Cloud Run deployment
"""

import os
from saleor.settings import *

# Security
DEBUG = False
ALLOWED_HOSTS = [
    "saleor-api-*.a.run.app",
    "api.shop.ede-story.com",
    "localhost",
    "127.0.0.1",
]

# Use environment variables for secrets
SECRET_KEY = os.environ.get("SECRET_KEY", SECRET_KEY)
DATABASE_URL = os.environ.get("DATABASE_URL")

# Database configuration for Cloud SQL
if DATABASE_URL:
    import dj_database_url
    DATABASES = {
        "default": dj_database_url.parse(
            DATABASE_URL,
            conn_max_age=600,
            conn_health_checks=True,
        )
    }

# Redis configuration for Cloud Memorystore
REDIS_URL = os.environ.get("REDIS_URL")
if REDIS_URL:
    CACHES = {
        "default": {
            "BACKEND": "django.core.cache.backends.redis.RedisCache",
            "LOCATION": REDIS_URL,
        }
    }
    
    CELERY_BROKER_URL = REDIS_URL
    CELERY_RESULT_BACKEND = REDIS_URL

# Storage configuration for Google Cloud Storage
DEFAULT_FILE_STORAGE = "storages.backends.gcloud.GoogleCloudStorage"
STATICFILES_STORAGE = "storages.backends.gcloud.GoogleCloudStorage"

GS_BUCKET_NAME = os.environ.get("GS_MEDIA_BUCKET", "edestory-platform-media")
GS_STATIC_BUCKET_NAME = os.environ.get("GS_STATIC_BUCKET", "edestory-platform-static")
GS_DEFAULT_ACL = "publicRead"
GS_QUERYSTRING_AUTH = False

MEDIA_URL = f"https://storage.googleapis.com/{GS_BUCKET_NAME}/"
STATIC_URL = f"https://storage.googleapis.com/{GS_STATIC_BUCKET_NAME}/"

# Email configuration (using SendGrid)
if os.environ.get("SENDGRID_API_KEY"):
    EMAIL_BACKEND = "sendgrid_backend.SendgridBackend"
    SENDGRID_API_KEY = os.environ.get("SENDGRID_API_KEY")
    DEFAULT_FROM_EMAIL = "noreply@shop.ede-story.com"
    SERVER_EMAIL = "server@shop.ede-story.com"

# Saleor specific settings
DEFAULT_CHANNEL_SLUG = "default-channel"
DEFAULT_CURRENCY = "EUR"
DEFAULT_COUNTRY = "ES"

# Payment gateways
PAYMENT_GATEWAYS = {
    "stripe": {
        "module": "saleor.payment.gateways.stripe",
        "config": {
            "public_key": os.environ.get("STRIPE_PUBLISHABLE_KEY"),
            "secret_key": os.environ.get("STRIPE_SECRET_KEY"),
            "webhook_secret": os.environ.get("STRIPE_WEBHOOK_SECRET"),
            "automatic_payment_capture": True,
            "supported_currencies": ["EUR", "USD", "GBP"],
        },
    },
}

# Plugins
PLUGINS = [
    "saleor.plugins.webhook.plugin.WebhookPlugin",
    "saleor.plugins.invoicing.plugin.InvoicingPlugin", 
    "saleor.plugins.admin_email.plugin.AdminEmailPlugin",
    "saleor.plugins.user_email.plugin.UserEmailPlugin",
]

# CORS settings
CORS_ALLOWED_ORIGINS = [
    "https://shop.ede-story.com",
    "https://edestory-shop-*.a.run.app",
    "http://localhost:3000",
    "http://localhost:3002",
]

# Security headers
SECURE_SSL_REDIRECT = True
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SECURE_BROWSER_XSS_FILTER = True
SECURE_CONTENT_TYPE_NOSNIFF = True
X_FRAME_OPTIONS = "SAMEORIGIN"

# Logging
LOGGING = {
    "version": 1,
    "disable_existing_loggers": False,
    "formatters": {
        "verbose": {
            "format": "{levelname} {asctime} {module} {process:d} {thread:d} {message}",
            "style": "{",
        },
    },
    "handlers": {
        "console": {
            "class": "logging.StreamHandler",
            "formatter": "verbose",
        },
    },
    "root": {
        "handlers": ["console"],
        "level": "INFO",
    },
    "loggers": {
        "django": {
            "handlers": ["console"],
            "level": os.getenv("DJANGO_LOG_LEVEL", "INFO"),
            "propagate": False,
        },
        "saleor": {
            "handlers": ["console"],
            "level": os.getenv("SALEOR_LOG_LEVEL", "INFO"),
            "propagate": False,
        },
    },
}

# Performance optimizations
GRAPHQL_QUERY_MAX_COMPLEXITY = 50000
GRAPHQL_QUERY_MAX_DEPTH = 20

# File upload limits
FILE_UPLOAD_MAX_MEMORY_SIZE = 10485760  # 10MB
DATA_UPLOAD_MAX_MEMORY_SIZE = 10485760  # 10MB

# JWT settings
from datetime import timedelta

JWT_TTL_ACCESS = timedelta(minutes=30)
JWT_TTL_REFRESH = timedelta(days=30)

# Internationalization
LANGUAGE_CODE = "es"
LANGUAGES = [
    ("es", "Spanish"),
    ("en", "English"),
    ("ru", "Russian"),
]

TIME_ZONE = "Europe/Madrid"

# Taxes
DEFAULT_TAX_RATE = 21  # Spain VAT

print("🚀 Saleor running on Google Cloud Run with custom settings")