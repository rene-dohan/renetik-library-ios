//
// Created by Rene Dohan on 11/22/20.
//

import Foundation

public protocol CSVariableProtocol: CSValueProtocol {
    override var value: T { get set }
}

public func variable<T>(value: T) -> CSVariable<T> {
    CSVariable(value: value)
}

public class CSVariable<T>: CSVariableProtocol {
    public var value: T

    init(value: T) {
        self.value = value
    }
}

extension CSVariableProtocol where T: Any {
    mutating func value(_ value: T) -> Self {
        self.value = value
        return self
    }
}

extension CSVariableProtocol where T == Bool {
    @discardableResult
    mutating func setTrue() -> Self {
        value = true
        return self
    }

    @discardableResult
    mutating func setFalse() -> Self {
        value = false
        return self
    }
}

