-- Instagram Competitor Analysis Database Schema
-- For PostgreSQL

-- Create database
CREATE DATABASE IF NOT EXISTS instagram_trends;

-- Use the database
\c instagram_trends;

-- Main competitors table
CREATE TABLE IF NOT EXISTS competitors (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) UNIQUE NOT NULL,
    full_name VARCHAR(255),
    profile_url VARCHAR(500),
    bio TEXT,
    website VARCHAR(500),
    email VARCHAR(255),
    phone VARCHAR(50),
    
    -- Metrics
    followers_count INTEGER DEFAULT 0,
    following_count INTEGER DEFAULT 0,
    posts_count INTEGER DEFAULT 0,
    engagement_rate DECIMAL(5,2),
    avg_likes INTEGER DEFAULT 0,
    avg_comments INTEGER DEFAULT 0,
    
    -- Classification
    category VARCHAR(100),
    is_verified BOOLEAN DEFAULT FALSE,
    is_business BOOLEAN DEFAULT FALSE,
    business_category VARCHAR(100),
    
    -- Geo data
    detected_region VARCHAR(50),
    region_confidence INTEGER,
    location VARCHAR(255),
    country VARCHAR(100),
    city VARCHAR(100),
    timezone VARCHAR(50),
    
    -- Scoring
    relevance_score INTEGER DEFAULT 0,
    growth_score INTEGER DEFAULT 0,
    engagement_score INTEGER DEFAULT 0,
    
    -- Metadata
    first_seen_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    analysis_count INTEGER DEFAULT 1,
    is_active BOOLEAN DEFAULT TRUE,
    
    -- Indexes
    INDEX idx_username (username),
    INDEX idx_region (detected_region),
    INDEX idx_followers (followers_count),
    INDEX idx_relevance (relevance_score),
    INDEX idx_updated (last_updated)
);

-- Historical metrics table (for trend tracking)
CREATE TABLE IF NOT EXISTS competitor_metrics_history (
    id SERIAL PRIMARY KEY,
    competitor_id INTEGER REFERENCES competitors(id) ON DELETE CASCADE,
    snapshot_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    followers_count INTEGER,
    following_count INTEGER,
    posts_count INTEGER,
    engagement_rate DECIMAL(5,2),
    
    -- Growth metrics
    followers_change INTEGER,
    followers_change_percent DECIMAL(5,2),
    posts_added INTEGER,
    
    INDEX idx_competitor (competitor_id),
    INDEX idx_date (snapshot_date)
);

-- Posts/Content analysis table
CREATE TABLE IF NOT EXISTS competitor_posts (
    id SERIAL PRIMARY KEY,
    competitor_id INTEGER REFERENCES competitors(id) ON DELETE CASCADE,
    post_id VARCHAR(255) UNIQUE,
    post_url VARCHAR(500),
    
    -- Content details
    caption TEXT,
    media_type VARCHAR(50), -- photo, video, carousel, reel
    media_url TEXT,
    thumbnail_url TEXT,
    
    -- Metrics
    likes_count INTEGER DEFAULT 0,
    comments_count INTEGER DEFAULT 0,
    shares_count INTEGER DEFAULT 0,
    saves_count INTEGER DEFAULT 0,
    engagement_rate DECIMAL(5,2),
    
    -- Timing
    posted_at TIMESTAMP,
    scraped_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_competitor_post (competitor_id),
    INDEX idx_posted (posted_at),
    INDEX idx_engagement (engagement_rate)
);

-- Hashtags tracking
CREATE TABLE IF NOT EXISTS hashtags (
    id SERIAL PRIMARY KEY,
    hashtag VARCHAR(255) UNIQUE NOT NULL,
    usage_count INTEGER DEFAULT 1,
    first_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_seen TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    trending_score INTEGER DEFAULT 0,
    
    INDEX idx_hashtag (hashtag),
    INDEX idx_trending (trending_score)
);

-- Many-to-many relationship: competitors and hashtags
CREATE TABLE IF NOT EXISTS competitor_hashtags (
    competitor_id INTEGER REFERENCES competitors(id) ON DELETE CASCADE,
    hashtag_id INTEGER REFERENCES hashtags(id) ON DELETE CASCADE,
    usage_count INTEGER DEFAULT 1,
    last_used TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    PRIMARY KEY (competitor_id, hashtag_id)
);

-- Trends analysis results
CREATE TABLE IF NOT EXISTS trend_reports (
    id SERIAL PRIMARY KEY,
    report_id VARCHAR(100) UNIQUE NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    -- Summary data
    total_competitors_analyzed INTEGER,
    date_range_start DATE,
    date_range_end DATE,
    
    -- Top findings (stored as JSON)
    top_hashtags JSONB,
    top_content_types JSONB,
    fastest_growing JSONB,
    regional_breakdown JSONB,
    recommendations JSONB,
    
    -- Report metadata
    requested_by VARCHAR(255),
    source_account VARCHAR(255),
    report_type VARCHAR(50), -- 'competitor_analysis', 'trend_watch', 'growth_analysis'
    
    INDEX idx_report_id (report_id),
    INDEX idx_generated (generated_at)
);

