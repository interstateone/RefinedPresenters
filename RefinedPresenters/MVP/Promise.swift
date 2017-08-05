import PromiseKit

public class CancellablePromise<Value>: Promise<Value> {
    private var reject: ((Error) -> Void)?

    public func cancel() {
        // Not shown: Cancel the underlying task
        reject?(NSError.cancelledError())
    }

    public init(taskArg: Any?) {
        var reject: ((Error) -> Void)!
        super.init { fulfill, r in
            // Pull out the reject function in order to use later during cancellation
            reject = r
        }
        self.reject = reject

        // Not shown: Start the underlying task and retain it
        // When it completes, fulfill this promise
    }
    
    public required init(error: Error) {
        super.init(error: error)
    }
    
    public required init(value: Value) {
        super.init(value: value)
    }
    
    public required init(resolvers: (@escaping (Value) -> Void, @escaping (Error) -> Void) throws -> Void) {
        super.init(resolvers: resolvers)
    }
}

