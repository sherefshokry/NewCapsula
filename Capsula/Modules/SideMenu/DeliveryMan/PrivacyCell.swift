//
//  PrivacyPolicyCell.swift
//  Capsula
//
//  Created by SherifShokry on 12/5/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import UIKit

class PrivacyCell : UITableViewCell {
    
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var descriptionLabel : PaddedUILabel!
    @IBOutlet weak var arrowImage : UIImageView!
    @IBOutlet weak var stackView : UIStackView!
    var funcToLoad : ((UITableViewCell)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        stackView.addBackground(color: .white)
    }
    
    func setData(content : Policy){

        descriptionLabel.isHidden = !content.isExpanded

        if content.isExpanded {
            setStackViewInsets(status : true)
            arrowImage.image = #imageLiteral(resourceName: "icMinusFAQ")
        }else{
            setStackViewInsets(status : false)
            arrowImage.image = #imageLiteral(resourceName: "icPlusFAQ")
        }

        titleLabel.text = content.title ?? ""
        descriptionLabel.text = (content.subject ?? "")?.htmlToString
    }
    
    func setStackViewInsets(status : Bool){
        if status {
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 14, right: 16)
        }else{
            stackView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    @IBAction func expandViewPressed(_ sender : UIButton){
        
        if  funcToLoad != nil {
            funcToLoad!(self)
        }
    }
    
}