-- Analysis sessions tracking
CREATE TABLE IF NOT EXISTS analysis_sessions (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(100) UNIQUE NOT NULL,
    started_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP,
    
    -- Input parameters
    source_instagram_url VARCHAR(500),
    source_username VARCHAR(255),
    regions_analyzed TEXT[], -- Array of regions
    max_competitors INTEGER,
    
    -- Results
    competitors_found INTEGER DEFAULT 0,
    new_competitors_added INTEGER DEFAULT 0,
    existing_competitors_updated INTEGER DEFAULT 0,
    
    -- Status
    status VARCHAR(50) DEFAULT 'running', -- 'running', 'completed', 'failed'
    error_message TEXT,
    
    INDEX idx_session (session_id),
    INDEX idx_status (status)
);

-- Regional statistics view
CREATE OR REPLACE VIEW regional_statistics AS
SELECT 
    detected_region,
    COUNT(*) as competitor_count,
    AVG(followers_count) as avg_followers,
    AVG(engagement_rate) as avg_engagement,
    MAX(followers_count) as max_followers,
    COUNT(CASE WHEN is_verified THEN 1 END) as verified_count
FROM competitors
WHERE is_active = TRUE
GROUP BY detected_region;

-- Top competitors view
CREATE OR REPLACE VIEW top_competitors AS
SELECT 
    username,
    full_name,
    followers_count,
    engagement_rate,
    detected_region,
    relevance_score,
    is_verified,
    profile_url
FROM competitors
WHERE is_active = TRUE
ORDER BY relevance_score DESC, followers_count DESC
LIMIT 100;

-- Trending hashtags view
CREATE OR REPLACE VIEW trending_hashtags AS
SELECT 
    h.hashtag,
    h.usage_count,
    h.trending_score,
    COUNT(DISTINCT ch.competitor_id) as used_by_competitors,
    MAX(ch.last_used) as last_used
FROM hashtags h
LEFT JOIN competitor_hashtags ch ON h.id = ch.hashtag_id
GROUP BY h.id, h.hashtag, h.usage_count, h.trending_score
ORDER BY h.trending_score DESC, h.usage_count DESC
LIMIT 50;

-- Growth tracking function
CREATE OR REPLACE FUNCTION update_competitor_metrics()
RETURNS TRIGGER AS $$
BEGIN
    -- Insert historical record
    INSERT INTO competitor_metrics_history (
        competitor_id,
        followers_count,
        following_count,
        posts_count,
        engagement_rate,
        followers_change,
        followers_change_percent
    )
    SELECT 
        NEW.id,
        NEW.followers_count,
        NEW.following_count,
        NEW.posts_count,
        NEW.engagement_rate,
        NEW.followers_count - OLD.followers_count,
        CASE 
            WHEN OLD.followers_count > 0 
            THEN ((NEW.followers_count - OLD.followers_count)::DECIMAL / OLD.followers_count) * 100
            ELSE 0
        END;
    
    -- Update last_updated timestamp
    NEW.last_updated = CURRENT_TIMESTAMP;
    NEW.analysis_count = OLD.analysis_count + 1;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for metrics updates
CREATE TRIGGER competitor_metrics_update
BEFORE UPDATE ON competitors
FOR EACH ROW
WHEN (OLD.followers_count IS DISTINCT FROM NEW.followers_count)
EXECUTE FUNCTION update_competitor_metrics();

-- Sample queries for reporting

-- Get top competitors by region
-- SELECT * FROM competitors 
-- WHERE detected_region = 'USA' 
-- ORDER BY relevance_score DESC 
-- LIMIT 25;

-- Get growth leaders
-- SELECT 
--     c.username,
--     c.followers_count,
--     cmh.followers_change,
--     cmh.followers_change_percent
-- FROM competitors c
-- JOIN competitor_metrics_history cmh ON c.id = cmh.competitor_id
-- WHERE cmh.snapshot_date > NOW() - INTERVAL '7 days'
-- ORDER BY cmh.followers_change_percent DESC
-- LIMIT 10;

-- Get trending hashtags by region
-- SELECT 
--     h.hashtag,
--     c.detected_region,
--     COUNT(*) as usage_count
-- FROM hashtags h
-- JOIN competitor_hashtags ch ON h.id = ch.hashtag_id
-- JOIN competitors c ON ch.competitor_id = c.id
-- WHERE c.detected_region IN ('USA', 'UK')
-- GROUP BY h.hashtag, c.detected_region
-- ORDER BY usage_count DESC;