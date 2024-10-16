import Fluent
import FluentPostgresDriver
import Vapor

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

//    if let urlString = Environment.get("DATABASE_HOST"),
//       var postgresConfig = PostgresConfiguration(url: urlString)
//       {
//        var tlsConfig = TLSConfiguration.makeClientConfiguration()
//        tlsConfig.certificateVerification = .none
//        postgresConfig.tlsConfiguration = tlsConfig
//        
//        app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    
    if let databaseURL = Environment.get("DATABASE_URL") {
    var tlsConfig: TLSConfiguration = .makeClientConfiguration()
       tlsConfig.certificateVerification = .none
       let nioSSLContext = try NIOSSLContext(configuration: tlsConfig)

       var postgresConfig = try SQLPostgresConfiguration(url: databaseURL)
       postgresConfig.coreConfiguration.tls = .require(nioSSLContext)

       app.databases.use(.postgres(configuration: postgresConfig), as: .psql)
    }else{
        app.databases.use(.postgres(
            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
            database: Environment.get("DATABASE_NAME") ?? "vapor_database"
        ), as: .psql)
        
        
       
//        var tlsConfiguration = TLSConfiguration.makeClientConfiguration()
//        tlsConfiguration.certificateVerification = .none
//        let nioSSLContext = try NIOSSLContext(configuration: tlsConfiguration)
//        let maxConnectionsPerEventLoop = 10
//        let connectionPoolTimeout: TimeAmount = .seconds(10)
//
//        var postgresConfig = SQLPostgresConfiguration(
//            hostname: Environment.get("DATABASE_HOST") ?? "localhost",
//            port: Environment.get("DATABASE_PORT").flatMap(Int.init(_:)) ?? SQLPostgresConfiguration.ianaPortNumber,
//            username: Environment.get("DATABASE_USERNAME") ?? "vapor_username",
//            password: Environment.get("DATABASE_PASSWORD") ?? "vapor_password",
//            database: Environment.get("DATABASE_NAME") ?? "vapor_database"
//        )
////        postgresConfig.coreConfiguration.tls = tlsConfiguration
//
//        app.databases.use(.postgres(
//            configuration: postgresConfig,
//            maxConnectionsPerEventLoop: maxConnectionsPerEventLoop,
//            connectionPoolTimeout: connectionPoolTimeout,
//            encodingContext: .default,
//            decodingContext: .default,
//            sqlLogLevel: .info
//        ), as: .psql)
        
    }
    
    app.migrations.add(CreateSongs())
    
    if app.environment == .development {
        try app.autoMigrate().wait()
    }
    // register routes
    try routes(app)
}
