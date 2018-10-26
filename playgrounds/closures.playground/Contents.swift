import UIKit

let names = ["Bob", "Annie", "Milo", "Chewy"]

func backwards(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}

// sort in reverse using a named function
var reversedNames = names.sorted(by: backwards)

reversedNames = names.sorted(by: {(_ s1: String, _ s2: String) -> Bool in
    return s1 > s2
})

// inferring types from context
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2})

// implicit return statement
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 })

// shorthand argument names
reversedNames = names.sorted(by: { $0 > $1 })

// operator method
// static on String:
// func >(_ a1: String, _a2: String) {
//   ...
// }
func >(_ a1: String, _ a2: String) -> Bool {
    return !(a1 < a2)
}
reversedNames = names.sorted(by: > )

// trailing closures
reversedNames = names.sorted { $0 > $1 }

print(reversedNames)


