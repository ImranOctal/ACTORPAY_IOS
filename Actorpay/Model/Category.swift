//
//  Category.swift
//  Actorpay
//
//  Created by iMac on 02/12/21.
//

import Foundation
import UIKit

class Category {
    var icon: UIImage?
    var title = String()
    var color = UIColor()
    
    init(title: String, icon: UIImage?) {
        self.title = title
        self.icon = icon
    }
}
