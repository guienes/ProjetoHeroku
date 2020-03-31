import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config,
                      _ env: inout Environment,
                      _ services: inout Services) throws {
    
    try services.register(FluentPostgreSQLProvider())
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    var middlewares = MiddlewareConfig()
    middlewares.use(ErrorMiddleware.self)
    services.register(middlewares)
    
    let postgresqlConfiguration = getDatabaseConfiguration(env)
    services.register(postgresqlConfiguration)
    
    var migrations = MigrationConfig()
    migrations.add(model: User.self, database: .psql)
    services.register(migrations)
}

private func getDatabaseConfiguration(_ env: Environment) -> PostgreSQLDatabaseConfig {
    if env.isRelease {
        let databaseUrl = ProcessInfo.processInfo.environment["DATABASE_URL"]!
        return PostgreSQLDatabaseConfig(url: databaseUrl)!
    } else {
        return PostgreSQLDatabaseConfig(
            hostname: "127.0.0.1",
            port: 5432,
            username: "postgres",
            database: "woloxusers",
            password: nil
        )
    }
}
