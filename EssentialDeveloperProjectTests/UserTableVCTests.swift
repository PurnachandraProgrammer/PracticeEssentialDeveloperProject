//
//  UserTableVCTests.swift
//  EssentialDeveloperProjectTests
//
//  Created by user224925 on 11/29/22.
//

import XCTest
@testable import EssentialDeveloperProject

final class UserTableVCTests: XCTestCase {
    
    
    func test_canInit() throws {
       _ = try makeSUT()
    }
    

    func test_viewDidLoad_setsTitle() throws {
        let sut = try makeSUT()
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.title,"Users")
    }

    func test_viewDidLoad_configureTableView() throws {
        
        let sut = try makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.viewControllerTableView.delegate, "delegate")
        XCTAssertNotNil(sut.viewControllerTableView.delegate, "dataSource")
    }
    
    func test_viewDidLoad_initiaState() throws {
        
        let sut = try makeSUT()
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.viewControllerTableView.numberOfRows(inSection: 0), 0)
    }
    
    func test_viewDidLoad_rendersUsersFromAPI() throws {
        
        let sut = try makeSUT()
        sut.loadViewIfNeeded()
        
        let exp = expectation(description: "Wait for API")
        exp.isInverted = true
        wait(for: [exp], timeout: 3)
        
        XCTAssertEqual(sut.viewControllerTableView.numberOfRows(inSection: 0), 10)
    }
    
    private func makeSUT() throws -> ViewController {
        
        let bundle = Bundle(for:ViewController.self)
        let sb = UIStoryboard(name: "Main", bundle: bundle)
        
        let initialVC = sb.instantiateInitialViewController()
        let navigation = try XCTUnwrap(initialVC as? UINavigationController)
        
        let sut = try XCTUnwrap(navigation.topViewController as? ViewController)
        sut.api = ApiManagerStub()
        return sut
    }
 
}

private class ApiManagerStub : ApiManager {
   
    override init() {
    }
    override func getUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        
    }
}
