import UIKit

public class SwitchChannelValuesFilter: ImageFilter {
    
    public enum MODE {
        case RED_TO_GREEN__GREEN_TO_BLUE__BLUE_TO_RED
        case RED_TO_BLUE__GREEN_TO_RED__BLUE_TO_GREEN
    }
    
    
    private let mode:MODE!
    
    public init () {
        self.mode = MODE.RED_TO_GREEN__GREEN_TO_BLUE__BLUE_TO_RED
    }
    
    public init(mode:MODE) {
        self.mode = mode
    }
    
    public func filter(image:UIImage!) -> UIImage! {
        return SinglePixelFilter(with: invertRgbFields).filter(image)
    }
    
    private func invertRgbFields(inout of pixel:Pixel) {
        
        if (mode == MODE.RED_TO_GREEN__GREEN_TO_BLUE__BLUE_TO_RED) {
            let red = pixel.red
            let green = pixel.green
            let blue = pixel.blue
            
            pixel.red = blue
            pixel.green = red
            pixel.blue = green
        }
        else if (mode == MODE.RED_TO_BLUE__GREEN_TO_RED__BLUE_TO_GREEN) {
            let red = pixel.red
            let green = pixel.green
            let blue = pixel.blue
            
            pixel.red = green
            pixel.green = blue
            pixel.blue = red
        }
        else {
            //should never arrive here
        }
        
    }
}