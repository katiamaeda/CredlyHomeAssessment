//
//  UsersAPIServiceTests.swift
//  CredlyUsersKatiaTests
//
//  Created by Katia Maeda on 2023-02-26.
//

import XCTest
import Combine
import Alamofire
import Mocker
@testable import CredlyUsersKatia

class UsersAPIServiceTests: XCTestCase {
    
    var sut: UsersAPIService!
    
    var subscriptions = Set<AnyCancellable>()
    
    let apiEndpoint = URL(string: UsersAPIRequest.getUsers.url)!
    
    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.af.default
        configuration.protocolClasses = [MockingURLProtocol.self] + (configuration.protocolClasses ?? [])
        let sessionManager = Session(configuration: configuration)
        
        sut = UsersAPIService(sessionManager)
    }
    
    override func tearDown() {
        sut = nil
        subscriptions.removeAll()
        super.tearDown()
    }
    
    func test_fetchUsers_givenValidJson_returnsUsers() {
        let requestExpectation = expectation(description: "Request should finish")
        let expected = MockJsonData.getUsers(for: JsonFileName.users.rawValue)
        var testResult: [User]? = nil
        
        guard let mockedData = MockJsonData.getUsersData(for: JsonFileName.users.rawValue) else {
            XCTFail("Error getting mocking data")
            return
        }
        
        let mock = Mock(url: apiEndpoint, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()

        sut.fetchUsers()
            .first()
            .sink { result in
                switch result {
                case .success(let list):
                    testResult = list
                case .failure(let error):
                    XCTFail("Expected no errors \(error)")
                }
                requestExpectation.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [requestExpectation], timeout: 10.0)
        XCTAssertEqual(testResult, expected)
    }
    
    func test_fetchUsers_givenMalformedJson_returnsUsers() {
        let requestExpectation = expectation(description: "Request should finish with error")
        var testResult: AFError?
        
        guard let mockedData = MockJsonData.getUsersData(for: JsonFileName.usersMalformed.rawValue) else {
            XCTFail("Error getting mocking data")
            return
        }
        
        let mock = Mock(url: apiEndpoint, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()

        sut.fetchUsers()
            .first()
            .sink { result in
                switch result {
                case .success:
                    XCTFail("Expected no valid list")
                case .failure(let error):
                    testResult = error
                }
                requestExpectation.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [requestExpectation], timeout: 10.0)
        XCTAssertNotNil(testResult)
        XCTAssertTrue(testResult!.isResponseSerializationError)
    }
    
    func test_fetchUsers_givenEmptyJson_returnnEmpty() {
        let requestExpectation = expectation(description: "Request should finish with error")
        let expected = MockJsonData.getUsers(for: JsonFileName.usersEmpty.rawValue)
        var testResult: [User]? = nil
        
        guard let mockedData = MockJsonData.getUsersData(for: JsonFileName.usersEmpty.rawValue) else {
            XCTFail("Error getting mocking data")
            return
        }
        
        let mock = Mock(url: apiEndpoint, contentType: .json, statusCode: 200, data: [.get: mockedData])
        mock.register()

        sut.fetchUsers()
            .first()
            .sink { result in
                switch result {
                case .success(let list):
                    testResult = list
                case .failure(let error):
                    XCTFail("Expected no errors \(error)")
                }
                requestExpectation.fulfill()
            }
            .store(in: &subscriptions)

        wait(for: [requestExpectation], timeout: 10.0)
        XCTAssertEqual(testResult, expected)
    }
}

