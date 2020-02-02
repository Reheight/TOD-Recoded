//
//  SettingsViewController.swift
//  truthordare
//
//  Created by Dustin Palmatier on 1/30/20.
//  Copyright © 2020 Hexham Network. All rights reserved.
//

import UIKit
import SCSDKLoginKit
import FontAwesome_swift
import NotificationBannerSwift

private let reuseIdentifier = "SettingsCell"

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    var tableView: UITableView!
    var userInfoHeader: UserInfoHeader!
    
    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        getPhoneNumber()
    }

    // MARK: - Helper Functions
    
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.frame = view.frame
        
        let frame = CGRect(x: 0, y: 88, width: view.frame.width, height: 100)
        userInfoHeader = UserInfoHeader(frame: frame)
        tableView.tableHeaderView = userInfoHeader
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isModalInPresentation = false
        navigationItem.title = "Settings"
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isModalInPresentation = true
        self.navigationController?.navigationBar.backItem?.title = String.fontAwesomeIcon(name: .angleLeft)
        self.navigationController?.navigationBar.topItem?.title = ""
    }
    
    func configureUI() {
        configureTableView()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 10.0)
        self.navigationController?.navigationBar.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "Settings"
    }

}

extension UINavigationBar {
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 51)
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingsSection(rawValue: section) else { return 0 }
        
        switch section {
        case .Account: return AccountOptions.allCases.count
        case .Application: return ApplicationOptions.allCases.count
        case .Copyright: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(red: 55/255, green: 120/255, blue: 250/255, alpha: 1)
        let title = UILabel()
        title.font = UIFont.boldSystemFont(ofSize: 16)
        title.text = SettingsSection(rawValue: section)?.description
        title.textColor = .white
        view.addSubview(title)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerYAnchor.constraint(equalTo:view.centerYAnchor).isActive = true
        title.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSection(rawValue: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .Account:
            let account = AccountOptions(rawValue: indexPath.row)
            cell.sectionType = account
        case .Application:
            let application = ApplicationOptions(rawValue: indexPath.row)
            cell.sectionType = application
            cell.selectionStyle = .none
        case .Copyright:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingsSection(rawValue: indexPath.section) else { return }
        
        switch section {
        case .Account:
            tableView.deselectRow(at: indexPath, animated: true)
            AccountOptions(rawValue: indexPath.row)?.action()
            
            let shouldLaunchView: Bool = AccountOptions(rawValue: indexPath.row)?.shouldLaunchView ?? false
            
            if (shouldLaunchView) {
                guard let viewToLaunch: Int = AccountOptions(rawValue: indexPath.row)?.viewLaunched else { return }
                
                switch viewToLaunch {
                case 0:
                    DispatchQueue.main.async {
                        let account:UIViewController = (self.storyboard?.instantiateViewController(identifier: "accountView") as UIViewController?)!
                        self.navigationController?.pushViewController(account, animated: true)
                    }
                case 1:
                    let bannerQueue = NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1)
                    let banner = FloatingNotificationBanner(title: "This feature has not been finished!", subtitle: "Try again some other time!", style: .warning)
                    banner.show(queue: bannerQueue, cornerRadius: 10, shadowColor: UIColor.gray, shadowOpacity: 10, shadowBlurRadius: 10, shadowCornerRadius: 10)
                    
                    banner.dismissOnTap = true
                    banner.dismissOnSwipeUp = true
                case 2:
                    DispatchQueue.main.async {
                        let home:UIViewController = (self.storyboard?.instantiateViewController(identifier: "initializerView") as UIViewController?)!
                        home.modalPresentationStyle = .fullScreen
                        self.present(home, animated: true)
                    }
                default:
                    break
                }
            }
        case .Application:
            break
        case .Copyright:
            break
        }
    }
    
}

