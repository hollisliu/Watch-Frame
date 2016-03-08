//
//  SingleFrameViewController.swift
//  Watch Frame
//
//  Created by Hanjie Liu on 2/10/16.
//  Copyright © 2016 Hanjie Liu. All rights reserved.
//

import UIKit

class SingleFrameViewController: UIViewController {
    
    var size: watchSize?
    var screenShot: UIImage?
    
    let frame42 = UIImage(named: "42frame.png")
    let frame38 = UIImage(named: "38frame.png")
    
    var imageToExport: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController!.navigationBarHidden = false
        navigationController!.navigationBar.topItem?.title = "Export"

        setupLayer()
        creatFinalView()
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationController!.navigationBarHidden = false
    }
    
    @IBAction func export(sender: UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [imageToExport!], applicationActivities: nil)
        navigationController?.presentViewController(activityViewController, animated: true) {
            // ...
        }

    }
    
    func setupLayer(){
        let gradientLayerGreen = CAGradientLayer()
        gradientLayerGreen.frame = self.view.bounds
        
        gradientLayerGreen.colors = [UIColor(red: 189/255.0, green: 127/255.0, blue: 244/255.0, alpha: 0.7).CGColor as AnyObject, UIColor(red: 144/255.0, green: 19/255.0, blue: 254/255.0, alpha: 0.7).CGColor as AnyObject]
        
        gradientLayerGreen.startPoint = CGPoint(x: 0, y: 0)
        gradientLayerGreen.endPoint = CGPoint(x: 0.75, y: 1)
        
        self.view.layer.addSublayer(gradientLayerGreen)
    }
    
    func creatFinalView(){
        var finalView = UIImageView()
        
        switch size! {
        case .Big:
            finalView = addFrame(frame42!, drawPoint: CGPoint(x: 22, y: 27))
            imageToExport = finalView.image!
        case .Small:
            finalView = addFrame(frame38!, drawPoint: CGPoint(x: 19, y: 24))
            imageToExport = finalView.image!
        }
        

        self.view.addSubview(finalView)
        
        finalView.layer.shadowOffset = CGSizeMake(0, 3)
        finalView.layer.shadowRadius = 5.0
        finalView.layer.shadowOpacity = 0.8
    }
    
    func addFrame(outterFrame: UIImage, drawPoint: CGPoint) -> UIImageView{
        
        let frameSize = outterFrame.size
        
        UIGraphicsBeginImageContextWithOptions(frameSize, false, 0)
        outterFrame.drawAtPoint(CGPoint(x: 0, y: 0))
        
        guard let innerImage = screenShot else {fatalError("No inner image")}
        innerImage.drawAtPoint(drawPoint)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let tempView = UIImageView(frame: CGRectMake(0, 0, outterFrame.size.width/2, outterFrame.size.height/2))
        tempView.image = finalImage
        tempView.frame.origin = CGPoint(x: view.center.x - (tempView.bounds.size.width/2.0), y: view.center.y - (tempView.bounds.size.height/2.0))
        
        return tempView
    }
    
}
