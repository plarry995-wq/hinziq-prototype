// HINZIQ Cloudflare Worker API starter.
// This starter intentionally exposes read-only demo health/product routes only.
// Add authenticated role checks before enabling any write endpoints or real institutional data.
export default {
 async fetch(request, env) {
  const url = new URL(request.url);
  const headers = { "content-type": "application/json; charset=utf-8", "access-control-allow-origin": "*", "access-control-allow-methods": "GET,OPTIONS", "access-control-allow-headers": "content-type,authorization" };
  if (request.method === "OPTIONS") return new Response(null, { headers });
  if (url.pathname === "/api/health") return Response.json({ ok: true, service: "HINZIQ API", environment: "demo" }, { headers });
  if (url.pathname === "/api/products" && request.method === "GET") {
   const { results } = await env.DB.prepare("SELECT reference,name,applicant,category,current_stage,status,created_at FROM products ORDER BY created_at DESC LIMIT 100").all();
   return Response.json({ items: results }, { headers });
  }
  return Response.json({ error: "Not found" }, { status: 404, headers });
 }
};
