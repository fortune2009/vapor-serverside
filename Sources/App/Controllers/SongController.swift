//
//  SongController.swift
//
//
//  Created by Fortune David Chigozirim on 27/05/2024.
//

import Fluent
import Vapor

struct SongController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let songs = routes.grouped("songs")
        songs.get(use: index)
        songs.post(use: create)
        songs.put(use: update)
        songs.group(":songID") {
            song in song.delete(use: delete)
        }
    }
    
    // GET Request /songs route
    func index(req: Request) throws -> EventLoopFuture<[Song]> {
        return Song.query(on: req.db).all()
    }
    
    // POST Request //songs route
    func create(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return song.save(on: req.db).transform(to: .ok)
    }
    
    // PUT request /songs route
    func update(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        let song = try req.content.decode(Song.self)
        return Song.find(song.id, on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap {
                $0.title = song.title
                return $0.update(on: req.db).transform(to: .ok)
            }
    }
    
    // Delete songs/id route
    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        Song.find(req.parameters.get("songID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap{
                $0.delete(on: req.db)
            }.transform(to: .ok)
    }
}
