//
//  Helper.swift
//  Collage
//
//  Created by Soham Bhattacharjee on 15/02/17.
//  Copyright © 2017 Soham Bhattacharjee. All rights reserved.
//

import Foundation
import UIKit

@objc protocol CollageViewDelegate {
    func onClickCollage(_ view: CollageView)
}
class CollageView: UIView {
    weak var delegate: CollageViewDelegate?
    var photoCount: CollagePhotoCount?
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var btnClick: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        blurView.isHidden = true
    }
    @IBInspectable var collageType: Int = 0 {
        didSet {
            switch collageType {
            case 1, 4:
                photoCount = CollagePhotoCount.Count6
                break
            case 2, 3:
                photoCount = CollagePhotoCount.Count3
                break
            case 5:
                photoCount = CollagePhotoCount.Count7
                break
            default:
                break
            }
        }
    }
    @IBAction func onClickSelect(_ sender: UIButton) {
        let rect = blurView.frame
        let insetRect = rect.insetBy(dx: 20, dy: 20)
        blurView.frame = insetRect
        blurView.isHidden = false
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.0, options: .curveEaseOut, animations: {
            self.blurView.frame = rect
        }) { (finished) in
            if self.delegate != nil {
                self.delegate!.onClickCollage(self)
            }
        }
    }
    deinit {
        print("Collage View Deinitialised")
    }
}
enum CollagePhotoCount: Int {
    case Count6 = 6, Count3 = 3, Count7 = 7
}
class CollageImageView: UIImageView {
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1.0
    }
}
extension UIView {
    public func getSnapshotImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        let snapshotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return snapshotImage
    }
    class func instanceFromNib(nibName: String) -> UIView {
        return UINib(nibName: nibName, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    class func loadFromNibNamed(nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }
}
extension UIImage {
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizedImage(newSize: newSize)
        return resized
    }
    /// Returns a image that fills in newSize
    func resizedImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect.init(x: 0.0, y: 0.0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}
