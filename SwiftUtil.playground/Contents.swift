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

var stack = Stack<Int>()
for _ in 0 ..< 25 {
    stack.push(Int.random(in: -25 ... 25))
}

while let next = stack.next() {
    print(next)
}
print("Stack has \(stack.count) items left: \(stack).")

var queue = Queue<Int>()
for _ in 0 ..< 25 {
    queue.enqueue(Int.random(in: -25 ... 25))
}

while let next = queue.next() {
    print(next)
}
print("Queue has \(queue.count) items left: \(queue).")

var numbers = [Int](repeating: 0, count: 25)
for i in 0 ..< numbers.count {
    numbers[i] = Int.random(in: -25 ... 25)
}
var heap = Heap<Int>(array: numbers, sort: >)

while let next = heap.next() {
    print(next)
}
print("Heap as \(heap.count) items left: \(heap).")
