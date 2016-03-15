//
//  AllFrameViewController.swift
//  Watch Frame
//
//  Created by Hanjie Liu on 3/10/16.
//  Copyright © 2016 Hanjie Liu. All rights reserved.
//

import UIKit
import BSImagePicker

class AllFrameViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //navigationController!.navigationBarHidden = false

        let picker = BSImagePickerViewController()
        
        //self.presentViewController(picker, animated: true, completion: nil)
        bs_presentImagePickerController(picker, animated: true,
                                            select: { (asset: PHAsset) -> Void in
            }, deselect: { (asset: PHAsset) -> Void in
            }, cancel: { (assets: [PHAsset]) -> Void in
            }, finish: { (assets: [PHAsset]) -> Void in
                for pic in assets{
                    if self.ifWatchScreenshot(pic){
                        print("here is a valid screen shot")
                    }else{
                        print("This is not")
                    }
                }
            }, completion: nil)
    }
    
    func ifWatchScreenshot(asset: PHAsset) -> Bool{
        if asset.mediaType != .Image {return false}
        if asset.mediaSubtypes != .PhotoScreenshot {return false}
        
        if asset.pixelWidth == 312 && asset.pixelHeight == 390 {return true}
        if asset.pixelWidth == 272 && asset.pixelHeight == 340 {return true}

        return false
    }

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
