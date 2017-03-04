import UIKit

public class MeanFilter: ImageFilter {

    private let size:Int!
    
    public init() {
        self.size = 3
    }
    
    public init (size:Int!) {
        self.size = size
    }
    
    public func filter(image:UIImage!) -> UIImage! {
        let imageRgba = RGBAImage(image: image)!
        var destinationImage = RGBAImage(image: image)!
        for y in 0..<imageRgba.height {
            for x in 0..<imageRgba.width {
                let pixel = meanValue(x, y:y, image:imageRgba);
                let index = y * imageRgba.width + x
                destinationImage.pixels[index] = pixel
            }
        }
        return destinationImage.toUIImage()!
    }
    
    private func meanValue(x:Int, y:Int, image: RGBAImage) -> Pixel! {
        let index = y * image.width + x
        var pixel = image.pixels[index]
        let ray:Int = size / 2;
        
        var r:UInt32 = 0
        var g:UInt32 = 0
        var b:UInt32 = 0
        var numberOfPixel:Int = 0;
        for currentY in max(0,y-ray)..<min(y+ray, image.height) {
            for currentX in max(0,x-ray)..<min(x+ray, image.width) {
                numberOfPixel = numberOfPixel + 1
                let currentIndex = currentY * image.width + currentX
                var currentPixel = image.pixels[currentIndex]
                r = r + UInt32(currentPixel.red)
                g = g + UInt32(currentPixel.green)
                b = b + UInt32(currentPixel.blue)
            }
        }
        
        r = UInt32(r/UInt32(numberOfPixel))
        g = UInt32(g/UInt32(numberOfPixel))
        b = UInt32(b/UInt32(numberOfPixel))
        
        let red = UInt8(max(0, min(255, r)))
        let green = UInt8(max(0, min(255, g)))
        let blue = UInt8(max(0, min(255, b)))
        
        pixel.red = red
        pixel.green = green
        pixel.blue = blue
        
        return pixel
    }
}