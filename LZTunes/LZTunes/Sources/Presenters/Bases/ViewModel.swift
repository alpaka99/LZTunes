//
//  ViewModel.swift
//  LZTunes
//
//  Created by user on 8/9/24.
//

import RxSwift

// MARK: ViewStore Implmentation

protocol Inputable { }
protocol Outputable { }

private protocol Reducable {
    associatedtype Input: Inputable
    associatedtype Output: Outputable
    
    var input: Input { get set }
    var output: Output { get set }
    
    func callAsFunction<Value>(_ keyPath: KeyPath<Input, Value>) -> Value
    func callAsFunction<Value>(_ keyPath: KeyPath<Output, Value>) -> Value
    
    // MARK: inout 키워드 써서 성능 높히기
    mutating func reduce<Value>(_ keyPath: WritableKeyPath<Input, Value>, into value: Value)
    mutating func reduce<Value>(_ keyPath: WritableKeyPath<Output, Value>, into value: Value)
    
    init(input: Input, output: Output)
}

extension Reducable {
    func callAsFunction<Value>(_ keyPath: KeyPath<Input, Value>) -> Value {
        return self.input[keyPath: keyPath]
    }
    func callAsFunction<Value>(_ keyPath: KeyPath<Output, Value>) -> Value {
        return self.output[keyPath: keyPath]
    }
    mutating func reduce<Value>(_ keyPath: WritableKeyPath<Input, Value>, into value: Value) {
        self.input[keyPath: keyPath] = value
    }
    mutating func reduce<Value>(_ keyPath: WritableKeyPath<Output, Value>, into value: Value) {
        self.output[keyPath: keyPath] = value
    }
}

class Reducer<Input: Inputable, Output: Outputable>: Reducable {
    required init(input: Input, output: Output) {
        self.input = input
        self.output = output
    }
    
    var input: Input
    var output: Output
}


@dynamicMemberLookup
class ViewStore<Input: Inputable, Output: Outputable> {
    private let input: Input
    private let output: Output
    private lazy var reducer = Reducer(input: input, output: output)
    
    init(input: Input, output: Output) {
        self.input = input
        self.output = output
    }
}

extension ViewStore {
    // for read operation
    subscript<Value>(dynamicMember keyPath: KeyPath<Input, Value>) -> Value {
        return self.reducer.callAsFunction(keyPath)
    }
    subscript<Value>(dynamicMember keyPath: KeyPath<Output, Value>) -> Value {
        return self.reducer.callAsFunction(keyPath)
    }
    
    // for keypath access
    subscript<Value>(dynamicMember keyPath: KeyPath<Input, Value>) -> KeyPath<Input, Value> {
        return keyPath
    }
    subscript<Value>(dynamicMember keyPath: KeyPath<Output, Value>) -> KeyPath<Output, Value> {
        return keyPath
    }
    
    // for reducer.reduce() operation
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Input, Value>) -> WritableKeyPath<Input, Value> {
        return keyPath
    }
    
    subscript<Value>(dynamicMember keyPath: WritableKeyPath<Output, Value>) -> WritableKeyPath<Output, Value> {
        return keyPath
    }
    
    func reduce<Value>(_ keyPath: WritableKeyPath<Input, Value>, into value: Value) {
        reducer.reduce(keyPath, into: value)
    }
    
    func reduce<Value>(_ keyPath: WritableKeyPath<Output, Value>, into value: Value) {
        reducer.reduce(keyPath, into: value)
    }
}

protocol ViewModel {
    associatedtype Input: Inputable
    associatedtype Output: Outputable
    
    var store: ViewStore<Input, Output> { get }
    var disposeBag: DisposeBag { get }
}


// MARK: BaseViewModelRequirements
protocol ViewModelRequirements {
    init()
    
    func configureBind()
}

class BaseViewModel: ViewModelRequirements {
    required init() {
        configureBind()
    }
    
    let disposeBag = DisposeBag()
    
    func configureBind() { }
}

typealias RxViewModel = BaseViewModel & ViewModel

/*
 Example Usage
*/
final class ExampleViewModel: RxViewModel {
    
    struct Input: Inputable {
        var testInput = Observable.just("input")
    }
    
    struct Output: Outputable {
        var testOutput = PublishSubject<String>()
    }
    
    var store = ViewStore(input: Input(), output: Output())
    
    override func configureBind() {
        store.testInput
            .bind(to: store.testOutput)
            .disposed(by: disposeBag)
    }
}
