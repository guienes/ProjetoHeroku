//
//  User.swift
//  App
//
//  Created by Guilherme Enes on 31/03/20.
//

import FluentPostgreSQL
import Vapor

final class User: PostgreSQLModel {
    
    var id: Int?
    var username: String
    
    init(id: Int? = nil, username: String) {
        self.id = id
        self.username = username
    }
}

extension User: Content {}
extension User: Migration {}
extension User: Parameter {}
