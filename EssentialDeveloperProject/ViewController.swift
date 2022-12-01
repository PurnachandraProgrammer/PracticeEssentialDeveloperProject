//
//  ViewController.swift
//  EssentialDeveloperProject
//
//  Created by user224925 on 11/29/22.
//

import UIKit

class UserApiAdapter {
    
    static func getUsers(completion:(@escaping (Result<[User],Error>) -> Void)) -> Void {
    
        ApiManager.shared.getUsers { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
    }
}

typealias GetUsers = (@escaping (Result<[User],Error>) -> Void ) -> Void

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var viewControllerTableView: UITableView!
    private var users:[UserViewModel] = []
    private var viewModel : UserListViewModel!
    
    // This property injection used to inject another variable, may be we can use it for testing purpose.
    var getUsers:GetUsers = UserApiAdapter.getUsers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        
        // Do any additional setup after loading the view.
        configureTableView()
        getUsersFromSingleton()
    }

    private func configureTableView() {
        self.viewControllerTableView.delegate = self
        self.viewControllerTableView.dataSource = self
    }
    
    private func getUsersFromSingleton() {
        
        viewModel = UserListViewModel(getUsers: getUsers, usersChanged: { users in
            self.users = users
            self.viewControllerTableView.reloadData()
        })
 
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    } 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let userCell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserCell
        
        let vm = users[indexPath.row]
        
        userCell?.nameLabel.text = vm.name
        userCell?.emailLabel.text = vm.email
        
        if vm.isHighlighted {
            userCell?.backgroundColor = .green
        }
        else {
            userCell?.backgroundColor = .black
        }
        
        return userCell ?? UITableViewCell()
                                                     
    }
}

struct UserListViewModel {
    
    let getUsers:GetUsers
    let usersChanged: ([UserViewModel]) -> Void
    
    init(getUsers: @escaping GetUsers,usersChanged: @escaping([UserViewModel]) -> Void) {
        self.getUsers = getUsers
        self.usersChanged = usersChanged
    }
    
}

struct UserViewModel {
    
    let name:String
    let email:String
    let isHighlighted: Bool
    
    init(user:User) {
        
        name = user.name
        email = user.email
        isHighlighted = user.name.starts(with: "C")
        
    }
    
}
