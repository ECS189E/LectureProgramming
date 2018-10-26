import UIKit

func makeIncrementor(amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementor() -> Int {
        runningTotal += amount
        return runningTotal
    }
    
    return incrementor
}
// running total == 0

// first create an incrmentBy10 incrementor
let incrementBy10 = makeIncrementor(amount: 10)

// it updates it's own internal runningTotal variable
// and returns the updated value on each invocation
incrementBy10()
incrementBy10()
incrementBy10()

// create a separate incrementBy7 incrementor
// and it gets its own runningTotal and amount
// variables to operate on
let incrementBy7 = makeIncrementor(amount: 7)

// runningTotal starts a 0 and increments by 7
// after each invocation
incrementBy7()
incrementBy7()

// incrementBy10 still updates its separate
// running total, independent of the value
// used by incrementBy7
incrementBy10()

// we can create yet another incrementor and it
// will also have its own runningTotal, even
// though the amount is the same as the other
// increment by 10
let yaIncrementBy10 = makeIncrementor(amount: 10)
yaIncrementBy10()

// references to closures operate on the same
// runningTotal as the closure that it
// references.
let referenceToIncrementBy10 = incrementBy10
referenceToIncrementBy10()

