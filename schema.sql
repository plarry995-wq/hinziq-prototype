-- HINZIQ demonstration database schema (Cloudflare D1 / SQLite)
-- Apply only to a dedicated demo database. Replace sample records with approved data policies before production.
PRAGMA foreign_keys = ON;
CREATE TABLE IF NOT EXISTS users (
 id TEXT PRIMARY KEY, email TEXT UNIQUE NOT NULL, display_name TEXT NOT NULL,
 institution TEXT NOT NULL, role TEXT NOT NULL, is_active INTEGER NOT NULL DEFAULT 1,
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS products (
 id TEXT PRIMARY KEY, reference TEXT UNIQUE NOT NULL, name TEXT NOT NULL,
 applicant TEXT NOT NULL, category TEXT, crop_use TEXT, current_stage TEXT NOT NULL,
 status TEXT NOT NULL, created_by TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
 updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS assessments (
 id TEXT PRIMARY KEY, product_id TEXT NOT NULL REFERENCES products(id),
 officer_id TEXT REFERENCES users(id), status TEXT NOT NULL, findings TEXT,
 is_ai_draft INTEGER NOT NULL DEFAULT 0, validated_at TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS lab_samples (
 id TEXT PRIMARY KEY, sample_reference TEXT UNIQUE NOT NULL,
 product_id TEXT NOT NULL REFERENCES products(id), received_at TEXT,
 chain_of_custody TEXT, status TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS lab_results (
 id TEXT PRIMARY KEY, sample_id TEXT NOT NULL REFERENCES lab_samples(id),
 test_method TEXT NOT NULL, result_value TEXT, units TEXT, observations TEXT,
 validation_status TEXT NOT NULL, validated_by TEXT REFERENCES users(id),
 created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS trial_sites (
 id TEXT PRIMARY KEY, product_id TEXT NOT NULL REFERENCES products(id),
 trial_reference TEXT UNIQUE NOT NULL, district TEXT NOT NULL, site_name TEXT,
 season TEXT, protocol_version TEXT, status TEXT NOT NULL, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS trial_observations (
 id TEXT PRIMARY KEY, site_id TEXT NOT NULL REFERENCES trial_sites(id),
 plot_code TEXT NOT NULL, plot_type TEXT NOT NULL, observed_at TEXT NOT NULL,
 crop_stage TEXT, measurements_json TEXT, notes TEXT, photo_object_key TEXT,
 entered_by TEXT REFERENCES users(id), validated_by TEXT REFERENCES users(id),
 validation_status TEXT NOT NULL DEFAULT 'Draft', created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS harvest_records (
 id TEXT PRIMARY KEY, site_id TEXT NOT NULL REFERENCES trial_sites(id),
 plot_code TEXT NOT NULL, harvest_date TEXT NOT NULL, area_ha REAL,
 yield_kg REAL, moisture_percent REAL, notes TEXT, entered_by TEXT REFERENCES users(id),
 validated_by TEXT REFERENCES users(id), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS regulatory_decisions (
 id TEXT PRIMARY KEY, product_id TEXT NOT NULL REFERENCES products(id),
 decision TEXT NOT NULL, basis TEXT NOT NULL, officer_id TEXT REFERENCES users(id),
 signed_report_key TEXT, decided_at TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS reports (
 id TEXT PRIMARY KEY, product_id TEXT REFERENCES products(id),
 report_type TEXT NOT NULL, institution TEXT NOT NULL, period_start TEXT, period_end TEXT,
 status TEXT NOT NULL, version INTEGER NOT NULL DEFAULT 1, object_key TEXT,
 generated_by TEXT REFERENCES users(id), created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE IF NOT EXISTS audit_events (
 id TEXT PRIMARY KEY, actor_id TEXT REFERENCES users(id), action TEXT NOT NULL,
 entity_type TEXT NOT NULL, entity_id TEXT NOT NULL, reason TEXT,
 before_json TEXT, after_json TEXT, created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_products_reference ON products(reference);
CREATE INDEX IF NOT EXISTS idx_trials_product ON trial_sites(product_id);
CREATE INDEX IF NOT EXISTS idx_observations_site ON trial_observations(site_id);
CREATE INDEX IF NOT EXISTS idx_audit_entity ON audit_events(entity_type, entity_id);
