import UIKit

public class SinglePixelFilter {

    let singlePixelProcessOperation : (inout pixel:Pixel) -> Void!
    
    public init(with singlePixelProcessOperation: (inout pixel:Pixel) -> Void!) {
        self.singlePixelProcessOperation = singlePixelProcessOperation
    }
    
    public func filter(image:UIImage!) -> UIImage! {
        var imageRgba = RGBAImage(image: image)!
        for y in 0..<imageRgba.height {
            for x in 0..<imageRgba.width {
                processPixelAt(x, y:y, of: &imageRgba)
            }
        }
        return imageRgba.toUIImage()!
    }
    
    private func processPixelAt(x:Int, y:Int, inout of imageRgba: RGBAImage) {
        var pixel = getPixelAt(x, y: y, of:imageRgba)
        singlePixelProcessOperation(pixel: &pixel);
        setPixelAt(x, y: y, of:&imageRgba, withPixel: pixel)
    }
    
    private func getPixelAt(x:Int, y:Int, of imageRgba: RGBAImage) -> Pixel {
        let index = y * imageRgba.width + x
        return imageRgba.pixels[index]
    }
    
    private func setPixelAt(x:Int, y:Int, inout of imageRgba: RGBAImage, withPixel pixel: Pixel) {
        let index = y * imageRgba.width + x
        imageRgba.pixels[index] = pixel
    }
    
}