import Foundation

public struct Heap<T> {
    
    // MARK: - Properties
    
    /// The array that stores the heap's nodes.
    private var nodes = [T]()
    
    /// Determines how to compare two nodes in the heap.
    /// Use `>` for a max heap, or `<` for a min heap or provide
    /// a comparing method if the heap is made of custom elements.
    private var orderCriteria: (T, T) -> Bool
    
    // MARK: - Initializers
    
    /// Creates an empty heap.
    /// - Parameter sort: The sorting function to use.
    public init(sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
    }
    
    /// Creates a heap from an array, where the order of the elements in the array is irrelevant.
    /// The elements are inserted in the heap in the order determined by the sorting function.
    /// - Parameters:
    ///   - array: The array to create the heap from.
    ///   - sort: The sorting function to use.
    public init(array: [T], sort: @escaping (T, T) -> Bool) {
        self.orderCriteria = sort
        configureHeap(from: array)
    }
    
    /// Configures the heap from an array, in a bottom-up manner.
    /// Runs at about `O(n)`.
    /// - Parameter array: The array to create the heap from.
    private mutating func configureHeap(from array: [T]) {
        nodes = array
        for i in stride(from: (nodes.count / 2 - 1), through: 0, by: -1) {
            shiftDown(i)
        }
    }
    
    // MARK: - Computed properties
    
    /// Boolean value indicating whether or not the heap is empty.
    var isEmpty: Bool {
        nodes.isEmpty
    }
    
    /// The total number of nodes in the heap.
    var count: Int {
        nodes.count
    }
    
    // MARK: - Indexing & peeking
    
    /// Returns the index of the parent of the element at index `i`.
    /// The element at index `0` is the root of the tree and has no parent.
    /// - Parameter i: The index of the element to find the parent index for.
    internal func parentIndex(ofIndex i: Int) -> Int {
        (i - 1) / 2
    }
    
    /// Returns the index of the left child of the element at index `i`.
    /// Note that this index can be greater than the heap size, in which case there is no left child.
    /// - Parameter i: The index of the element to find the left child index for.
    internal func leftChildIndex(ofIndex i: Int) -> Int {
        return 2 * i + 1
    }
    
    /// Returns the index of the right child of the elemet at index `i`.
    /// Note that this index can be greater than the heap size, in which case there is no right child.
    /// - Parameter i: The index of the element to find the right child index for.
    internal func rightChildIndex(ofIndex i: Int) -> Int {
        return 2 * i + 2
    }
    
    /// Returns the maximum value in the heap for a max heap or the minumum value in the heap for a min heap.
    public func peek() -> T? {
        nodes.first
    }
    
    // MARK: - Editing heap
    
    /// Adds an ew value to the heap. This reorders the heap so that the max heap or min heap property still holds.
    /// Runs at `O(log n)`.
    /// - Parameter value: The value to add to the heap.
    public mutating func insert(_ value: T) {
        nodes.append(value)
        shiftUp(nodes.count - 1)
    }
    
    /// Adds a sequence of values to the heap. This reorders the heap so that the max heap or min heap property still holds.
    /// - Parameter sequence: The sequence to add to the heap.
    public mutating func insert<S: Sequence>(_ sequence: S) where S.Iterator.Element == T {
        for value in sequence {
            insert(value)
        }
    }
    
    /// Replaces an element of the heap with given value. This reorders the heap so that the max heap or min heap property still holds.
    /// - Parameters:
    ///   - i: The index of the value to replace.
    ///   - value: The value to replace the element with.
    public mutating func replace(index i: Int, value: T) {
        guard i < nodes.count else { return }
        remove(at: i)
        insert(value)
    }
    
    /// Removes the root node from the heap. This reorders the heap so that the max heap or min heap property still holds.
    /// This runs at `O(log n)`.
    @discardableResult
    public mutating func remove() -> T? {
        guard !nodes.isEmpty else { return nil }
        
        if nodes.count == 1 {
            return nodes.removeLast()
        } else {
            // Use the alst node to replace the first one, the nfix the heap
            // by shifting this new first node into its proper position.
            let value = nodes[0]
            nodes[0] = nodes.removeLast()
            shiftDown(0)
            return value
        }
    }
    
    /// Removes a node from the heap.
    /// Runs at `O(log n)`.
    /// - Parameter index: The index of the node to remove.
    @discardableResult
    public mutating func remove(at index: Int) -> T? {
        guard index < nodes.count else { return nil }
        
        let size = nodes.count - 1
        if index != size {
            nodes.swapAt(index, size)
            shiftDown(from: index, until: size)
            shiftUp(index)
        }
        return nodes.removeLast()
    }
    
    // MARK: - Shifting
    
    /// Takes a child node and looks at its parents. If a parent is not larger (max heap) or a parent is not smaller (min heap), we exchange them.
    /// - Parameter index: The index of the child to shift up.
    internal mutating func shiftUp(_ index: Int) {
        var childIndex = index
        let child = nodes[childIndex]
        var parentIndex = self.parentIndex(ofIndex: childIndex)
        
        while childIndex > 0 && orderCriteria(child, nodes[parentIndex]) {
            nodes[childIndex] = nodes[parentIndex]
            childIndex = parentIndex
            parentIndex = self.parentIndex(ofIndex: childIndex)
        }
        
        nodes[childIndex] = child
    }
    
    internal mutating func shiftDown(from index: Int, until endIndex: Int) {
        let leftChildIndex = self.leftChildIndex(ofIndex: index)
        let rightChildIndex = leftChildIndex + 1
        
        // Figure out which comes fisrt if we order them by the sort function:
        // the paretn, the left child or the right child. If the paretn comes first,
        // we're done. If not, that element is out of place and we make it 'float' down
        // the tree, until the heap property is restored.
        var first = index
        if leftChildIndex < endIndex && orderCriteria(nodes[leftChildIndex], nodes[first]) {
            first = leftChildIndex
        }
        if rightChildIndex < endIndex && orderCriteria(nodes[rightChildIndex], nodes[first]) {
            first = rightChildIndex
        }
        if first == index { return }
        
        nodes.swapAt(index, first)
        shiftDown(from: first, until: endIndex)
    }
    
    internal mutating func shiftDown(_ index: Int) {
        shiftDown(from: index, until: nodes.count)
    }
    
}

// MARK: - Searching

public extension Heap where T: Equatable {
    
    /// Get the index of a node in the heap.
    /// Runs at `O(n)`.
    /// - Parameter node: The node to find the index for.
    func index(of node: T) -> Int? {
        nodes.index(where: { $0 == node })
    }
    
    /// Removes the first occurence of a node from the heap.
    /// Runs at `O(log n)`.
    /// - Parameter node: The node to remove.
    @discardableResult
    mutating func remove(node: T) -> T? {
        if let index = index(of: node) {
            return remove(at: index)
        }
        return nil
    }
    
}
