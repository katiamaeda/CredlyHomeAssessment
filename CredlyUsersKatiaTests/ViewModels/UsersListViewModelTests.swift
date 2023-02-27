//
//  UsersListViewModelTests.swift
//  CredlyUsersKatiaTests
//
//  Created by Katia Maeda on 2023-02-26.
//

import XCTest
import Combine
import Alamofire
import Mocker
@testable import CredlyUsersKatia

class UsersListViewModelTests: XCTestCase {
    
    var sut: UsersListViewModel!
    var usersService: MockUsersAPIService!
    
    let apiEndpoint = URL(string: UsersAPIRequest.getUsers.url)!
    
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        usersService = MockUsersAPIService()
        sut = UsersListViewModel(usersService: usersService)
    }
    
    override func tearDown() {
        sut = nil
        usersService = nil
        subscriptions.removeAll()
        super.tearDown()
    }
    
    func test_initialization_fetchUsers() {
        XCTAssertEqual(usersService.calledFetchUsers, 1)
    }
    
    func test_initialization_listIsEmpty_returnsEmptyList() {
        usersService = MockUsersAPIService(users: [])
        sut = UsersListViewModel(usersService: usersService)
        
        XCTAssertTrue(sut.users.isEmpty)
    }
    
    func test_initialization_listIsNotEmpty_returnsValue() {
        let expectation = self.expectation(description: #function)
        var result: [User] = []
        
        usersService.users = initializeUsers()
        
        sut.$users
            .dropFirst()
            .first()
            .sink(
                receiveValue: {
                    result = $0
                    expectation.fulfill()
                }
            )
            .store(in: &subscriptions)
        
        sut.loadData()
        
        waitForExpectations(timeout: 10)
        XCTAssertFalse(result.isEmpty)
        XCTAssertEqual(sut.users.count, 2)
    }
    
    func test_initialization_givenError_receivesEmptyList() {
        let expectation = self.expectation(description: #function)
        var result: [User] = []
        
        updateDispatchWithError()
        
        sut.$users
            .dropFirst()
            .first()
            .sink(
                receiveValue: {
                    result = $0
                    expectation.fulfill()
                }
            )
            .store(in: &subscriptions)
        
        sut.loadData()
        
        waitForExpectations(timeout: 1)
        XCTAssertTrue(result.isEmpty)
    }
}

extension UsersListViewModelTests {
    private func initializeUsers() -> [User] {
        [
            User(id: 1, name: "Leanne Graham", username: "Bret", email: "Sincere@april.biz", address: Address(street: "Kulas Light", suite: "Apt. 556", city: "Gwenborough", zipcode: "92998-3874", geo: Coordinate(latitude: "-37.3159", longitude: "81.1496")), phone: "1-770-736-8031 x56442", website: "hildegard.org", company: Company(name: "Romaguera-Crona", catchPhrase: "Multi-layered client-server neural-net", bs: "harness real-time e-markets")),
            User(id: 2, name: "Ervin Howell", username: "Antonette", email: "Shanna@melissa.tv", address: Address(street: "Victor Plains", suite: "Suite 879", city: "Wisokyburgh", zipcode: "90566-7771", geo: Coordinate(latitude: "-43.9509", longitude: "-34.4618")), phone: "010-692-6593 x09125", website: "anastasia.net", company: Company(name: "Deckow-Crist", catchPhrase: "Proactive didactic contingency", bs: "synergize scalable supply-chains"))
        ]
    }
    
    private func updateDispatchWithError() {
        let error = AFError.responseSerializationFailed(reason: .inputFileNil)
        usersService = MockUsersAPIService(error: error)
        sut = UsersListViewModel(usersService: usersService)
    }
}
