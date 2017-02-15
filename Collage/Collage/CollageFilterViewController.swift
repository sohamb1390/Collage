//
//  CollageFilterViewController.swift
//  Collage
//
//  Created by Soham Bhattacharjee on 15/02/17.
//  Copyright © 2017 Soham Bhattacharjee. All rights reserved.
//

import UIKit
import PKHUD

class CollageFilterViewController: UIViewController {

    // MARK: Variables
    var imageArray: [UIImage] = []
    var imageViewArray: [CollageImageView] = []
    var collageType: Int = 0
    @IBOutlet weak var containerView: UIView!


    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if collageType != 0 {
            updateUI()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Update
    func updateUI() {
        
        title = "your Collage"
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCollage))
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        if let collageView = CollageView.loadFromNibNamed(nibNamed: "CollageType\(collageType)", bundle: nil) as? CollageView {
            collageView.frame = CGRect(x: 0.0, y: 0.0, width: containerView.frame.size.width, height: containerView.frame.size.height)
            collageView.btnClick.isHidden = true
            containerView.addSubview(collageView)
            insertImage(view: collageView)
        }
    }
    func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    func saveCollage() {
        let image = containerView.getSnapshotImage()
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        HUD.flash((.label("Image saved to Camera Roll")), delay: 0.5)
    }
    
    func insertImage(view: CollageView) {
        getSubviewsOfView(v: view)
        
        if imageArray.count == imageViewArray.count {
            for (index, image) in imageArray.enumerated() {
                let imageViewSize = imageViewArray[index].frame.size
                if imageViewSize.width > image.size.width {
                    imageViewArray[index].contentMode = .scaleAspectFit
                }
                else {
                    imageViewArray[index].contentMode = .scaleAspectFill
                }
                imageViewArray[index].image = image
            }
            
        }
        print(imageViewArray)
    }
    func getSubviewsOfView(v: UIView) {
        for subview in v.subviews {
            if subview is CollageImageView {
                imageViewArray.append(subview as! CollageImageView)
            }
            else {
                getSubviewsOfView(v: subview)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
