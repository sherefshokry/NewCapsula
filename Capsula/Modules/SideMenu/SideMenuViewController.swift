//
//  SideMenuViewController.swift
//  Capsula
//
//  Created SherifShokry on 2/15/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import UIKit
import KVNProgress
import ViewAnimator
import Intercom


class SideMenuViewController: UIViewController {
    
    var presenter : ViewToPresenterSideMenuProtocol?
    @IBOutlet weak var tableView : UITableView!
    @IBOutlet weak var closeView : UIView!
    
     override func viewDidLoad() {
           super.viewDidLoad()
           self.presenter?.viewDidLoad()
       }
       
    
    override func viewWillLayoutSubviews() {
          super.viewWillLayoutSubviews()
          closeView.clipsToBounds = true
          closeView.layer.cornerRadius = 40
          closeView.layer.maskedCorners = [.layerMaxXMaxYCorner]
      }
    
      override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                
                if Utils.loadUser()?.accessToken ?? "" != "" {
                   Intercom.setLauncherVisible(true)
                }
            }
      
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.setNeedsStatusBarAppearanceUpdate()
//        if #available(iOS 13.0, *) {
//                      let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
//                       statusBar.backgroundColor = UIColor.init(codeString: "32475E")
//                       UIApplication.shared.keyWindow?.addSubview(statusBar)
//                  } else {
//                        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(codeString: "32475E")
//                  }
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        if #available(iOS 13.0, *) {
//                      let statusBar = UIView(frame: UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect.zero)
//                       statusBar.backgroundColor = UIColor.white
//                       UIApplication.shared.keyWindow?.addSubview(statusBar)
//                  } else {
//                        UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
//                  }
//    }
    
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
       private var state: State = .loading {
             didSet {
                 switch state {
                 case .ready:
                     KVNProgress.dismiss()
                 case .loading:
                      KVNProgress.show()
                 case .error(let error):
                     KVNProgress.dismiss()
                     self.showMessage(error)
                 }
             }
         }
    
    
}
extension SideMenuViewController : PresenterToViewSideMenuProtocol {
    
    
    func changeState(state: State) {
           self.state = state
       }
       
       
       func showPopUp(message: String) {
           self.showMessage(message)
        Utils.openLoginScreen(isDeliveryMan: false)
       }
       
       func reloadData() {
           self.tableView.reloadData()
       }

}

extension SideMenuViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.presenter?.numberOfMenuElementsRows ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let menuCell = tableView.dequeueReusableCell(withIdentifier:  SideMenuCell.identifier, for: indexPath) as! SideMenuCell
        self.presenter?.configureMenuElementCell(cell: menuCell, indexPath: indexPath)
        return menuCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.presenter?.didSelectElement(itemIndex: indexPath.row)
    }
}