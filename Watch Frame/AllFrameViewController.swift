//
//  AllFrameViewController.swift
//  Watch Frame
//
//  Created by Hanjie Liu on 3/10/16.
//  Copyright © 2016 Hanjie Liu. All rights reserved.
//

import UIKit
import Photos
import BSImagePicker

class AllFrameViewController: UIViewController {
    
    var validPhoto = 0
    var invalidPhoto = 0
    
    var validAssets = [PHAsset]()
    
    let frame42 = UIImage(named: "42frame.png")!
    let frame38 = UIImage(named: "38frame.png")!

    //MARK: - VC Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayer()
        self.determineStatus()

        let picker = BSImagePickerViewController()
        
        bs_presentImagePickerController(picker, animated: true,
                                            select: { (asset: PHAsset) -> Void in
            }, deselect: { (asset: PHAsset) -> Void in
            }, cancel: { (assets: [PHAsset]) -> Void in
            }, finish: { (assets: [PHAsset]) -> Void in
                for pic in assets{
                    if self.ifWatchScreenshot(pic).0{
                        self.validPhoto += 1
                        self.validAssets.append(pic)
                    }else{
                        self.invalidPhoto += 1
                    }
                }
        }, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBarHidden = false

        if validPhoto != 0 || invalidPhoto != 0{

            exportPhoto()
            self.popupAlert()
            self.validPhoto = 0
            self.invalidPhoto = 0
        }
    }
    
    //MARK: - Export
    func exportPhoto(){
        if validAssets.count == 0 {return}
        
        for asset in validAssets{
            let originalImg = self.PHAssetToUIImage(asset, size: self.ifWatchScreenshot(asset).1)
            let framedImg = self.creatFinalImage(originalImg, size: self.ifWatchScreenshot(asset).1)
            
            UIImageWriteToSavedPhotosAlbum(framedImg, nil, nil, nil)
        }
    }
    
    func popupAlert(){
        let optionMenu = UIAlertController(title: nil, message: NSLocalizedString("\(validPhoto) of the \(invalidPhoto + validPhoto) screenshots selected are valid.\n All valid screenshots have been framed and exported to your library", comment: ""), preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            self.navigationController?.popViewControllerAnimated(true)
        })
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)
    }
    
    //MARK: - Convert Image
    func ifWatchScreenshot(asset: PHAsset) -> (Bool, watchSize){
        if asset.mediaType != .Image {return (false, watchSize.Big)}
        
        if asset.pixelWidth == 312 && asset.pixelHeight == 390 {return (true, watchSize.Big)}
        if asset.pixelWidth == 272 && asset.pixelHeight == 340 {return (true, watchSize.Small)}

        return (false, watchSize.Big)
    }
    
    func PHAssetToUIImage(asset: PHAsset, size: watchSize) -> UIImage{
        let tSize = (size == watchSize.Big) ? CGSize(width: 312, height: 390) : CGSize(width: 272, height: 340)
        
        let manager = PHImageManager.defaultManager()
        let option = PHImageRequestOptions()
        var thumbnail = UIImage()
        option.synchronous = true
        manager.requestImageForAsset(asset, targetSize: tSize, contentMode: .AspectFit, options: option, resultHandler: {(result, info)->Void in
            thumbnail = result!
        })
        return thumbnail
    }
    
    func creatFinalImage(pic: UIImage, size: watchSize) -> UIImage{
        //var finalView = UIImageView()
        
        switch size {
        case .Big:
            return addFrame(pic, outterFrame: frame42, drawPoint: CGPoint(x: 22, y: 27))
        case .Small:
            return addFrame(pic, outterFrame: frame38, drawPoint: CGPoint(x: 19, y: 24))
        }
    }
    
    func addFrame(pic: UIImage, outterFrame: UIImage, drawPoint: CGPoint) -> UIImage{
        
        let frameSize = outterFrame.size
        
        UIGraphicsBeginImageContextWithOptions(frameSize, false, 0)
        outterFrame.drawAtPoint(CGPoint(x: 0, y: 0))
        
        pic.drawAtPoint(drawPoint)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return finalImage
    }

    //MARK: - Layer Setup
    func setupLayer(){
        let gradientLayerGreen = CAGradientLayer()
        
        gradientLayerGreen.frame = self.view.bounds
        
        gradientLayerGreen.colors = [UIColor(red: 188/255.0, green: 247/255.0, blue: 123/255.0, alpha: 1.0).CGColor as AnyObject, UIColor(red: 126/255.0, green: 211/255.0, blue: 33/255.0, alpha: 1.0).CGColor as AnyObject]
        
        gradientLayerGreen.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerGreen.endPoint = CGPoint(x: 0.75, y: 0.1)
        
        self.view.layer.addSublayer(gradientLayerGreen)
    }
    
    //MARK: - Determine Photo Auth Status
    func determineStatus() -> Bool {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .Authorized:
            return true
        case .NotDetermined:
            PHPhotoLibrary.requestAuthorization() {_ in}
            return false
        case .Restricted:
            return false
        case .Denied:
            let alert = UIAlertController(
                title: "Need Authorization",
                message: "Please go to Settings -> Privacy to authorize this app to use your Photo library",
                preferredStyle: .Alert)
            alert.addAction(UIAlertAction(
                title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated:true, completion:nil)
            return false
        }
    }
    
    

}
