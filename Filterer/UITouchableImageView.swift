//
//  File.swift
//  Filterer
//
//  Created by Francesco Bonfadelli on 03/03/2017.
//  Copyright © 2017 UofT. All rights reserved.
//

import Foundation
import UIKit

public protocol TouchDelegate {
    func onTouchesBegan()
    func onTouchesEnded()
}

public class UITouchableImageView : UIImageView {
    
    private var touchDelegate: TouchDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        enableUserInteraction()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func enableUserInteraction() {
        self.userInteractionEnabled = true;
    }
    
    override public func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touchDelegate != nil) {
            touchDelegate!.onTouchesBegan()
        }
        
    }
    
    override public func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (touchDelegate != nil) {
            touchDelegate!.onTouchesEnded()
        }
    }
    
    func setTouchDelegate(toAdd: TouchDelegate) {
        self.touchDelegate = toAdd
    }
    
    func removeTouchDelegate() {
        self.touchDelegate = nil
    }
}
