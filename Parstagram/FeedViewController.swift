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
import MessageInputBar

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MessageInputBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    let commentBar = MessageInputBar()
    var showsCommentBar = false
    var selectedPost: PFObject!
    
    // Create an empty array of PFObjects
    var posts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentBar.inputTextView.placeholder = "Add a comment..."
        commentBar.sendButton.title = "Post"
        commentBar.delegate = self

        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // For the comment bar to be dismissed by dragging down the tableview
        tableView.keyboardDismissMode = .interactive
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillBeHidden(note:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Create the comment
        
        let comment = PFObject(className: "Comments")
        // Add text, the post, and author that the comment belongs to
        comment["text"] = text
        comment["post"] = selectedPost
        comment["author"] = PFUser.current()!

        // Adding an array of comments to each comment
        selectedPost.add(comment, forKey: "comments")

        selectedPost.saveInBackground { (success, error) in
            if success {
                print("Comment saved")
            } else {
                print("Error saving comment")
            }
        }
        tableView.reloadData()
        
        // Clear and dismiss the input
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
        commentBar.inputTextView.resignFirstResponder()
    }
    
    // To disappear keyboard after it is brought up
    @objc func keyboardWillBeHidden(note: Notification) {
        commentBar.inputTextView.text = nil
        showsCommentBar = false
        becomeFirstResponder()
    }
    
    // For the comment bar, this kind of hacks the standard iOS framework
    override var inputAccessoryView: UIView? {
        return commentBar
    }
    override var canBecomeFirstResponder: Bool {
        return showsCommentBar
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
        // Since we are working with sections, we don't use indexPath.row to get the post, we use section
        let post = posts[section]
        
        // Since there is a chance that there is nothing in the comments section, if the optional (in the parenthesis) is nil set it to []
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        // Add 2 because we also want to show the "add a comment cell
        return comments.count + 2
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
        } else if indexPath.row <= comments.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
            
            let comment = comments[indexPath.row - 1]
            cell.commentLabel.text = comment["text"] as? String
            
            let user = comment["author"] as! PFUser
            cell.usernameLabel.text = user.username
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell")!
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
        //Choose a post to add comments to
        let post = posts[indexPath.section]
        let comments = (post["comments"] as? [PFObject]) ?? []
        
        // If you're the last cell show the keyboard comment thing
         if indexPath.row == comments.count + 1{
            showsCommentBar = true
            becomeFirstResponder()
            // Raise the keyboard
            commentBar.inputTextView.becomeFirstResponder()
            
            selectedPost = post
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
