//
//  FilterViewController.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit
import Alamofire

class FilterViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeightConst: NSLayoutConstraint!
    
    var sortByArr: [String] = []
    var selectedIndex: Int = 0
    typealias comp = ((_ params: Parameters?) -> ())
    var completion:comp?
    var filterparm: Parameters?
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()
        topCorner(bgView: filterView, maskToBounds: true)
        sortByArr = ["Price Low to High","Price High To Low","Discount Low to High","Discount High To Low"]
        tblViewHeightConst.constant = CGFloat(sortByArr.count * 60)
        mainViewHeightConst.constant = CGFloat(sortByArr.count * 60)+50
        self.setUpTblView()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
    }
    
    //MARK: - Selectors -
    
    // Close Button Action
    @IBAction func closeBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        removeAnimate()
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Helper Functions -

    // SetUp TblView
    func setUpTblView() {
        tblView.delegate = self
        tblView.dataSource = self
    }
    
    // Present View With Animation
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    // Remove View With Animation
    func removeAnimate(){
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished){
                self.view.endEditing(true)
                self.view.removeFromSuperview()
            }
        });
    }
//    func getSortParam(index: Int) -> String{
//        switch index {
//        case 0:
//            return ""
//        default:
//            break
//        }
//    }
    
    // View End Editing
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(touches.first?.view != filterView){
            removeAnimate()
        }
    }

}

//MARK: - Extensions -

//MARK: TblView Setup
extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortByArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SortByTableViewCell", for: indexPath) as! SortByTableViewCell
        cell.titleLbl.text = sortByArr[indexPath.row]
        if (AppManager.shared.selectedSortIndex == indexPath.row) {
            cell.tickBtn.isHidden = false
        } else {
            cell.tickBtn.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        let param : Parameters = [
            "sortBy":"dealPrice",
            "asc": indexPath.row == 0 ? true : false
        ]
        AppManager.shared.selectedSortIndex = indexPath.row
        if let codeCompletion = completion {
            codeCompletion(param)
            removeAnimate()
            self.dismiss(animated: true, completion: nil)
        }        
        tableView.reloadData()
    }    
}
