export async function onRequestGet({ env }) {
  try {
    const result = await env.DB.prepare(
      "SELECT COUNT(*) AS table_count FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlite_%'"
    ).first();

    return Response.json({
      success: true,
      message: "HINZIQ database connection successful.",
      database: "hinziq-core-db",
      project_tables: result.table_count
    });
  } catch (error) {
    return Response.json({
      success: false,
      message: "Database connection failed.",
      error: error.message
    }, { status: 500 });
  }
}
