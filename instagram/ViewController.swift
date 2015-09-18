//
//  ViewController.swift
//  instagram
//
//  Created by Linghua Jin on 9/17/15.
//  Copyright (c) 2015 ljin. All rights reserved.
//

import UIKit
private let API = "https://api.instagram.com/v1/media/popular?client_id=76a883fbc0914c1c9469f2db25e9818a"
private let CELL_NAME="com.ljin.instagram.feedCell"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var feedsView: UITableView!
    
    var feeds:NSArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        feedsView.dataSource = self
        feedsView.delegate = self
        makeRequest()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(CELL_NAME) as! FeedCell;
        var feed = feeds[indexPath.row] as! NSDictionary
        cell.username.text = feed.valueForKeyPath("user.username") as? String
        
        let imgUrl = NSURL(string: feed.valueForKeyPath("images.low_resolution.url") as! String)!
        cell.feedImg.setImageWithURL(imgUrl)
        
        let userImgUrl = NSURL(string: feed.valueForKeyPath("user.profile_picture") as! String)!
        cell.userImg.setImageWithURL(userImgUrl)
        
        return cell
        
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }
    
    func makeRequest(){
        
        var url = NSURL(string:API)!
        
        var request = NSURLRequest(URL: url,cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval:5)
        
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            
            (data, response, error) -> Void in
            
            let dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary
            
            dispatch_async(dispatch_get_main_queue()) {
                
                self.feeds = dictionary!["data"] as! NSArray
                
//                NSLog("self.feeds \(self.feeds)")
                self.feedsView.reloadData()
                
            }
            
        }
        
        task.resume()
        
    }
    


}

