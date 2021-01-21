# Sticker
A sticker can be scaled, moved and rotated, also deleted!!
## Installation
```
pod 'Sticker'
```

## Demo

## Usage
```swift
 class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    //add Sticker
    @IBAction func addSticker(_ sender: Any) {
        let width = imageView.frame.width * 0.3
        //create Sticker
        let sticker = Sticker(frame: CGRect(x: 0, y: 0, width: width, height: width))
        sticker.setImage(UIImage(named: "YOUR_IMAGE"))
        
        //enable userInteraction
        self.imageView.isUserInteractionEnabled = true
        //add to superview
        self.imageView.addSubview(sticker)
    }
    
}

```