import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()

let heap = Heap<Int>(elements: [1, 2, 3, 4, 5, 8, 12, -4, 16, 12, 11, 0], priorityFunction: >)
print(heap)
print(heap.peek()!)
