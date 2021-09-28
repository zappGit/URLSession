//
//  TableViewController.swift
//  URLSession
//
//  Created by Артем Хребтов on 28.09.2021.
//

import UIKit

class TableViewController: UITableViewController {
    var post = [Post]()
    private let url = "https://jsonplaceholder.typicode.com/posts"
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    func getRequest(){
        NetworkManager.getRequestAlamofire(url: url) { posts in
            self.post = posts
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    func postRequest(){
        NetworkManager.postRequestAlamofire(url: url) { post in
            self.post = post
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return post.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TableViewCell
        let post = post[indexPath.row]
        
        cell.getTitle.text = post.title
        cell.getBody.text = post.body
        cell.getUserId.text = String(post.id)
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
