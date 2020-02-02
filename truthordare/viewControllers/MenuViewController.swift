//
//  MenuViewController.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/29/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import FontAwesome_swift
import SCSDKBitmojiKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

class MenuViewController: UIViewController {
    @IBOutlet weak var shareButton: UIView!
    @IBOutlet weak var shareIcon: UILabel!
    @IBOutlet weak var bitmojiIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButton()
        setupBitmoji()
    }
    
    func setupButton() {
        shareIcon.font = UIFont.fontAwesome(ofSize: 17, style: .regular)
        shareIcon.text = String.fontAwesomeIcon(name: .shareSquare)
        shareButton.layer.borderColor = UIColor.black.cgColor
        shareButton.clipsToBounds = true
        shareButton.layer.borderWidth = 1
        shareButton.layer.cornerRadius = 15
    }
    
    func setupBitmoji() {
        SCSDKBitmojiClient.fetchAvatarURL { (avatarURL: String?, error: Error?) in
            self.bitmojiIcon.downloaded(from: avatarURL ?? "error")
        }
        
        bitmojiIcon.layer.borderColor = UIColor.black.cgColor
        bitmojiIcon.clipsToBounds = true
        bitmojiIcon.layer.borderWidth = 1
        bitmojiIcon.layer.cornerRadius = bitmojiIcon.frame.width / 2
        
        let tapBitmojiGesture = UITapGestureRecognizer(target: self, action: #selector(self.launchSettings))
        
        bitmojiIcon.addGestureRecognizer(tapBitmojiGesture)
        bitmojiIcon.isUserInteractionEnabled = true
    }
    
    
    @objc
    func launchSettings() {
        DispatchQueue.main.async {
            let settings:UIViewController = (self.storyboard?.instantiateViewController(identifier: "settingsView") as UIViewController?)!
            let settingsNav = UINavigationController(rootViewController: settings)
            self.present(settingsNav, animated: true)
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
