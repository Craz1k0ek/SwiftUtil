import Foundation

public struct PriorityQueue<T> {
    
    // MARK: - Properties
    
    /// The internal heap that stores the items.
    private var heap: Heap<T>
    
    // MARK: - Initializers
    
    /// Creates an empty priority queue.
    /// - Parameter sort: The sorting function to use.
    public init(sort: @escaping (T, T) -> Bool) {
        self.heap = Heap(sort: sort)
    }
    
    // MARK: - Computed properties
    
    /// Boolean value indicating whether or not the queue is empty.
    public var isEmpty: Bool {
        heap.isEmpty
    }
    
    /// The total number of items in the queue.
    public var count: Int {
        heap.count
    }
    
    // MARK: - Peeking
    
    /// Returns the maximum value in the queue for a max queue or the minumum value in the queue for a min queue.
    public func peek() -> T? {
        heap.peek()
    }
    
    // MARK: - Editing queue
    
    /// Add an element to the queue.
    /// - Parameter element: The element to add.
    public mutating func enqueue(_ element: T) {
        heap.insert(element)
    }
    
    /// Take the first element from the queue (when able).
    @discardableResult
    public mutating func dequeue() -> T? {
        heap.remove()
    }
    
    /// Change the priority of an element. In a max priority queue, the new priority should be larger than the old one; in a min priority queue the priority should be smaller.
    /// - Parameters:
    ///   - i: The index of the item to replace.
    ///   - value: The value to replace the old one with.
    @discardableResult
    public mutating func changePriority(index i: Int, value: T) -> T? {
        heap.replace(index: i, value: value)
    }
    
}

extension PriorityQueue: Sequence, IteratorProtocol {
    
    public mutating func next() -> T? {
        if count == 0 {
            return nil
        } else {
            return self.dequeue()
        }
    }
    
}

extension PriorityQueue where T: Equatable {
    
    /// Get the index of an element.
    /// - Parameter element: The element to get the index for.
    public func index(of element: T) -> Int? {
        heap.index(of: element)
    }
    
}
