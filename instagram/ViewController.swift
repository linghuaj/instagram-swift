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
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        feedsView.dataSource = self
        feedsView.delegate = self
        
        //        feedsView.separatorColor = UIColor.clearColor()
        makeRequest(){}
        initPullToRefresh()
    }
    
    /**
    * add the refresh control as a subview of the scrollview.
    * It's best to insert it at the lowest index so that it appears behind all the views in the scrollview.
    */
    func initPullToRefresh(){
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        feedsView.insertSubview(refreshControl, atIndex: 0)
    }
    
    
    func onRefresh() {
        //get current selected tag
        makeRequest(){
            self.refreshControl.endRefreshing()
        };
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
    
    
    //    func tableView
    
    func makeRequest(closure:()->()){
        
        var url = NSURL(string:API)!
        
        var request = NSURLRequest(URL: url,cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval:5)
        
        var task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            
            (data, response, error) -> Void in
            
            let dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as? NSDictionary
            
            dispatch_async(dispatch_get_main_queue()) {
                if let dictionary=dictionary{
                    self.feeds = dictionary["data"] as! NSArray
                    
                }
                self.feedsView.reloadData()
                closure()
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    
}

