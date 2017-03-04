//
//  ViewController.swift
//  Filterer
//
//  Created by Jack on 2015-09-22.
//  Copyright © 2015 UofT. All rights reserved.
//

import UIKit

public enum FilterSelection {
    case EnhanceRed, EnhanceGreen, EnhanceBlue, Blur, SwitchChannel
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TouchDelegate {

    private var filteredImage: UIImage?
    private var originalImage: UIImage?
    private var isShowingOriginalImage: Bool = true
    private var selectedFilter : FilterSelection?
    
    @IBOutlet var originalImageView: UITouchableImageView!
    @IBOutlet var filteredImageView: UITouchableImageView!
    @IBOutlet var filterButton: UIButton!
    @IBOutlet var compareButton: UIButton!
    @IBOutlet var originalLabel: UILabel!
    @IBOutlet var secondaryMenu: UIView!
    @IBOutlet var bottomMenu: UIView!
    @IBOutlet var filterIntensityView: UIView!
    @IBOutlet var filterIntensityButton: UIButton!
    @IBOutlet var filterIntensitySlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterIntensitySlider.minimumValue = 0
        filterIntensitySlider.maximumValue = 1
        
        originalImage = UIImage(named: "scenery")
        secondaryMenu.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        secondaryMenu.translatesAutoresizingMaskIntoConstraints = false
        filterIntensityView.translatesAutoresizingMaskIntoConstraints = false
        isShowingOriginalImage = true
        compareButton.enabled = false
        filterIntensityButton.enabled = false
        originalImageView.setTouchDelegate(self)
        self.filteredImageView.alpha = 0.0
    }

    // MARK: Share
    @IBAction func onShare(sender: AnyObject) {
        unselectButton(filterButton)
        hideSecondaryMenu()
        unselectButton(filterIntensityButton)
        hideFilterIntensitySlider()
        let activityController = UIActivityViewController(activityItems: ["Check out our really cool app", originalImageView.image!], applicationActivities: nil)
        presentViewController(activityController, animated: true, completion: nil)
    }
    
    // MARK: New Photo
    @IBAction func onNewPhoto(sender: AnyObject) {
        unselectButton(filterButton)
        hideSecondaryMenu()
        unselectButton(filterIntensityButton)
        hideFilterIntensitySlider()
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
        hideFilterIntensitySlider()
        unselectButton(filterIntensityButton)
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
        let secondaryMenuContraints : [NSLayoutConstraint] = [bottomConstraint, leftConstraint, rightConstraint, heightConstraint]
        
        NSLayoutConstraint.activateConstraints(secondaryMenuContraints)
        
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
        selectedFilter = FilterSelection.EnhanceRed
        let enhanceReduceFilter:EnhanceReduceFilter = EnhanceReduceFilter(redValue: 50, greenValue: 0, blueValue: 0)
        filterImage(enhanceReduceFilter)
        filterIntensityButton.enabled = true
    }
    
    @IBAction func onEnhanceGreen(sender: AnyObject) {
        selectedFilter = FilterSelection.EnhanceGreen
        let enhanceReduceFilter:EnhanceReduceFilter = EnhanceReduceFilter(redValue: 0, greenValue: 50, blueValue: 0)
        filterImage(enhanceReduceFilter)
        filterIntensityButton.enabled = true
    }
    
    @IBAction func onEnhanceBlue(sender: AnyObject) {
        selectedFilter = FilterSelection.EnhanceBlue
        let enhanceReduceFilter:EnhanceReduceFilter = EnhanceReduceFilter(redValue: 0, greenValue: 0, blueValue: 50)
        filterImage(enhanceReduceFilter)
        filterIntensityButton.enabled = true
    }
    
    @IBAction func onBlur(sender: AnyObject) {
        selectedFilter = FilterSelection.Blur
        let meanFilter : MeanFilter = MeanFilter(size: 7);
        filterImage(meanFilter)
        filterIntensityButton.enabled = true
    }
    
    @IBAction func onSwitchChannelValues(sender: AnyObject) {
        selectedFilter = FilterSelection.SwitchChannel
        let switchChannelFilter : SwitchChannelValuesFilter = SwitchChannelValuesFilter(mode: SwitchChannelValuesFilter.MODE.RED_TO_GREEN__GREEN_TO_BLUE__BLUE_TO_RED);
        filterImage(switchChannelFilter)
        filterIntensityButton.enabled = false
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
    
    @IBAction func onEditFilterSelected(sender: UIButton) {
        unselectButton(filterButton)
        if (sender.selected) {
            hideFilterIntensitySlider()
            sender.selected = false
        }
        else {
            showFilterIntensitySlider()
            sender.selected = true
        }
    }
    
    func showFilterIntensitySlider() {
        filterIntensitySlider.value = 0.5
        hideSecondaryMenu()
        view.addSubview(filterIntensityView)
        
        let bottomConstraint = filterIntensityView.bottomAnchor.constraintEqualToAnchor(bottomMenu.topAnchor)
        let leftConstraint = filterIntensityView.leftAnchor.constraintEqualToAnchor(view.leftAnchor)
        let rightConstraint = filterIntensityView.rightAnchor.constraintEqualToAnchor(view.rightAnchor)

        NSLayoutConstraint.activateConstraints([rightConstraint, bottomConstraint, leftConstraint])
        
        view.layoutIfNeeded()
        
        self.filterIntensityView.alpha = 0
        UIView.animateWithDuration(0.4) {
            self.filterIntensityView.alpha = 1.0
        }
    }
    
    func hideFilterIntensitySlider() {
        UIView.animateWithDuration(0.4) {
            self.filterIntensityView.alpha = 0.0
        }
    }
    
    func selectButton(button:UIButton) {
        button.selected = true
    }
    
    func unselectButton(button:UIButton) {
        button.selected = false
    }

    @IBAction func onSliderValueChanged(sender: UISlider) {
        let sliderValue = sender.value
        let filter = getProperFilter(sliderValue);
        if (filter != nil) {
            filterImage(filter!)
        }
    }
    
    func getProperFilter(sliderValue : Float) -> ImageFilter? {
        switch(selectedFilter!) {
        case FilterSelection.EnhanceRed:
            return EnhanceReduceFilter(redValue: getIntensityValueforEnhancereduceFilter(sliderValue), greenValue: 0, blueValue: 0)
        case FilterSelection.EnhanceGreen:
            return EnhanceReduceFilter(redValue: 0 , greenValue: getIntensityValueforEnhancereduceFilter(sliderValue), blueValue: 0)
        case FilterSelection.EnhanceBlue:
            return EnhanceReduceFilter(redValue: 0 , greenValue: 0, blueValue: getIntensityValueforEnhancereduceFilter(sliderValue))
        case FilterSelection.Blur:
            return MeanFilter(size: getIntensityValueforMeanFilter(sliderValue))
        default:
            return nil
        }
    }
    
    func getIntensityValueforEnhancereduceFilter(sliderFilterValue : Float) -> Int8 {
        return (Int8) (100.0 * sliderFilterValue)
    }
    
    func getIntensityValueforMeanFilter(sliderFilterValue : Float) -> Int {
        let availableValues: [Int] = [3, 5, 7, 9, 11, 13]
        let index = Int(round(5 * sliderFilterValue))
        return availableValues[index]
    }
}

