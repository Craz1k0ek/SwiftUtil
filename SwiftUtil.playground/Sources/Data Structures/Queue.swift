import Foundation

/// The queue allows you to add items to the back and take items from the front.
public struct Queue<T> {
    public init() {}
    
    // MARK: - Properties
    
    /// The internal array that holds the data.
    fileprivate var array = [T?]()
    /// The index of the current head.
    fileprivate var head = 0
    
    // MARK: - Computed properties
    
    /// Boolean value indicating whether or not the queue is empty.
    public var isEmpty: Bool {
        array.count == 0
    }
    
    /// The number of items in the queue.
    public var count: Int {
        array.count - head
    }
    
    /// The current front of the queue.
    /// - Note: This is just a peek to see what's at the front of the queue. This will not remove the item from the queue.
    public var front: T? {
        isEmpty ? nil : array[head]
    }
    
    // MARK: - Functions
    
    /// Add an element to the queue.
    public mutating func enqueue(_ element: T) {
        array.append(element)
    }
    
    /// Take the first element from the queue (when able).
    /// - Note: The dequeuing is made more efficient by soft deleting elements from the internal data.
    ///         Meaning the queue now has an efficiency of `O(1)` instead of `O(n)`.
    public mutating func dequeue() -> T? {
        guard let element = array[guarded: head] else { return nil }
        
        array[head] = nil
        head += 1
        
        // If we do not periodically remove the empty spots, the queue will keep growing in size.
        // Instead, if more than 25% of the array is inused, we remove the wasted space.
        let percentage = Double(head) / Double(array.count)
        if array.count > 50 && percentage > 0.25 {
            array.removeFirst(head)
            head = 0
        }
        return element
    }
    
}

extension Array {
    
    subscript(guarded idx: Int) -> Element? {
        guard (startIndex ..< endIndex).contains(idx) else { return nil }
        return self[idx]
    }
    
}
