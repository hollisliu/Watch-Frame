//
//  ViewController.swift
//  Watch Frame
//
//  Created by Hanjie Liu on 1/31/16.
//  Copyright © 2016 Hanjie Liu. All rights reserved.
//

import UIKit

enum watchSize{
    case Big
    case Small
}

class SelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var size: watchSize?
    var screenshot: UIImage?
    
    var singlePhotoView = UIView()
    var batchPhotoView = UIView()
    
    let gradientLayerPurple = CAGradientLayer()
    let gradientLayerGreen = CAGradientLayer()
    
    let imagePicker = UIImagePickerController()
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let locationPoint = touches.first?.locationInView(singlePhotoView)
        
        if CGRectContainsPoint(singlePhotoView.bounds, locationPoint!){
            addFrameToSinglePhoto()
        }else{
            self.performSegueWithIdentifier("toAll", sender: self)
        }
    }
    
    func addFrameToSinglePhoto(){
        imagePicker.sourceType = .PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        dismissViewControllerAnimated(true, completion: { () -> Void in
            
            if image.size == CGSize(width: 312, height: 390){
                self.size = .Big
                self.screenshot = image
                self.performSegueWithIdentifier("toSingle", sender: self)
                
            }else if image.size == CGSize(width: 272, height: 340){
                self.size = .Small
                self.screenshot = image
                self.performSegueWithIdentifier("toSingle", sender: self)
                
            }else{
                let optionMenu = UIAlertController(title: nil, message: NSLocalizedString("The Selected Picture Is Not An Apple Watch Screenshot.\n Please Choose A New One", comment: ""), preferredStyle: .Alert)
                
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: {
                    (alert: UIAlertAction!) -> Void in
                })
                optionMenu.addAction(cancelAction)
                
                self.presentViewController(optionMenu, animated: true, completion: nil)
            }
        })
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        
        setUpViews()
        setUpLayer()
        addPictures()
        addLabels()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBarHidden = true
    }
    
    //MARK: - View Setup
    
    func setUpViews(){
        singlePhotoView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: view.bounds.width, height: view.bounds.height / 2)))
        
        batchPhotoView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: self.view.bounds.height / 2), size: CGSize(width: view.bounds.width, height: view.bounds.height / 2)))
        
        view.addSubview(singlePhotoView)
        view.addSubview(batchPhotoView)
    }
    
    func addPictures(){
        let framePic = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 70)))
        framePic.center = CGPoint(x: singlePhotoView.center.x, y: singlePhotoView.center.y - 30)
        framePic.image = UIImage(named: "frame")
        framePic.contentMode = UIViewContentMode.ScaleAspectFit

        singlePhotoView.addSubview(framePic)
        
        
        let flowerPic = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 60, height: 70)))
        flowerPic.center = CGPoint(x: singlePhotoView.center.x, y: singlePhotoView.center.y - 30)
        flowerPic.image = UIImage(named: "flower")
        flowerPic.contentMode = UIViewContentMode.ScaleAspectFit
        
        batchPhotoView.addSubview(flowerPic)
    }
    
    func addLabels(){
        let singleLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 140, height: 70)))
        singleLabel.center = CGPoint(x: singlePhotoView.center.x, y: singlePhotoView.center.y + 30)
        
        singleLabel.text = "Add Frame to One Watch Screenshot"
        singleLabel.textColor = UIColor.whiteColor()
        singleLabel.textAlignment = NSTextAlignment.Center
        singleLabel.adjustsFontSizeToFitWidth = true
        singleLabel.numberOfLines = 2
        
        singlePhotoView.addSubview(singleLabel)
        
        
        let batchLabel = UILabel(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 140, height: 70)))
        batchLabel.center = CGPoint(x: singlePhotoView.center.x, y: singlePhotoView.center.y + 40)
        
        batchLabel.text = "Add Frames to All Watch Screenshots on This iPhone"
        batchLabel.textColor = UIColor.whiteColor()
        batchLabel.textAlignment = NSTextAlignment.Center
        batchLabel.adjustsFontSizeToFitWidth = true
        batchLabel.numberOfLines = 3
        
        batchPhotoView.addSubview(batchLabel)
    }
    
    func setUpLayer() {
        // - purple layer below -
        
        gradientLayerPurple.frame = singlePhotoView.bounds
        
        gradientLayerPurple.colors = [UIColor(red: 189/255.0, green: 127/255.0, blue: 244/255.0, alpha: 1.0).CGColor as AnyObject, UIColor(red: 144/255.0, green: 19/255.0, blue: 254/255.0, alpha: 1.0).CGColor as AnyObject]
        
        gradientLayerPurple.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerPurple.endPoint = CGPoint(x: 0.75, y: 1)

        singlePhotoView.layer.addSublayer(gradientLayerPurple)
        
        // - green layer below -
        
        gradientLayerGreen.frame = batchPhotoView.bounds
        
        gradientLayerGreen.colors = [UIColor(red: 188/255.0, green: 247/255.0, blue: 123/255.0, alpha: 1.0).CGColor as AnyObject, UIColor(red: 126/255.0, green: 211/255.0, blue: 33/255.0, alpha: 1.0).CGColor as AnyObject]
        
        gradientLayerGreen.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerGreen.endPoint = CGPoint(x: 0.5, y: 0.3)
        
        batchPhotoView.layer.addSublayer(gradientLayerGreen)
    }
    
    //MARK: - Others

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSingle"{
            let des = segue.destinationViewController as! SingleFrameViewController
            des.size = size
            des.screenShot = screenshot
        }
    }
    
}

