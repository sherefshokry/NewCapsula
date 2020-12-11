//
//  PrivacyPolicy.swift
//  Capsula
//
//  Created by SherifShokry on 12/5/20.
//  Copyright © 2020 SherifShokry. All rights reserved.
//

import UIKit
import Moya
import KVNProgress


class PrivacyPolicyVC : UIViewController {
    
    var policyList = [Policy]()
    @IBOutlet weak var topView : UIView!
    @IBOutlet weak var tableView : UITableView!
    private let provider = MoyaProvider<HomeDataSource>()
    
    override func viewDidLoad() {
           super.viewDidLoad()
        getPolicyData()
       }
    
    override func viewWillLayoutSubviews() {
           super.viewWillLayoutSubviews()
           topView.clipsToBounds = true
           topView.layer.cornerRadius = 70
           topView.layer.maskedCorners = [.layerMinXMaxYCorner]
       }
    
    
    
    func getPolicyData() {
        KVNProgress.show()
        provider.request(.getPolicies) { [weak self] result in
            KVNProgress.dismiss()
            guard let self = self else { return }
            switch result {
            case .success(let response):
                do {
                    let policyData = try response.map(BaseResponse<PolicyResponse>.self)
                    self.policyList = policyData.data?.policyList ?? []
                    self.tableView.reloadData()
                    
                } catch(let catchError) {
                    self.showMessage(catchError.localizedDescription)
                }
            case .failure(let error):
                do{
                    if let body = try error.response?.mapJSON(){
                        let errorData = (body as! [String:Any])
                        self.showMessage((errorData["errors"] as? String) ?? "")
                        
                    }
                }catch{
                    self.showMessage(error.localizedDescription)
                }
            }
        }
        
    }
    
    
    
}



extension PrivacyPolicyVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return policyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PrivacyCell.identifier, for: indexPath) as! PrivacyCell
        cell.funcToLoad = { sender in
            let indexPath = tableView.indexPath(for: sender)
            self.updateView(index : indexPath?.row ?? 0)
        }
        cell.setData(content: policyList[indexPath.row])

        
        return cell
    }
    
    func updateView(index : Int) {
      var isExpanded = policyList[index].isExpanded
        isExpanded = !isExpanded
        policyList[index].isExpanded = isExpanded
        reloadWithoutAnimation(index: index)
    }

    
    func reloadWithoutAnimation(index : Int) {
        
     let indexPath = IndexPath(row: index, section: 0)
      tableView.reloadRows(at: [indexPath], with: .automatic)
        
    }
    
}
