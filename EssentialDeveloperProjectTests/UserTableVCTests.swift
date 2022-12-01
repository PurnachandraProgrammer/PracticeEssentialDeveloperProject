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
        
        XCTAssertEqual(sut.numberOfUsers(), 0)
    }
    
    func test_viewDidLoad_rendersUsersFromAPI() throws {
        
        let sut = try makeSUT()
        sut.getUsers = { completion in completion(.success(
            [makeUser(name: "User 0", email: "Email 0"),
            makeUser(name: "User 1", email: "Email 1"),
            makeUser(name: "User 2", email: "Email 2")]))}
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfUsers(), 3)
        XCTAssertEqual(sut.name(atRow: 0), "User 0")
        XCTAssertEqual(sut.email(atRow: 0), "Email 0")
    }
    
    func test_viewDidLoad_whenUserNameStartsWithC_highlightsCell () throws {
        
        let sut = try makeSUT()
        sut.getUsers = { completion in completion(.success(
            [makeUser(name: "C User 0", email: "Email 0"),
            makeUser(name: "User C 1", email: "Email 1"),
            makeUser(name: "User 2", email: "Email 2")]))}
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.numberOfUsers(), 3)
        
        
        
    }
    
    private func makeSUT() throws -> ViewController {
        
        let bundle = Bundle(for:ViewController.self)
        let sb = UIStoryboard(name: "Main", bundle: bundle)
        
        let initialVC = sb.instantiateInitialViewController()
        let navigation = try XCTUnwrap(initialVC as? UINavigationController)
        
        let sut = try XCTUnwrap(navigation.topViewController as? ViewController)
        sut.getUsers = { _ in }
        return sut
    }
 
}

private func makeUser(name:String,email:String) -> User {
    User(id: 0, name: name, email: email)
}


private extension ViewController {
    
    func numberOfUsers() -> Int {
        viewControllerTableView.numberOfRows(inSection: usersSection)
    }
    
    func name(atRow row: Int) -> String? {
        let cell = userCell(atRow: row)
        return cell?.nameLabel.text
    }
    
    func email (atRow row: Int) -> String? {
        let cell = userCell(atRow: row)
        return cell?.emailLabel.text
    }
    
    func isHighlighted(atRow row:Int) -> Bool {
        userCell(atRow: row)?.backgroundColor == .green
    }
    
    func userCell(atRow row:Int) -> UserCell? {
        let ds = viewControllerTableView.dataSource
        let indexPath = IndexPath(row: row, section: usersSection)
        return ds?.tableView(viewControllerTableView, cellForRowAt: indexPath) as? UserCell
    }
    
    private var usersSection: Int { 0 }
}

