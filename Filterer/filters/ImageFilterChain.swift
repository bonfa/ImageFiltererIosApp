import UIKit

public class ImageFilterChain {
    
    let filters: [ImageFilter]!
    
    public init(filter:ImageFilter!) {
        self.filters = [filter]
    }
    
    public init(filters:[ImageFilter]!) {
        self.filters = filters
    }
    
    public func apply(on originalImage:UIImage!) -> UIImage {
        var image = originalImage
        for filter in filters {
            image = filter.filter(image)
        }
        return image
    }
    
}