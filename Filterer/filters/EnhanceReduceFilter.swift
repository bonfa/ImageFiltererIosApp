import UIKit

public class EnhanceReduceFilter: ImageFilter {

    private let redValue:Int8!
    private let greenValue:Int8!
    private let blueValue:Int8!
    
    public init() {
        self.redValue = 50
        self.greenValue = 0
        self.blueValue = 0
    }

    public init (redValue:Int8!, greenValue:Int8!, blueValue:Int8!) {
        self.redValue = redValue
        self.greenValue = greenValue
        self.blueValue = blueValue
    }
    
    public func filter(image:UIImage!) -> UIImage! {
        return SinglePixelFilter(with: enhanceChannelValue).filter(image)
    }
    
    private func enhanceChannelValue(inout of pixel:Pixel) {
        let red = UInt8(max(0, min(255, Int(pixel.red) + Int(redValue))))
        let green = UInt8(max(0, min(255, Int(pixel.green) + Int(greenValue))))
        let blue = UInt8(max(0, min(255, Int(pixel.blue) + Int(blueValue))))
        
        pixel.red = red
        pixel.green = green
        pixel.blue = blue
    }
    
}