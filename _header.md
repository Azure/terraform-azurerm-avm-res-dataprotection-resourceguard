# Data Protection Resource Guard

Deploys a Resource Guard and optional Recovery Services vault associations. `tags` applies to the guard and every association. Locks and role assignments retain their existing resource-group scope.

Existing lock and role-assignment resources require AzureRM v4. Read tags and location from `resource.tags` and `resource.location`, not `resource.body`.
