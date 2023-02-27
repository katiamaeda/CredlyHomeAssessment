//
//  UsersAPIService.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-25.
//

import Foundation
import Combine
import Alamofire

protocol UsersAPIServicing {
    /// Fetches all users
    ///
    /// - Returns: AnyPublisher with a list of Users or an APIError
    func fetchUsers() -> AnyPublisher<Result<[User], AFError>, Never>
}

class UsersAPIService: UsersAPIServicing {
    private let session: Session
    
    init(_ session: Session = AF) {
        self.session = session
    }
    
    func fetchUsers() -> AnyPublisher<Result<[User], AFError>, Never> {
        let request = session.request(UsersAPIRequest.getUsers)
        
        return request
            .validate()
            .publishDecodable(type: [User].self, decoder: JSONDecoder())
            .result()
            .eraseToAnyPublisher()
    }
}
