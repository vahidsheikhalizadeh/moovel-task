//
//  UsersViewController.swift
//  moovel
//
//  Created by shick on 11.08.18.
//  Copyright © 2018 vahid. All rights reserved.
//

import UIKit
import Alamofire

struct Githubresult: Decodable{
    let totalCounts : Int
    let result : Bool
    let users : [User]
    
    enum CodingKeys: String, CodingKey {
        case totalCounts = "total_count"
        case result = "incomplete_results"
        case users = "items"
    }
}

struct User: Decodable {
    
    let userImage : URL
    let userName : String?
    var userUrl : URL?
    var location:String?
    var registrDate : String?
    var email : URL?
    
    enum CodingKeys: String, CodingKey {
        case userImage = "avatar_url"
        case userName = "login"
        case userUrl = "url"
        case registrDate = "created_at"
        case email, location
     
        
    }
    
}


class UsersViewController: UITableViewController {
    
    var users = [User]()
    
    @IBOutlet var userList: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        creatUserList()
        userList.register(UINib(nibName: "DataCell", bundle: nil),
                          forCellReuseIdentifier: DataCell.cellIdentifierName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return users.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: DataCell.cellIdentifierName, for: indexPath) as! DataCell

        getDetails(url: users[indexPath.row].userUrl!, row: indexPath.row)
        
        cell.setUserData(user: user)
        
        

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "showData", sender: self)
        
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
         let destinationVS = segue.destination as! DetailViewController
        
         if let indexPath = tableView.indexPathForSelectedRow {
            
            destinationVS.emailAddress = users[indexPath.row].email!
            
            // here write the data to the current sensor in realm
            
            
            
        }

         
    }
    
    
    
    //MARK: - Networking
    
     func creatUserList() {
        
        let urlString = "https://api.github.com/search/users?q=+language:java"
   
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, err) in
            
            DispatchQueue.main.async {
                
                if let err = err {
                    print("Failed to get data from url:", err)
                    return
                }
                
                guard let data = data else { return }
                
                do {
                    
                    let decoder = JSONDecoder()
    
                   let callResult = try decoder.decode(Githubresult.self, from: data)
                    
                    for jsonData in callResult.users {
                        
                        self.users.append(jsonData)
                        
                    }
                    
                    self.tableView.reloadData()
                    
                } catch let jsonErr {
                    
                    print("Failed to decode:", jsonErr)
                }
            }
            }.resume()
 }
    
    func getDetails(url : URL, row : Int){
 
        let headers : HTTPHeaders = ["Authorization": "token eaadb5e54655e223d8c70aaa8bb76a4396988274"]
        
        Alamofire.request(url,headers: headers).responseJSON { response in
            
            debugPrint(response)
        
            let decoder = JSONDecoder()
            do{
                let callResult = try decoder.decode(User.self, from: response.data!)
                self.users[row].registrDate = callResult.registrDate
                self.users[row].location = callResult.location
                self.users[row].email = callResult.email

            }
            catch let jsonError{
                print("Fail decoding user JSON:",jsonError)
            }
    
            }
        }
}

