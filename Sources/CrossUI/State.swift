import Foundation

@propertyWrapper
public struct State<Value> {
    private class Storage {
        var value: Value
        init(value: Value) {
            self.value = value
        }
    }
    
    private var storage: Storage
    
    public init(wrappedValue: Value) {
        self.storage = Storage(value: wrappedValue)
    }
    
    public var wrappedValue: Value {
        get { storage.value }
        mutating set { storage.value = newValue }
    }
    
    public var projectedValue: Binding<Value> {
        Binding(
            get: { self.storage.value },
            set: { self.storage.value = $0 }
        )
    }
}

public struct Binding<Value> {
    private let getter: () -> Value
    private let setter: (Value) -> Void
    
    public init(get: @escaping () -> Value, set: @escaping (Value) -> Void) {
        self.getter = get
        self.setter = set
    }
    
    public var wrappedValue: Value {
        get { getter() }
        nonmutating set { setter(newValue) }
    }
} 
