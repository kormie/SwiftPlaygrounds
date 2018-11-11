import UIKit
import PlaygroundSupport

//let viewFrame = CGRect(x: 0, y: 0, width: 500, height: 500)
//let view = UIView(frame: viewFrame)
//view.backgroundColor = .white
//PlaygroundPage.current.liveView = view

enum Result<Data> {
    case success(Data)
    case failure(Error)
}

struct PersonError : Error {

}

protocol Resource {
    func load(_ callback: @escaping (Result<Self>) -> ()) -> ()
}


struct Person : Resource, CustomStringConvertible {
    var description: String {
        return "Hello, my name is \(name)"
    }

    var name: String
    func load(_ callback: @escaping (Result<Person>) -> ()) -> () {
        let dispatchQueue = DispatchQueue(label: "remoteDataTaskQueue", qos: .userInitiated, target: nil)

        dispatchQueue.asyncAfter(deadline: .now() + 2.0) {
            let person = Person(name: ["David", "Maggie", "Kate"].randomElement()!)
            callback(.success(person))
        }

    }

}

enum RemoteData<R : Resource> {
    case notAsked
    case loading
    case loaded(Result<R>)
}

struct RemoteDataTask<R:Resource> {
    var state: RemoteData<R>
    let resource: R
    init(_ resource: R) {
        state = .notAsked
        self.resource = resource
    }
}

extension RemoteDataTask {

    init(loading: RemoteDataTask) {
        state = .loading
        resource = loading.resource
    }

    mutating func fetch(cb: @escaping (Result<R>) -> ()) -> RemoteDataTask {
        resource.load(cb)
        return RemoteDataTask(loading: self)
    }
}

var t = RemoteDataTask(Person(name: "Test"))
print(t.state)
var newT = t.fetch { result in
    switch result {
    case .success(let data):
        print("Loaded: \(data)")
    case .failure(let error):
        print("Failed to load person: \(error)")
    }
}
print(newT.state)
