//
//  TabBarViewController.swift
//  Actorpay
//
//  Created by iMac on 02/12/21.
//

import UIKit
import AVFoundation

class TabBarViewController: UITabBarController {

    //MARK:- Life Cycle Function -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            let appearance = tabBar.standardAppearance
            appearance.shadowImage = nil
            appearance.shadowColor = nil
            appearance.backgroundColor = .white
            tabBar.standardAppearance = appearance
            UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -10)
        }
        setTabState(whichTab: 2)
        setupMiddleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        selectedTabIndex = self.tabBarController?.selectedIndex ?? 0
    }

    
    // MARK: - Selectors -

    func setTabState(whichTab: Int) {
        let arrayOfTabBarItems = self.tabBar.items
        if let barItems = arrayOfTabBarItems {
            if barItems.count > 0 {
                let tabBarItem = barItems[whichTab]
                tabBarItem.isEnabled = false
            }
        }
    }
    
    @objc private func menuButtonAction(sender: UIButton) {
//        selectedIndex = 2
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QRCodeViewController") as! QRCodeViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK:- Helper Function -
    func setupMiddleButton() {
        let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = (view.bounds.height - menuButtonFrame.height) - ((ScreenSize.SCREEN_MAX_LENGTH >= 812.0) ? 50 : 20)
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        menuButton.frame = menuButtonFrame

        menuButton.backgroundColor = UIColor.init(hexFromString: "#2878B6")
        menuButton.layer.cornerRadius = menuButtonFrame.height/2
        view.addSubview(menuButton)

        menuButton.setImage(UIImage(named: "qr-code"), for: .normal)
        menuButton.addTarget(self, action: #selector(menuButtonAction(sender:)), for: .touchUpInside)

        view.layoutIfNeeded()
    }
    
}
