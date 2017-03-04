//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TouchDelegate {

    private var filteredImage: UIImage?
    private var originalImage: UIImage?
    private var isShowingOriginalImage: Bool = true
    
    @IBOutlet var originalImageView: UITouchableImageView!
    @IBOutlet var filteredImageView: UITouchableImageView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var originalLabel: UILabel!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        originalImage = UIImage(named: "scenery")
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        isShowingOriginalImage = true
        compareButton.enabled = false
        originalImageView.setTouchDelegate(self)
        self.filteredImageView.alpha = 0.0
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", originalImageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "New Photo", message: nil, preferredStyle: .ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .Default, handler: { action in
            self.showCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Album", style: .Default, handler: { action in
            self.showAlbum()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
    }
    
    func showCamera() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .Camera
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    func showAlbum() {
        let cameraPicker = UIImagePickerController()
        cameraPicker.delegate = self
        cameraPicker.sourceType = .PhotoLibrary
        
        presentViewController(cameraPicker, animated: true, completion: nil)
    }
    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismissViewControllerAnimated(true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            originalImageView.image = image
            originalImage = image
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Filter Menu
    @IBAction func onFilter(sender: UIButton) {
        if (sender.selected) {
            hideSecondaryMenu()
            sender.selected = false
        } else {
            showSecondaryMenu()
            sender.selected = true
        }
    }
    
    func showSecondaryMenu() {
        view.addSubview(secondaryMenu)
        
        let bottomConstraint = secondaryMenu.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = secondaryMenu.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = secondaryMenu.rightAnchor.constraintEqualToAnchor(view.rightAnchor)
        
        let heightConstraint = secondaryMenu.heightAnchor.constraintEqualToConstant(44)
        
        NSLayoutConstraint.activateConstraints([bottomConstraint, leftConstraint, rightConstraint, heightConstraint])
        
        view.layoutIfNeeded()
        
        self.secondaryMenu.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.secondaryMenu.alpha = 1.0
        }
    }

    func hideSecondaryMenu() {
        UIView.animateWithDuration(0.4, animations: {
            self.secondaryMenu.alpha = 0
            }) { completed in
                if completed == true {
                    self.secondaryMenu.removeFromSuperview()
                }
        }
    }
    
    func filterImage(imageFilter: ImageFilter) {
        if (originalImage != nil) {
            enableCompareButton()
            filteredImage = imageFilter.filter(originalImage!)
            showFilteredImage()
            isShowingOriginalImage = false
        }
    }
    
    func enableCompareButton() {
        compareButton.enabled = true
    }

    @IBAction func compareSelected(sender: AnyObject) {
        if isShowingOriginalImage {
            showFilteredImage()
        }
        else {
            showOriginalImage()
        }
        isShowingOriginalImage = !isShowingOriginalImage
    }
    
    @IBAction func onEnhanceRed(sender: AnyObject) {
        let enhanceReduceFilter:EnhanceReduceFilter = EnhanceReduceFilter(redValue: 50, greenValue: 0, blueValue: 0)
        filterImage(enhanceReduceFilter)
    }
    
    @IBAction func onEnhanceGreen(sender: AnyObject) {
        let enhanceReduceFilter:EnhanceReduceFilter = EnhanceReduceFilter(redValue: 0, greenValue: 50, blueValue: 0)
        filterImage(enhanceReduceFilter)
    }
    
    @IBAction func onEnhanceBlue(sender: AnyObject) {
        let enhanceReduceFilter:EnhanceReduceFilter = EnhanceReduceFilter(redValue: 0, greenValue: 0, blueValue: 50)
        filterImage(enhanceReduceFilter)
    }
    
    @IBAction func onBlur(sender: AnyObject) {
        let meanFilter : MeanFilter = MeanFilter(size: 5);
        filterImage(meanFilter)
    }
    
    @IBAction func onSwitchChannelValues(sender: AnyObject) {
        let switchChannelFilter : SwitchChannelValuesFilter = SwitchChannelValuesFilter(mode: SwitchChannelValuesFilter.MODE.RED_TO_GREEN__GREEN_TO_BLUE__BLUE_TO_RED);
        filterImage(switchChannelFilter)
    }
    
    func onTouchesBegan() {
        if (filteredImage != nil && !isShowingOriginalImage) {
            showOriginalImage()
        }
    }
    
    func onTouchesEnded() {
        if (filteredImage != nil && !isShowingOriginalImage) {
            showFilteredImage()
        }
    }
    
    func showFilteredImage() {
        filteredImageView.image = filteredImage
        UIView.animateWithDuration(0.4, animations: {
            self.filteredImageView.alpha = 1.0
        })
    }
    
    func showOriginalImage() {
        UIView.animateWithDuration(0.4, animations: {
            self.filteredImageView.alpha = 0.0
        })
    }
}

