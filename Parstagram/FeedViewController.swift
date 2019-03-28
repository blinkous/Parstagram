//
//  FeedViewController.swift
//  Parstagram
//
//  Created by stargaze on 3/21/19.
//  Copyright © 2019 blinkous. All rights reserved.
//

import UIKit
import Parse
import AlamofireImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    // Create an empty array of PFObjects
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        // Refresh the view
        super.viewDidAppear(animated)
        
        let query = PFQuery(className:"Posts")
        // Allows us to load the objects: get the author, comments and for each comment the author related to it
        query.includeKeys(["author", "comments", "comments.author"])
        query.limit = 20
        
        query.findObjectsInBackground { (posts, error) in
            // If you find posts, get them and reload the view
            if posts != nil {
                self.posts = posts!
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Since we are working with sections, we no longer use indexPath.row to get the post, we use section
        let post = posts[section]
        
        // Since there is a chance that there is nothing in the comments section, if the optional (in the parenthesis) is nil set it to []
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        return comments.count + 1
    }
    
    // Give each post a section that can have any number of rows
    func numberOfSections(in tableView: UITableView) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Grab the data from the dictionary
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        // The post cell is always the 0th row, so here we set the post cell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
            
            let user = post["author"] as! PFUser
            
            // Set the labels
            cell.usernameLabel.text = user.username
            cell.captionLabel.text = post["caption"] as? String
            
            let imageFile = post["image"] as! PFFileObject
            let urlString = imageFile.url!
            let url = URL(string: urlString)
            
            cell.photoView.af_setImage(withURL: url!)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as! String
            
            let user = comment["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            return cell
        }
    }
    @IBAction func onLogoutButton(_ sender: Any) {
        // Log out the parse user
        PFUser.logOut()
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = main.instantiateViewController(withIdentifier: "LoginViewController")
        
        // Access the window via appdelegate
        // The app has access to a shared application object that will be casted as type AppDelegate because the AppDelegate.swift file has the window object
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        // Change the window to the login view controller
        delegate.window?.rootViewController = loginViewController
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Adding fake comments
        //Choose a post to add comments to
        let post = posts[indexPath.row]
        
        // Create the comments table if it's not there yet
        let comment = PFObject(className: "Comments")
        // Add text, the post, and author that the comment belongs to
        comment["text"] = "Random comment booyah!"
        comment["post"] = post
        comment["author"] = PFUser.current()!
        
        // Adding an array of comments to each comment
        post.add(comment, forKey: "comments")
        
        post.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Error saving comment")
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
