//
//  ProductDetailsCell.swift
//  Capsula
//
//  Created by SherifShokry on 4/28/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import UIKit


class ProductDetailsCell : UICollectionViewCell {
    
    
    @IBOutlet weak var productImage : UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var storeName : UILabel!
    @IBOutlet weak var productPieces : UILabel!
    @IBOutlet weak var productPrice : UILabel!
    @IBOutlet weak var productVat : UILabel!
    
    
    
    
   func setData(item : Item) {
        
    productImage.sd_setImage(with: URL.init(string: item.imagePath ?? ""))
    productName.text = item.productName ?? ""
    productPieces.text = "\(item.itemQuantity ?? 0) " + Strings.shared.Pieces
    storeName.text = item.storeName ?? ""
    productPrice.text = "\(item.price ?? 0.0) " + Strings.shared.RSD
    productVat.text = Strings.shared.VAT  + " \(item.vat ?? 0)%"
        
    }
    
    override func layoutSubviews() {
          super.layoutSubviews()
          self.productImage.layer.cornerRadius = 20
          self.productImage.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
      }
    
    
    
}
