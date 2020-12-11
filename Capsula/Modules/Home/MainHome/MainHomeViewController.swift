//
//  MainHomeViewController.swift
//  Capsula
//
//  Created by SherifShokry on 12/28/19.
//  Copyright © 2019 SherifShokry. All rights reserved.
//
import UIKit
import KVNProgress
import ViewAnimator
import Intercom

class MainHomeViewController : UIViewController {
    let transition = CircularTransition()
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var noStoresLabel : UILabel!
    @IBOutlet weak var homeTapView : UIView!
    @IBOutlet weak var moreTapView : UIView!
    @IBOutlet weak var headerView : UIView!
    @IBOutlet weak var userNameLbl : UILabel!
    @IBOutlet weak var userImage : UIImageView!
    @IBOutlet weak var searchField : UITextField!
    @IBOutlet weak var cartView : UIView!
    @IBOutlet weak var cartNumberItemsLabel : UILabel!
    @IBOutlet weak var collectionView : UICollectionView!
    @IBAction func openCartScreen(_ sender : UIButton){
                
        let cartList  =  Utils.loadLocalCart() ?? []
              
              if cartList.count > 0 {
                  let vc = MainCartRouter.createModule()
                       
                            self.present(vc,animated: true, completion: nil)
                        
              }else{
                  UIApplication.shared.windows[0].visibleViewController?.showMessage(Strings.shared.cartMsg)
                  }
        
       }
    
    
    @IBAction func openNotificationScreen(_ sender : UIButton){
        let vc = NotificationListVC.instantiateFromStoryBoard(appStoryBoard: .Home)
        self.present(vc, animated: true, completion: nil)
       }
    
    
       
       
       @objc func recieveCartNotification(_ notification: NSNotification){
               updateCartView()
           }
           
               func updateCartView(){
                 let cartItems = Utils.loadLocalCart() ?? []
                 if (cartItems.count > 0){
                       cartView.isHidden = false
                       cartNumberItemsLabel.text = "\(cartItems.count)"
                 }else{
                      cartView.isHidden = true
                 }
                view.layoutIfNeeded()
             }
    
       @IBAction func itemSearchPressed(_ sender : UIButton){
        let vc = SearchItemRouter.createModule()
         
        self.present(vc,animated: true, completion: nil)
       }
  
    var presenter : ViewToPresenterMainHomeProtocol?
    private var state: State = .loading {
        didSet {
            switch state {
            case .ready:
               KVNProgress.dismiss()
               refreshControl.endRefreshing()
                collectionView.reloadData()
            case .loading:
               if !refreshControl.isRefreshing{
                KVNProgress.show(withStatus: "", on: self.view)
               }else{
                 collectionView.reloadData()
                }
            case .error(let error):
                KVNProgress.dismiss()
                refreshControl.endRefreshing()
                self.showMessage(error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeData()
        setupCollectionViewLayout()
        self.presenter?.viewDidLoad()
        self.presenter?.getStoresData()
        self.presenter?.refreshDevice()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshUserData(_:)),
                                                      name: NSNotification.Name(rawValue: Constants.REFRESH_USER_DATA), object: nil)
    }
    
    
    
    @objc func refreshUserData(_ notification: NSNotification){
           setHomeData()
    }
    
    func setupCollectionViewLayout(){
        collectionView.register(UINib.init(nibName: StoreCell.identifier, bundle: nil), forCellWithReuseIdentifier: StoreCell.identifier)
        
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        collectionView.addSubview(refreshControl)
        
    }
    
        @objc func refresh(_ sender: AnyObject) {
            self.presenter?.swipeToRefresh()
          }
    
    func setHomeData(){
        
        userNameLbl.text = Strings.shared.hello + " \(Utils.loadUser()?.user?.name ?? "") 👋🏻"
        userImage.sd_setImage(with: URL.init(string: Utils.loadUser()?.user?.photo ?? ""))
        //, placeholderImage: UIImage(named: "icPersonal")
                 
                 NotificationCenter.default.addObserver(self, selector: #selector(self.recieveCartNotification(_:)), name: NSNotification.Name(rawValue: Constants.CART_UPDATE_NOTIFICATION), object: nil)
                  updateCartView()
        
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        if Utils.loadUser()?.accessToken ?? "" != "" {
           Intercom.setLauncherVisible(true)
           Intercom.registerUser(withEmail: Utils.loadUser()?.user?.email ?? "")
        }
        if LocalizationSystem.sharedInstance.getLanguage() == "ar"{
                             searchField.textAlignment = .right
                         }else{
                             searchField.textAlignment = .left
                         }
           
        
    }
  
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        //   homeTapView.clipsToBounds = true
        homeTapView.layer.cornerRadius = 45
        homeTapView.layer.maskedCorners = [.layerMaxXMinYCorner]
        //  moreTapView.clipsToBounds = true
        moreTapView.layer.cornerRadius = 45
        moreTapView.layer.maskedCorners = [.layerMinXMinYCorner]
        
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 70
        headerView.layer.maskedCorners = [.layerMinXMaxYCorner]
    }
    
   
    @IBAction func morePressed(){
        let vc = SideMenuRouter.createModule()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
        
        
    
    }
    
}
extension MainHomeViewController : PresenterToViewMainHomeProtocol {
    func changeEmptyStoresStatus(isHidden: Bool) {
        noStoresLabel.isHidden = isHidden
    }
    
    func changeState(state: State) {
        self.state = state
    }
    
}

extension MainHomeViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.presenter?.numberOfRows ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: StoreCell.identifier, for: indexPath) as! StoreCell
         self.presenter?.configureStoreCell(cell: cell, indexPath: indexPath)
        
          return cell
    }
    
      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let collectionWidth = (self.collectionView.frame.width - 42) / 2
         return CGSize(width: collectionWidth, height: collectionWidth + 42)
     }
     
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         return UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
     }
     
     
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         self.presenter?.didSelectStore(indexPath: indexPath)
     }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
           self.presenter?.loadPagingData(indexPath: indexPath)
       }
}



extension MainHomeViewController : UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
       transition.transitionMode = .present
       transition.startingPoint = CGPoint.init(x: 0, y: 0)
        transition.circleColor = UIColor.init(codeString: "#0E518A")
        
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = CGPoint.init(x: 0, y: 0)
         transition.circleColor = UIColor.init(codeString: "#37B6FF")
        return transition
    }
    
}
