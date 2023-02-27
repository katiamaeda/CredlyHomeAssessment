//
//  MockUsersAPIService.swift
//  CredlyUsersKatiaTests
//
//  Created by Katia Maeda on 2023-02-26.
//

import Foundation
import Combine
import Alamofire
@testable import CredlyUsersKatia

class MockUsersAPIService {
    var users: [User]
    var error: AFError?
    var calledFetchUsers = 0
    
    init(users: [User] = [], error: AFError? = nil) {
        self.users = users
        self.error = error
    }
}

extension MockUsersAPIService: UsersAPIServicing {
    func fetchUsers() -> AnyPublisher<Result<[User], AFError>, Never> {
        calledFetchUsers += 1
        
        let publisher = CurrentValueSubject<Result<[User], AFError>, Never>(.success(users))
        if let error = error {
            publisher.send(.failure(error))
        }
        
        return publisher.eraseToAnyPublisher()
    }
}
