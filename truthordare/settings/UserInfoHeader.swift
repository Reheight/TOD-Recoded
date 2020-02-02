//
//  UserInfoHeader.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/30/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import SCSDKBitmojiKit
import NotificationBannerSwift

class UserInfoHeader: UIView {
    
    // MARK: - Properties
    
    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        
        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
            let url = URL(string: avatarURL ?? "error")
            let data = try? Data(contentsOf: url!)
            iv.image = UIImage(data: data!)
        }
        return iv
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = DataStructure.sharedInstance.getDisplayName()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let idLabel: UILabel = {
        let label = UILabel()
        label.text = "Tap to copy ID"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc
    func copyID() {
        UIPasteboard.general.string = DataStructure.sharedInstance.getExternalId()
        let bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
        let banner = StatusBarNotificationBanner(title: "You successfully copied your ID!", style: .success)
        banner.show(queue: bannerQueue)
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let profileImageDimension: CGFloat = 60
        
        addSubview(profileImageView)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageDimension).isActive = true
        profileImageView.layer.cornerRadius = profileImageDimension / 2
        
        addSubview(usernameLabel)
        usernameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: -10).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        
        addSubview(idLabel)
        idLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor, constant: 10).isActive = true
        idLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(copyID))
        idLabel.addGestureRecognizer(tap)
        idLabel.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
