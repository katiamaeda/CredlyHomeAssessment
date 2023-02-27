//
//  UsersListViewModel.swift
//  CredlyProjectKatia
//
//  Created by Katia Maeda on 2023-02-25.
//

import Foundation
import Combine

enum LoadState {
    case loading
    case empty
    case error
    case loaded
}

class UsersListViewModel {
    @Published var users: [User] = []
    @Published var loadState: LoadState = .loading
    
    private let usersService: UsersAPIServicing
    private var subscriptions = Set<AnyCancellable>()
    
    init(usersService: UsersAPIServicing = UsersAPIService()) {
        self.usersService = usersService
        loadData()
    }
    
    internal func loadData() {
        loadState = .loading
        usersService.fetchUsers()
            .sink { [weak self] result in
                switch result {
                case .success(let list):
                    self?.users = list
                    self?.loadState = list.count > 0 ? .loaded : .empty
                case .failure(let error):
                    self?.loadState = .error
                    self?.users = []
                    print("[ERROR]: Attempt to fetchEmployees returned error: \(error)")
                }
            }
            .store(in: &subscriptions)
    }
    
    func numberOfRows() -> Int {
        switch loadState {
        case .loading, .empty, .error:
            return 1
        case .loaded:
            return users.count
        }
    }
}
