//
//  HomeHeaderCel.swift
//  Capsula
//
//  Created by SherifShokry on 2/2/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
import UIKit
import SDWebImage

class HomeDeliveryHeaderCell : UITableViewCell {
    
    
    var isActive =  true
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var deliverySwitch : UISwitch!
    var openNotificationPressed: (() -> ())?
    var onDeliveryStatusChanged :((Bool) -> ())?
    override func layoutSubviews() {
        super.layoutSubviews()
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 50
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        userNameLbl.text = Strings.shared.hello + " \(Utils.loadDeliveryUser()?.user?.fullName ?? "") 👋🏻"
        userImage.sd_setImage(with: URL.init(string: Utils.loadDeliveryUser()?.user?.personalPicture ?? ""), placeholderImage: UIImage(named: "icPersonal"))
        
        
        isActive = UserDefaults.standard.bool(forKey: "IsDeliveryOutOfService")
        deliverySwitch.isOn = !isActive
        
    }
    

    
    @IBAction func openNotification(_ sender : UIButton){
        if openNotificationPressed != nil {
            self.openNotificationPressed?()
        }
        
    }
    
    
    @IBAction  func switchChanged(sender: UISwitch!) {
         print("Switch value is \(sender.isOn)")
       
        if onDeliveryStatusChanged != nil {
            self.onDeliveryStatusChanged?(!sender.isOn)
        }
        
     }
    
    
}
