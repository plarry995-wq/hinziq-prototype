# HINZIQ Prototype — first build

This package contains the branded HINZIQ web interface and a starter Cloudflare D1 schema / Worker API.

## What's included
- `index.html`: responsive premium dashboard and institutional workspaces.
- `assets/hinziq-logo.png`: the supplied HINZIQ logo.
- `schema.sql`: relational starting schema for products, assessments, lab samples/results, trials, observations, harvest, decisions, reports and audit events.
- `worker.js` and `wrangler.toml`: minimal Cloudflare Worker API starter.

## Important prototype boundaries
- The interface currently uses fictional demonstration records in browser memory. New product entries are not yet shared across devices or persisted to a central database.
- The demo role selector is a visual demonstration only, not authentication or access control.
- PDF buttons use the browser print dialog; choose “Save as PDF”.
- The AI assessment is a simulated workflow, not a live AI model or legal assessment.
- Do not upload real applicant dossiers, personal information, confidential government records or real trial data to this prototype.

## Publish the visual prototype using Cloudflare Pages
1. Create a new private GitHub repository named `hinziq-prototype`.
2. Upload `index.html` and the `assets/` folder to the repository root. Keep the exact folder structure.
3. In Cloudflare Dashboard, open **Workers & Pages** → **Create application** → **Pages** → **Connect to Git**.
4. Authorise GitHub and select `hinziq-prototype`.
5. For a plain static HTML site, choose **None** as the framework preset, leave the build command blank, and set the build output directory to `/` (or `.` if the form requires a relative path).
6. Deploy. Cloudflare will provide a `*.pages.dev` URL.

## Next: shared database
The supplied `schema.sql` is a starting point for a D1 database. Create the D1 database and apply the schema, then set the real database ID in `wrangler.toml`. Before multi-user use, implement:
- real identity/authentication and institutional role-based authorisation;
- server-side validation and audit logging for every write;
- private object storage for uploaded documents and photos;
- signed/authorised PDF reports with draft vs validated status;
- backup, retention, security, privacy and incident procedures;
- offline-capable field capture and safe synchronisation.

A public Pages URL alone does not make records shared. Shared records require the API and D1 integration to be deployed and protected.
