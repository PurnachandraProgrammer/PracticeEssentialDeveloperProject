//
//  ViewController.swift
//  EssentialDeveloperProject
//
//  Created by user224925 on 11/29/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var viewControllerTableView: UITableView!
    var users:[User] = []
    
    // This property injection used to inject another variable, may be we can use it for testing purpose.
    var api:Api = ApiManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Users"
        
        // Do any additional setup after loading the view.
        configureTableView()
        getUsersFromSingleton()
    }

    func configureTableView() {
        self.viewControllerTableView.delegate = self
        self.viewControllerTableView.dataSource = self
    }
    
    func getUsersFromSingleton() {
        api.getUsers { (result) in
            
            switch result {
            case .failure(let error):
                print(error)
            
            case .success(let users):
                DispatchQueue.main.async {
                    self.users = users
                    self.viewControllerTableView.reloadData()
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    } 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

