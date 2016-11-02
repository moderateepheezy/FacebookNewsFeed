//
//  CustomTabBarController.swift
//  FacebookNewsFeed
//
//  Created by SimpuMind on 11/2/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        
        let feedController = FeedController(collectionViewLayout: layout)
        
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let friendRequestController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestController)
        secondNavigationController.title = "Requests"
        secondNavigationController.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messengerRequestController = UIViewController()
        messengerRequestController.navigationItem.title = "Messenger"
        let thirdNavigationController = UINavigationController(rootViewController: messengerRequestController)
        thirdNavigationController.title = "Messenger"
        thirdNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationRequestController = UIViewController()
        notificationRequestController.navigationItem.title = "Notifications"
        let fourthNavigationController = UINavigationController(rootViewController: notificationRequestController)
        fourthNavigationController.title = "Notifications"
        fourthNavigationController.tabBarItem.image = UIImage(named: "globe_icon")
        
        let loadMoreRequestController = UIViewController()
        loadMoreRequestController.navigationItem.title = "More"
        let fifthNavigationController = UINavigationController(rootViewController: loadMoreRequestController)
        fifthNavigationController.title = "More"
        fifthNavigationController.tabBarItem.image = UIImage(named: "more_icon")
        
        viewControllers.self = [navigationController, secondNavigationController, thirdNavigationController, fourthNavigationController, fifthNavigationController]
        
        tabBar.isTranslucent = false
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor
        
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
}
