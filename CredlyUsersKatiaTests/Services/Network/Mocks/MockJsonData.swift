//
//  MockJsonData.swift
//  CredlyUsersKatiaTests
//
//  Created by Katia Maeda on 2023-02-26.
//

import Foundation
@testable import CredlyUsersKatia

class MockJsonData {
    static public func getUsers(for fileName: String) -> [User]? {
        let bundle = Bundle(for: MockJsonData.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        
        let users: [User]?
        do {
            users = try JSONDecoder().decode([User].self, from: data)
        } catch {
            return nil
        }
        
        return users
    }
    
    static public func getUsersData(for fileName: String) -> Data? {
        let bundle = Bundle(for: MockJsonData.self)
        guard let url = bundle.url(forResource: fileName, withExtension: "json"),
              let data = try? Data(contentsOf: url)
        else {
            return nil
        }
        
        return data
    }
}

enum JsonFileName: String {
    case users = "users"
    case usersMalformed = "users_malformed"
    case usersEmpty = "users_empty"
}
