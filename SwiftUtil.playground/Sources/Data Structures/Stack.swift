import Foundation

/// The stack is an array with limited functionality. You can only append items to the `top` of the stack and remove elements from the `top`.
public struct Stack<T> {
    public init() {}
    
    // MARK: - Properties
    
    /// The internal array that holds the data.
    fileprivate var array = [T]()
    
    /// Boolean value indicating whether or not the stack is empty.
    public var isEmpty: Bool {
        array.isEmpty
    }
    
    /// The number of items in the stack.
    public var count: Int {
        array.count
    }
    
    /// The current element at the top of the stack.
    /// - Note: This is just a peek to see what's at the top, this will not pop the top of the stack.
    public var top: T? {
        array.last
    }
    
    // MARK: - Functions
    
    /// Push a new element onto the stack.
    /// - Parameter element: The element to push to the stack.
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    /// Pop the last item from the stack (when able).
    public mutating func pop() -> T? {
        array.popLast()
    }
    
}
