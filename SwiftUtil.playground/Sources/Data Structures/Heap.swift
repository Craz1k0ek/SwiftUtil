import Foundation

public struct Heap<Element> {
    
    // MARK: - Initialization
    public init(elements: [Element], priorityFunction: @escaping (Element, Element) -> Bool) {
        self.elements = elements
        self.priorityFunction = priorityFunction
        buildHeap()
    }
    
    private mutating func buildHeap() {
        for index in (0 ..< count / 2).reversed() {
            siftDown(at: index)
        }
    }
    
    // MARK: - Properties
    
    /// The internal array that holds the data.
    fileprivate var elements: [Element]
    /// The method used to decide the priority.
    fileprivate var priorityFunction: (Element, Element) -> Bool
    
    /// Boolean value indicating whether or not the heap is empty.
    public var isEmpty: Bool {
        elements.isEmpty
    }
    
    /// The number of items in the heap.
    public var count: Int {
        elements.count
    }
    
    // MARK: - Functions
    
    /// The first element in the heap`.
    public func peek() -> Element? {
        elements.first
    }
    
    // TODO: Documentation
    private func isRoot(_ index: Int) -> Bool {
        index == 0
    }
    
    private func leftChildIndex(of index: Int) -> Int {
        (2 * index) + 1
    }
    
    private func rightChildIndex(of index: Int) -> Int {
        (2 * index) + 2
    }
    
    private func parentIndex(of index: Int) -> Int {
        (index - 1) / 2
    }
    
    // MARK: - Priority (wrappers)
    
    /// Wrapper for the `priorityFunction`. It takes two indices and determines whether or not the first index has a higher priority.
    /// - Parameters:
    ///   - firstIndex: The first index.
    ///   - secondIndex: The second index.
    private func isHigherPriority(at firstIndex: Int, than secondIndex: Int) -> Bool {
        priorityFunction(elements[firstIndex], elements[secondIndex])
    }
    
    /// Check if both the parent and the child have valid indices and return the index with the highest priority.
    /// - Parameters:
    ///   - parentIndex: The parent index.
    ///   - childIndex: The child index.
    private func highestPriorityIndex(of parentIndex: Int, and childIndex: Int) -> Int {
        guard childIndex < count && isHigherPriority(at: childIndex, than: parentIndex) else { return parentIndex }
        return childIndex
    }
    
    /// Assumes the parent index is valid and returns the highest priority for the parent, left child and right child.
    /// - Parameter parent: The parent index.
    private func highestPriorityIndex(for parent: Int) -> Int {
        highestPriorityIndex(of: highestPriorityIndex(of: parent, and: leftChildIndex(of: parent)), and: rightChildIndex(of: parent))
    }
    
    // MARK: - Mutating functions
    
    /// Swap the elements at given indices.
    /// - Parameters:
    ///   - firstIndex: The index of the first value to swap.
    ///   - secondIndex: The index of the second value to swap.
    private mutating func swapElements(at firstIndex: Int, with secondIndex: Int) {
        guard firstIndex != secondIndex else { return }
        elements.swapAt(firstIndex, secondIndex)
    }
    
    private mutating func siftUp(at index: Int) {
        let parent = parentIndex(of: index)
        guard !isRoot(index), isHigherPriority(at: index, than: parent) else { return }
        swapElements(at: index, with: parent)
        siftUp(at: parent)
    }
    
    private mutating func siftDown(at index: Int) {
        let childIndex = highestPriorityIndex(for: index)
        if index == childIndex { return }
        swapElements(at: index, with: childIndex)
        siftDown(at: childIndex)
    }
    
    mutating func enqueue(_ element: Element) {
        elements.append(element)
        siftUp(at: count - 1)
    }
    
    mutating func dequeue() -> Element? {
        guard !isEmpty else { return nil }
        swapElements(at: 0, with: count - 1)
        let element = elements.removeLast()
        if !isEmpty { siftDown(at: 0) }
        return element
    }
    
}
