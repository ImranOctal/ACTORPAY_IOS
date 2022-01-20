//
//  FilterViewController.swift
//  Actorpay
//
//  Created by iMac on 04/01/22.
//

import UIKit

class FilterViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var tblViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeightConst: NSLayoutConstraint!
    
    var sortByArr: [String] = []
    
    //MARK: - Life Cycles -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        topCorner(bgView: filterView, maskToBounds: true)
        sortByArr = ["Price Low to High","Price High To Low","Discount Low to High","Discount High To Low"]
        tblViewHeightConst.constant = CGFloat(sortByArr.count * 50)
        mainViewHeightConst.constant = CGFloat(sortByArr.count * 60)+100
        self.setUpTblView()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.showAnimate()
    }
    
    //MARK: - Selectors -
    
    // Close Button Action
    @IBAction func closeBtnAction(_ sender: UIButton) {
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
                self.view.removeFromSuperview()
            }
        });
    }
    
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
