

import Combine


extension Publisher {
    func dump() -> AnyPublisher<Self.Output, Self.Failure> {
        handleEvents(receiveSubscription: {value in
            Swift.dump(value)
        })
        .eraseToAnyPublisher()
    }
}
