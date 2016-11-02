//
//  FeedCell.swift
//  FacebookNewsFeed
//
//  Created by SimpuMind on 11/2/16.
//  Copyright © 2016 SimpuMind. All rights reserved.
//

import UIKit


var imageCache = NSCache<AnyObject, AnyObject>()

class FeedCell: UICollectionViewCell{
    
    var feedController: FeedController?
    
    func animate(){
        feedController?.animateImageView(statusImageView: statusImageView)
    }
    
    var post: Post?{
        didSet{
            statusImageView.image = nil
            loader.startAnimating()
            
            if let statusImageUrl = post?.statusImageUrl{
                
                if let image = imageCache.object(forKey: statusImageUrl as AnyObject) as? UIImage{
                    statusImageView.image = image
                    loader.stopAnimating()
                }else{
                    URLSession.shared.dataTask(with: URL(string: statusImageUrl)!, completionHandler: { (data, response, error) in
                        
                        if error != nil{
                            print("\(error)")
                            return
                        }
                        
                        let image = UIImage(data: data!)
                        imageCache.setObject(image!, forKey: statusImageUrl as AnyObject)
                        
                        DispatchQueue.main.async {
                            self.statusImageView.image = image
                            self.loader.stopAnimating()
                        }
                    }).resume()
                }
            }
            
            setupPostDetailViews()
        }
    }
    
    fileprivate func setupPostDetailViews(){
        if let name = post?.name{
            let attributedText = NSMutableAttributedString(string: name, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: "\nDecember 18 - San Francisco - ", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12), NSForegroundColorAttributeName: UIColor.rgb(red: 155, green: 161, blue: 171)]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0,length: attributedText.string.characters.count))
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "globe_small")
            attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            attributedText.append(NSAttributedString(attachment: attachment))
            
            nameLabel.attributedText = attributedText
        }
        
        if let statusText = post?.statusText{
            statusTextView.text = statusText
        }
        
        if let profileImageName = post?.profileImageName{
            profileImageView.image = UIImage(named: profileImageName)
        }
        
        if let statusImageName = post?.statusImageName {
            statusImageView.image = UIImage(named: statusImageName)
        }
        
        if let numLikes = post?.numLikes, let numComments = post?.numComments {
            likesCommentLabel.text = "\(numLikes) Likes  \(numComments) Comments"
        }
    }
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupViews()
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "zuckprofile")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .red
        return imageView
    }()
    
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Meanwhile, Beast turned to the other side"
        UIFont.systemFont(ofSize: 12)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "zuckdog")
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let likesCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "400 likes     10.7k Comments"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor .rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let dividerViewLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton = FeedCell.buttonForTitle(title: "Like", imageName: "like")
    let commentButton = FeedCell.buttonForTitle(title: "Comment", imageName: "comment")
    let shareButton = FeedCell.buttonForTitle(title: "Share", imageName: "share")
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 163), for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    func setupViews(){
        backgroundColor = UIColor.white
        addSubview(nameLabel)
        addSubview(profileImageView)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentLabel)
        addSubview(dividerViewLine)
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        setupStatusImageViewLoader()
        
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageView, nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentLabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerViewLine)
        
        //button constraints
        addConstraintsWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        
        
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.4)][v5(44)]|", views: profileImageView, statusTextView, statusImageView, likesCommentLabel, dividerViewLine, likeButton)
        
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = .black
        statusImageView.addSubview(loader)
        statusImageView.addConstraintsWithFormat(format: "H:|[v0]|", views: loader)
        statusImageView.addConstraintsWithFormat(format: "V:|[v0]|", views: loader)
    }

    
}

