//
//  SideMenuCell.swift
//  Capsula
//
//  Created by SherifShokry on 2/15/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import UIKit


class SideMenuCell : UITableViewCell{
    
    var isNotificationOff =  false
    @IBOutlet weak var sideMenuImage : UIImageView!
    @IBOutlet weak var sideMenuTitle : UILabel!
    @IBOutlet weak var notificationSwitch : UISwitch!
    
    func setData(sideMenuItem : SideMenu){
        
        sideMenuImage.image = sideMenuItem.elementIcon
        sideMenuTitle.text = sideMenuItem.elementText
        notificationSwitch.isOn = !isNotificationOff
        if sideMenuItem.elementText != Strings.SideMenu.shared.Notifications {
            notificationSwitch.isHidden = true
        }else{
            notificationSwitch.isHidden = false
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        isNotificationOff = UserDefaults.standard.bool(forKey: "NotificationOff")
    }
    
    
    @IBAction  func switchChanged(sender: UISwitch!) {
        print("Switch value is \(sender.isOn)")
        if(sender.isOn){
            UserDefaults.standard.set(false, forKey: "NotificationOff")
            UIApplication.shared.registerForRemoteNotifications()
        }
        else{
            UserDefaults.standard.set(true, forKey: "NotificationOff")
            UIApplication.shared.unregisterForRemoteNotifications()
        }
    }
    
    
}
