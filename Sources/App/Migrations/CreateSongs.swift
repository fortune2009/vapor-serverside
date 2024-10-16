//
//  CreateSongs.swift
//
//
//  Created by Fortune David Chigozirim on 27/05/2024.
//

import Fluent

//struct CreateSongs: Migration {
//    func prepare(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
//        return database.schema("songs")
//            .id()
//            .field("title", .string, .required)
//            .create()
//    }
//    
//    func revert(on database: FluentKit.Database) -> NIOCore.EventLoopFuture<Void> {
//        return database.schema("songs").delete()
//    }
//    
//    
//}

struct CreateSongs: AsyncMigration {
    func prepare(on database: Database) async throws {
        try await database.schema("songs")
            .id()
            .field("title", .string, .required)
            .create()
    }
    
    func revert(on database: Database) async throws {
        try await database.schema("songs").delete()
    }
}
