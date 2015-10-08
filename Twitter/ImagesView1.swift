//
//  ImagesView1.swift
//  Twitter
//
//  Created by Dave Vo on 9/14/15.
//  Copyright (c) 2015 Chau Vo. All rights reserved.
//

import UIKit

class ImagesView1: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    
//    var imageUrl: NSURL?
    
    var images = [NSURL]()

    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.userInteractionEnabled = true
        let tapImage = UITapGestureRecognizer(target: self, action: "tapImage:")
        imageView.addGestureRecognizer(tapImage)
    }
    
//    func tapImage(sender:UITapGestureRecognizer) {
//        TwitterHelper.sharedInstance.tapImage(self, images: images, index: 0)
//    }
}


extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}