//
//  Array+Extensions.swift
//  Dexcom Monitor
//
//  Created by James on 30/12/2022.
//

import Foundation
import Combine

extension Array {
    var isNotEmpty: Bool { return !isEmpty }
    
    func asFuture() -> Future<[Element], Error> {
        Future { promise in promise(.success(self)) }
    }

    func extendingIfNeeded(to minLength: Int, with valueGenerator: (Element?) -> Element) -> [Element] {
        guard count < minLength else { return self }

        var updatedArray: [Element] = self

        while updatedArray.count < minLength {
            let nextValue: Element = valueGenerator(self.last)
            updatedArray.append(nextValue)
        }

        return updatedArray
    }

    func appending(_ element: Element) -> [Element] {
        var updatedArray: [Element] = self
        updatedArray.append(element)

        return updatedArray
    }
    
    func appending(_ element: Element, if condition: Bool) -> [Element] {
        var updatedArray: [Element] = self
        
        if condition {
            updatedArray.append(element)
        }

        return updatedArray
    }

    func appending(_ itemGenerator: () -> Element?) -> [Element] {
        guard let item: Element = itemGenerator() else { return self }

        return appending(item)
    }

    func appending(contentsOf other: [Element]) -> [Element] {
        var updatedArray: [Element] = self
        updatedArray.append(contentsOf: other)

        return updatedArray
    }

    func appendingContentsOf(_ itemGenerator: () -> [Element]?) -> [Element] {
        guard let items: [Element] = itemGenerator() else { return self }

        return appending(contentsOf: items)
    }

    func removing(at index: Int) -> [Element] {
        guard index >= 0 && index < count else { return self }

        var updatedArray: [Element] = self
        updatedArray.remove(at: index)

        return updatedArray
    }

    func inserting(_ element: Element, at index: Int) -> [Element] {
        var updatedArray: [Element] = self
        updatedArray.insert(element, at: index)

        return updatedArray
    }

    func inserting(contentsOf array: [Element], at index: Int) -> [Element] {
        var updatedArray: [Element] = self
        updatedArray.insert(contentsOf: array, at: index)

        return updatedArray
    }

    func replacingElement(at index: Int, with element: Element) -> [Element] {
        var updatedArray: [Element] = self
        updatedArray.remove(at: index)
        updatedArray.insert(element, at: index)

        return updatedArray
    }

    func replacingElement(at index: Int, with itemGenerator: (Element) -> Element) -> [Element] {
        let updatedItem: Element = itemGenerator(self[index])
        var updatedArray: [Element] = self
        updatedArray.remove(at: index)
        updatedArray.insert(updatedItem, at: index)

        return updatedArray
    }
    
    func replacingElementIfGenerated(where checker: ((Int, Element) -> Bool), with itemGenerator: (Element) -> Element?) -> [Element] {
        var updatedArray: [Element] = self
        
        for (index, element) in updatedArray.enumerated() {
            if checker(index, element) {
                if let updatedItem: Element = itemGenerator(element) {
                    updatedArray.remove(at: index)
                    updatedArray.insert(updatedItem, at: index)
                }
            }
        }
        
        return updatedArray
    }

    func replacingLastElement(with itemGenerator: (Element) -> Element) -> [Element] {
        guard let lastItem: Element = self.last else { return self }
        
        let updatedItem: Element = itemGenerator(lastItem)

        return self
            .removing(at: self.count - 1)
            .appending(updatedItem)
    }

    mutating func removeWhile(condition: ([Element]) -> Bool, where evaluator: (Element) -> Bool) {
        while condition(self) {
            guard let index: Int = self.firstIndex(where: evaluator) else {
                break
            }

            remove(at: index)
        }
    }
}

extension Array where Element == String {
    public func joined(separator: String, lastSeparator: String) -> String {
        guard let lastItem: String = self.last else { return "" }
        guard count > 2 else { return self.joined(separator: lastSeparator) }

        return [
            self[0..<(count - 1)].joined(separator: separator),
            lastItem
        ].joined(separator: lastSeparator)
    }
}

extension Array where Element == String.Element {
    func asString() -> String {
        return String(self)
    }
}

extension Array where Element: Hashable {
    func asSet() -> Set<Element> {
        return Set(self)
    }
    
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
