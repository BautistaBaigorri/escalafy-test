-- ============================================
-- Multi-Channel Reporting — Schema & Seed Data
-- ============================================

DROP TABLE IF EXISTS store_data;
DROP TABLE IF EXISTS google_ads_data;
DROP TABLE IF EXISTS meta_ads_data;
DROP TABLE IF EXISTS organization;

-- ============================================
-- Schema
-- ============================================

CREATE TABLE organization (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    meta_account_id VARCHAR(100) NOT NULL,
    google_account_id VARCHAR(100) NOT NULL,
    store_id VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE meta_ads_data (
    id SERIAL PRIMARY KEY,
    account_id VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    spend DECIMAL(12, 2) NOT NULL,
    impressions INTEGER NOT NULL
);

CREATE TABLE google_ads_data (
    id SERIAL PRIMARY KEY,
    account_id VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    spend DECIMAL(12, 2) NOT NULL,
    impressions INTEGER NOT NULL
);

CREATE TABLE store_data (
    id SERIAL PRIMARY KEY,
    store_id VARCHAR(100) NOT NULL,
    date DATE NOT NULL,
    revenue DECIMAL(12, 2) NOT NULL,
    orders INTEGER NOT NULL,
    fees DECIMAL(12, 2) NOT NULL
);

-- ============================================
-- Organizations
-- ============================================

INSERT INTO organization (name, meta_account_id, google_account_id, store_id) VALUES
('Acme Corp', 'meta_acme_001', 'google_acme_001', 'store_acme_001'),
('Globex Inc', 'meta_globex_002', 'google_globex_002', 'store_globex_002');

-- ============================================
-- Acme Corp — Meta Ads Data (last 30 days)
-- ============================================

INSERT INTO meta_ads_data (account_id, date, spend, impressions) VALUES
('meta_acme_001', CURRENT_DATE - INTERVAL '30 days', 245.50, 18200),
('meta_acme_001', CURRENT_DATE - INTERVAL '29 days', 312.00, 22400),
('meta_acme_001', CURRENT_DATE - INTERVAL '28 days', 198.75, 15800),
('meta_acme_001', CURRENT_DATE - INTERVAL '27 days', 287.30, 20100),
('meta_acme_001', CURRENT_DATE - INTERVAL '26 days', 334.20, 24500),
('meta_acme_001', CURRENT_DATE - INTERVAL '25 days', 156.80, 12300),
('meta_acme_001', CURRENT_DATE - INTERVAL '24 days', 421.00, 31200),
('meta_acme_001', CURRENT_DATE - INTERVAL '23 days', 278.90, 19800),
('meta_acme_001', CURRENT_DATE - INTERVAL '22 days', 189.40, 14600),
('meta_acme_001', CURRENT_DATE - INTERVAL '21 days', 365.70, 26800),
('meta_acme_001', CURRENT_DATE - INTERVAL '20 days', 298.50, 21400),
('meta_acme_001', CURRENT_DATE - INTERVAL '19 days', 412.30, 30500),
('meta_acme_001', CURRENT_DATE - INTERVAL '17 days', 267.80, 19200),
('meta_acme_001', CURRENT_DATE - INTERVAL '16 days', 345.60, 25100),
('meta_acme_001', CURRENT_DATE - INTERVAL '15 days', 189.90, 14200),
('meta_acme_001', CURRENT_DATE - INTERVAL '14 days', 423.40, 31800),
('meta_acme_001', CURRENT_DATE - INTERVAL '13 days', 156.20, 11900),
('meta_acme_001', CURRENT_DATE - INTERVAL '12 days', 387.10, 28700),
('meta_acme_001', CURRENT_DATE - INTERVAL '11 days', 234.50, 17600),
('meta_acme_001', CURRENT_DATE - INTERVAL '10 days', 312.80, 23100),
('meta_acme_001', CURRENT_DATE - INTERVAL '9 days', 278.40, 20300),
('meta_acme_001', CURRENT_DATE - INTERVAL '8 days', 445.20, 33400),
('meta_acme_001', CURRENT_DATE - INTERVAL '7 days', 198.60, 15100),
('meta_acme_001', CURRENT_DATE - INTERVAL '6 days', 367.30, 27200),
('meta_acme_001', CURRENT_DATE - INTERVAL '5 days', 289.70, 21800),
('meta_acme_001', CURRENT_DATE - INTERVAL '4 days', 412.50, 30900),
('meta_acme_001', CURRENT_DATE - INTERVAL '3 days', 178.90, 13500),
('meta_acme_001', CURRENT_DATE - INTERVAL '2 days', 356.40, 26400),
('meta_acme_001', CURRENT_DATE - INTERVAL '1 day', 298.20, 22100);

-- ============================================
-- Acme Corp — Google Ads Data (last 30 days)
-- ============================================

INSERT INTO google_ads_data (account_id, date, spend, impressions) VALUES
('google_acme_001', CURRENT_DATE - INTERVAL '30 days', 178.30, 14500),
('google_acme_001', CURRENT_DATE - INTERVAL '29 days', 234.50, 18200),
('google_acme_001', CURRENT_DATE - INTERVAL '28 days', 145.60, 11800),
('google_acme_001', CURRENT_DATE - INTERVAL '27 days', 198.70, 15900),
('google_acme_001', CURRENT_DATE - INTERVAL '26 days', 267.80, 20100),
('google_acme_001', CURRENT_DATE - INTERVAL '25 days', 112.40, 9200),
('google_acme_001', CURRENT_DATE - INTERVAL '24 days', 312.90, 24600),
('google_acme_001', CURRENT_DATE - INTERVAL '23 days', 189.50, 15300),
('google_acme_001', CURRENT_DATE - INTERVAL '22 days', 134.20, 10800),
('google_acme_001', CURRENT_DATE - INTERVAL '21 days', 278.60, 21500),
('google_acme_001', CURRENT_DATE - INTERVAL '20 days', 223.40, 17800),
('google_acme_001', CURRENT_DATE - INTERVAL '19 days', 298.70, 23400),
('google_acme_001', CURRENT_DATE - INTERVAL '17 days', 187.30, 14900),
('google_acme_001', CURRENT_DATE - INTERVAL '16 days', 256.80, 19700),
('google_acme_001', CURRENT_DATE - INTERVAL '15 days', 134.50, 10600),
('google_acme_001', CURRENT_DATE - INTERVAL '14 days', 312.20, 24100),
('google_acme_001', CURRENT_DATE - INTERVAL '13 days', 109.80, 8700),
('google_acme_001', CURRENT_DATE - INTERVAL '12 days', 287.40, 22300),
('google_acme_001', CURRENT_DATE - INTERVAL '11 days', 167.90, 13200),
('google_acme_001', CURRENT_DATE - INTERVAL '10 days', 234.60, 18500),
('google_acme_001', CURRENT_DATE - INTERVAL '9 days', 198.30, 15700),
('google_acme_001', CURRENT_DATE - INTERVAL '8 days', 334.70, 26200),
('google_acme_001', CURRENT_DATE - INTERVAL '7 days', 145.20, 11400),
('google_acme_001', CURRENT_DATE - INTERVAL '6 days', 278.90, 21800),
('google_acme_001', CURRENT_DATE - INTERVAL '5 days', 212.40, 16900),
('google_acme_001', CURRENT_DATE - INTERVAL '4 days', 301.80, 23800),
('google_acme_001', CURRENT_DATE - INTERVAL '3 days', 123.50, 9800),
('google_acme_001', CURRENT_DATE - INTERVAL '2 days', 267.30, 20900),
('google_acme_001', CURRENT_DATE - INTERVAL '1 day', 219.70, 17300);

-- ============================================
-- Acme Corp — Store Data (last 30 days)
-- ============================================

INSERT INTO store_data (store_id, date, revenue, orders, fees) VALUES
('store_acme_001', CURRENT_DATE - INTERVAL '30 days', 1890.00, 12, 56.70),
('store_acme_001', CURRENT_DATE - INTERVAL '29 days', 2340.00, 15, 70.20),
('store_acme_001', CURRENT_DATE - INTERVAL '28 days', 1560.00, 10, 46.80),
('store_acme_001', CURRENT_DATE - INTERVAL '26 days', 2780.00, 18, 83.40),
('store_acme_001', CURRENT_DATE - INTERVAL '25 days', 1230.00, 8, 36.90),
('store_acme_001', CURRENT_DATE - INTERVAL '24 days', 3450.00, 22, 103.50),
('store_acme_001', CURRENT_DATE - INTERVAL '23 days', 2120.00, 14, 63.60),
('store_acme_001', CURRENT_DATE - INTERVAL '22 days', 1670.00, 11, 50.10),
('store_acme_001', CURRENT_DATE - INTERVAL '21 days', 2890.00, 19, 86.70),
('store_acme_001', CURRENT_DATE - INTERVAL '20 days', 2450.00, 16, 73.50),
('store_acme_001', CURRENT_DATE - INTERVAL '19 days', 3120.00, 20, 93.60),
('store_acme_001', CURRENT_DATE - INTERVAL '17 days', 2230.00, 14, 66.90),
('store_acme_001', CURRENT_DATE - INTERVAL '16 days', 2670.00, 17, 80.10),
('store_acme_001', CURRENT_DATE - INTERVAL '15 days', 1450.00, 9, 43.50),
('store_acme_001', CURRENT_DATE - INTERVAL '14 days', 3560.00, 23, 106.80),
('store_acme_001', CURRENT_DATE - INTERVAL '13 days', 1120.00, 7, 33.60),
('store_acme_001', CURRENT_DATE - INTERVAL '12 days', 3010.00, 19, 90.30),
('store_acme_001', CURRENT_DATE - INTERVAL '11 days', 1890.00, 12, 56.70),
('store_acme_001', CURRENT_DATE - INTERVAL '10 days', 2560.00, 16, 76.80),
('store_acme_001', CURRENT_DATE - INTERVAL '9 days', 2180.00, 14, 65.40),
('store_acme_001', CURRENT_DATE - INTERVAL '8 days', 3780.00, 24, 113.40),
('store_acme_001', CURRENT_DATE - INTERVAL '7 days', 1540.00, 10, 46.20),
('store_acme_001', CURRENT_DATE - INTERVAL '6 days', 2910.00, 19, 87.30),
('store_acme_001', CURRENT_DATE - INTERVAL '5 days', 2340.00, 15, 70.20),
('store_acme_001', CURRENT_DATE - INTERVAL '4 days', 3230.00, 21, 96.90),
('store_acme_001', CURRENT_DATE - INTERVAL '3 days', 1340.00, 9, 40.20),
('store_acme_001', CURRENT_DATE - INTERVAL '2 days', 2780.00, 18, 83.40),
('store_acme_001', CURRENT_DATE - INTERVAL '1 day', 2450.00, 16, 73.50);

-- ============================================
-- Globex Inc — Meta Ads Data (last 30 days)
-- ============================================

INSERT INTO meta_ads_data (account_id, date, spend, impressions) VALUES
('meta_globex_002', CURRENT_DATE - INTERVAL '30 days', 567.80, 42100),
('meta_globex_002', CURRENT_DATE - INTERVAL '29 days', 489.30, 36800),
('meta_globex_002', CURRENT_DATE - INTERVAL '28 days', 623.40, 47200),
('meta_globex_002', CURRENT_DATE - INTERVAL '27 days', 534.10, 40500),
('meta_globex_002', CURRENT_DATE - INTERVAL '26 days', 678.90, 51300),
('meta_globex_002', CURRENT_DATE - INTERVAL '25 days', 412.60, 31200),
('meta_globex_002', CURRENT_DATE - INTERVAL '24 days', 745.20, 56800),
('meta_globex_002', CURRENT_DATE - INTERVAL '23 days', 523.70, 39600),
('meta_globex_002', CURRENT_DATE - INTERVAL '22 days', 389.40, 29400),
('meta_globex_002', CURRENT_DATE - INTERVAL '21 days', 656.80, 49800),
('meta_globex_002', CURRENT_DATE - INTERVAL '20 days', 578.30, 43700),
('meta_globex_002', CURRENT_DATE - INTERVAL '19 days', 712.50, 54100),
('meta_globex_002', CURRENT_DATE - INTERVAL '17 days', 498.60, 37800),
('meta_globex_002', CURRENT_DATE - INTERVAL '16 days', 634.20, 48100),
('meta_globex_002', CURRENT_DATE - INTERVAL '15 days', 378.90, 28600),
('meta_globex_002', CURRENT_DATE - INTERVAL '14 days', 723.40, 55200),
('meta_globex_002', CURRENT_DATE - INTERVAL '13 days', 345.70, 26100),
('meta_globex_002', CURRENT_DATE - INTERVAL '12 days', 689.20, 52400),
('meta_globex_002', CURRENT_DATE - INTERVAL '11 days', 456.30, 34500),
('meta_globex_002', CURRENT_DATE - INTERVAL '10 days', 598.70, 45300),
('meta_globex_002', CURRENT_DATE - INTERVAL '9 days', 512.40, 38900),
('meta_globex_002', CURRENT_DATE - INTERVAL '8 days', 767.80, 58400),
('meta_globex_002', CURRENT_DATE - INTERVAL '7 days', 401.20, 30400),
('meta_globex_002', CURRENT_DATE - INTERVAL '6 days', 645.60, 49000),
('meta_globex_002', CURRENT_DATE - INTERVAL '5 days', 534.90, 40600),
('meta_globex_002', CURRENT_DATE - INTERVAL '4 days', 701.30, 53200),
('meta_globex_002', CURRENT_DATE - INTERVAL '3 days', 367.40, 27800),
('meta_globex_002', CURRENT_DATE - INTERVAL '2 days', 623.80, 47400),
('meta_globex_002', CURRENT_DATE - INTERVAL '1 day', 556.40, 42200);

-- ============================================
-- Globex Inc — Google Ads Data (last 30 days)
-- ============================================

INSERT INTO google_ads_data (account_id, date, spend, impressions) VALUES
('google_globex_002', CURRENT_DATE - INTERVAL '30 days', 345.20, 28100),
('google_globex_002', CURRENT_DATE - INTERVAL '29 days', 289.70, 23500),
('google_globex_002', CURRENT_DATE - INTERVAL '28 days', 398.60, 32400),
('google_globex_002', CURRENT_DATE - INTERVAL '27 days', 312.40, 25300),
('google_globex_002', CURRENT_DATE - INTERVAL '26 days', 423.50, 34500),
('google_globex_002', CURRENT_DATE - INTERVAL '25 days', 256.80, 20800),
('google_globex_002', CURRENT_DATE - INTERVAL '24 days', 478.90, 39100),
('google_globex_002', CURRENT_DATE - INTERVAL '23 days', 334.20, 27100),
('google_globex_002', CURRENT_DATE - INTERVAL '22 days', 234.50, 19000),
('google_globex_002', CURRENT_DATE - INTERVAL '21 days', 412.30, 33600),
('google_globex_002', CURRENT_DATE - INTERVAL '20 days', 367.80, 29900),
('google_globex_002', CURRENT_DATE - INTERVAL '19 days', 445.60, 36200),
('google_globex_002', CURRENT_DATE - INTERVAL '17 days', 312.40, 25400),
('google_globex_002', CURRENT_DATE - INTERVAL '16 days', 401.30, 32600),
('google_globex_002', CURRENT_DATE - INTERVAL '15 days', 223.70, 18100),
('google_globex_002', CURRENT_DATE - INTERVAL '14 days', 456.80, 37200),
('google_globex_002', CURRENT_DATE - INTERVAL '13 days', 198.40, 16100),
('google_globex_002', CURRENT_DATE - INTERVAL '12 days', 434.50, 35300),
('google_globex_002', CURRENT_DATE - INTERVAL '11 days', 278.60, 22600),
('google_globex_002', CURRENT_DATE - INTERVAL '10 days', 378.90, 30800),
('google_globex_002', CURRENT_DATE - INTERVAL '9 days', 323.40, 26300),
('google_globex_002', CURRENT_DATE - INTERVAL '8 days', 489.20, 39800),
('google_globex_002', CURRENT_DATE - INTERVAL '7 days', 245.30, 19900),
('google_globex_002', CURRENT_DATE - INTERVAL '6 days', 412.70, 33500),
('google_globex_002', CURRENT_DATE - INTERVAL '5 days', 334.60, 27200),
('google_globex_002', CURRENT_DATE - INTERVAL '4 days', 445.80, 36200),
('google_globex_002', CURRENT_DATE - INTERVAL '3 days', 212.30, 17200),
('google_globex_002', CURRENT_DATE - INTERVAL '2 days', 389.40, 31600),
('google_globex_002', CURRENT_DATE - INTERVAL '1 day', 345.70, 28100);

-- ============================================
-- Globex Inc — Store Data (last 30 days)
-- ============================================

INSERT INTO store_data (store_id, date, revenue, orders, fees) VALUES
('store_globex_002', CURRENT_DATE - INTERVAL '30 days', 4230.00, 28, 126.90),
('store_globex_002', CURRENT_DATE - INTERVAL '29 days', 3670.00, 24, 110.10),
('store_globex_002', CURRENT_DATE - INTERVAL '28 days', 4780.00, 31, 143.40),
('store_globex_002', CURRENT_DATE - INTERVAL '26 days', 5120.00, 33, 153.60),
('store_globex_002', CURRENT_DATE - INTERVAL '25 days', 3120.00, 20, 93.60),
('store_globex_002', CURRENT_DATE - INTERVAL '24 days', 5890.00, 38, 176.70),
('store_globex_002', CURRENT_DATE - INTERVAL '23 days', 4010.00, 26, 120.30),
('store_globex_002', CURRENT_DATE - INTERVAL '22 days', 3340.00, 22, 100.20),
('store_globex_002', CURRENT_DATE - INTERVAL '21 days', 5230.00, 34, 156.90),
('store_globex_002', CURRENT_DATE - INTERVAL '20 days', 4560.00, 30, 136.80),
('store_globex_002', CURRENT_DATE - INTERVAL '19 days', 5670.00, 37, 170.10),
('store_globex_002', CURRENT_DATE - INTERVAL '17 days', 3890.00, 25, 116.70),
('store_globex_002', CURRENT_DATE - INTERVAL '16 days', 4890.00, 32, 146.70),
('store_globex_002', CURRENT_DATE - INTERVAL '15 days', 2980.00, 19, 89.40),
('store_globex_002', CURRENT_DATE - INTERVAL '14 days', 5980.00, 39, 179.40),
('store_globex_002', CURRENT_DATE - INTERVAL '13 days', 2670.00, 17, 80.10),
('store_globex_002', CURRENT_DATE - INTERVAL '12 days', 5340.00, 35, 160.20),
('store_globex_002', CURRENT_DATE - INTERVAL '11 days', 3560.00, 23, 106.80),
('store_globex_002', CURRENT_DATE - INTERVAL '10 days', 4670.00, 30, 140.10),
('store_globex_002', CURRENT_DATE - INTERVAL '9 days', 4120.00, 27, 123.60),
('store_globex_002', CURRENT_DATE - INTERVAL '8 days', 6230.00, 40, 186.90),
('store_globex_002', CURRENT_DATE - INTERVAL '7 days', 3120.00, 20, 93.60),
('store_globex_002', CURRENT_DATE - INTERVAL '6 days', 5120.00, 33, 153.60),
('store_globex_002', CURRENT_DATE - INTERVAL '5 days', 4230.00, 27, 126.90),
('store_globex_002', CURRENT_DATE - INTERVAL '4 days', 5560.00, 36, 166.80),
('store_globex_002', CURRENT_DATE - INTERVAL '3 days', 2890.00, 19, 86.70),
('store_globex_002', CURRENT_DATE - INTERVAL '2 days', 4890.00, 32, 146.70),
('store_globex_002', CURRENT_DATE - INTERVAL '1 day', 4340.00, 28, 130.20);
