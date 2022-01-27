//
//  IntroScreenViewController.swift
//  Actorpay
//
//  Created by iMac on 19/01/22.
//

import UIKit

class IntroScreenViewController: UIViewController {
    
    //MARK: - Properties -
    
    @IBOutlet weak var skipBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var previousBtn: UIButton!
    @IBOutlet weak var introImgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var getStartedButtonView: UIView!
    
    var selectedindex = 0
    
    //MARK: - Helper Functions -

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action:#selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        setUpIntroScreen()
    }
    
    // MARK: - Selectors -
    
    // Next Button Action
    @IBAction func nextBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if(selectedindex >= 4) {
            print("")
        } else {
            selectedindex = selectedindex + 1
            setUpIntroScreen()
        }
    }
    
    // Previous Button Action
    @IBAction func previousBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if(selectedindex <= 0) {
            print("")
        } else {
            selectedindex = selectedindex - 1
            setUpIntroScreen()
        }
    }
    
    // Skip Button Action
    @IBAction func skipBtnAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
        myApp.window?.rootViewController = newVC
    }
    
    // Get Started Button Action
    @IBAction func getStartedButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let newVC = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") as! UINavigationController
        myApp.window?.rootViewController = newVC
    }
    
    
    //MARK: - Helper Functions -
    
    // SetUp Intro Screen
    func setUpIntroScreen() {
        previousBtn.isHidden = selectedindex == 0 ? true : false
        self.getStartedButtonView.isHidden = selectedindex == 4 ? false : true
        self.nextBtn.isHidden = selectedindex == 4 ? true : false
        self.pageControl.currentPage = selectedindex;
        if selectedindex == 0{
            introImgView.image = UIImage(named:"intro-1")
            titleLabel.text = "Add Acount to Manage"
            descLabel.text = "An Order ID in this unique number associated with every our secure checkout"
        }else if selectedindex == 1{
            introImgView.image = UIImage(named:"intro-2")
            titleLabel.text = "Track your Activity"
            descLabel.text = "An Order ID in this unique number associated with every our secure checkout"
        }else if selectedindex == 2{
            introImgView.image = UIImage(named:"intro-3")
            titleLabel.text = "Make online Payment"
            descLabel.text = "An Order ID in this unique number associated with every our secure checkout"
        }else if selectedindex == 3{
            introImgView.image = UIImage(named:"intro-4")
            titleLabel.text = "Safely Withdraw"
            descLabel.text = "An Order ID in this unique number associated with every our secure checkout"
        }else if selectedindex == 4{
            introImgView.image = UIImage(named:"intro-5")
            titleLabel.text = "Quick Transfer"
            descLabel.text = "An Order ID in this unique number associated with every our secure checkout"
            // Show the "Let's Start" button in the last slide (with a fade in animation)
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                
            })
        }
    }
    
    // Swipe Gesture Action
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                
                if(selectedindex <= 0) {
                    print("")
                } else {
                    selectedindex = selectedindex - 1
                    setUpIntroScreen()
                }
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
                if(selectedindex >= 4) {
                    
                } else {
                    selectedindex = selectedindex + 1
                    setUpIntroScreen()
                }
                print("Swiped left")
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
}
