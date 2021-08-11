import UIKit

//to create data O(N)
func numberArray(_ upto: Int) -> [String] {
    var array: [Int] = []
    for i in 1...upto {
        array.append(i)
    }
    return array.compactMap { num in
        "\(num)"
    }
}

// O(m) where m is the digit count, for example m of 100 is 3
// So. the complexity of a number should be O(logN) where N == 100
extension String {
    func numberOf(_ element: Character) -> Int {
        var count = 0
        for c in self {
            if c == element {
                count += 1
            }
        }
        return count
    }
}

// O(NlogN)
func sumOf7(_ array:[String]) -> Int {
    var sum = 0
    array.forEach { str in
        sum += str.numberOf("7")
    }
    return sum
}

func g_v1(_ num: Int) -> Int {
    guard num > 0 else {
        return 0
    }
    let numbers = numberArray(num)
    return sumOf7(numbers)
}


// The first version fo g(n), it's complexity should be O(NlogN)
// Also, it spend too much time on create input data

extension Int {
    func digit10(at position: Int) -> Int {
        return Int(Double(self)/pow(10.0, Double(position - 1)))%10
    }
    func numOfDigits() -> Int {
        guard self != 0 else {
            return 1
        }
        return Int(log10(Double(self))) + 1
    }
    
    //O(logN), where N < 10
    func occurance(of x: Int) -> Int {
        guard x < 10 && x >= 0 else {
            return 0
        }
        
        let num = numOfDigits()
        var result = 0
        for i in 1...num {
            if digit10(at: i) == x { result += 1 }
        }
        return result
    }
}

func g_v2(upto: Int) -> Int {
    guard upto > 0 else {
        return 0
    }
    var result = 0
    for i in 0...upto {
        result += i.occurance(of: 7)
    }
    return result
}



// An better approch to process this issue should be caculate it by mathematics equation
// g(n) has a regular pattern
// for num with digit format "abc"
// for example num 123, a == 1, b == 2, c == 3
// gN(num) = gN(a00) + gN(bc)

extension Int {
    func digits() -> [Int] {
        let num = numOfDigits()
        var array: [Int] = []
        for i in 1...num {
            array.append(digit10(at: i))
        }
        return array
    }
    // There is a rule of g(10^n)
    // g(1) = 0, g(10) = 1, g(100) = 20, g(1000) = 300
    // where g(10) = g(1) + 1, g(100) = g(10)*10 + 10, g(1000) = g(100)*10 +100...
    // so it can be summarized to  g(10^n) = g(10^(n-1))*10 + 10^(n-1)
    // now, define g(10^n) as base(N).
    // following is the base(N) function for all numbers, for example: 123.baseN == 100.baseN
    // The complexity is O(logN)
    func baseN() -> Int {
        let digits = digits()
        var result = 0
        for i in 1...digits.count {
            if i < 2 {
                continue
            }
            let pow = pow(10, Double(i-2))
            result *= 10
            result += Int(pow)
        }
        return result
    }
}

// with baseN and the pattern gN(num) = gN(a00) + gN(bc), it can find number of occurances by gN(_:n:)
// and the complexity of gN() should be O(logN^2) : recursive call * baseN
func gN(_ num: Int, n: Int) -> Int {
    if num == 0 { return 0 }
    let digits = num.digits()
    if digits.count == 1 {
        return num < n ? 0 : 1
    }
    
    let unit = Int(pow(10.0, Double(digits.count - 1)))
    let r = num % unit
    let highDigit = digits.last!
    var result = num.baseN()*highDigit
    result += gN(r, n:n)
    if highDigit == 7 {
        result += r + 1
    }
    if highDigit > 7 {
        result += unit
    }
    return result
}

// Demo and Test
// time should be vFinal < v2 < v1 in large numbers

func interval<T>(_ ofBlock: ()->T ) -> (result: T, time:TimeInterval) {
    let start = Date()
    let result = ofBlock()
    return (result, -start.timeIntervalSinceNow)
}

var foundDifferent = false

let  i = 1000
let v1 = interval {
    g_v1(i)
}
print("v1: \(v1)")

let v2 = interval {
    g_v2(upto: i)
}
print("v2: \(v2)")

let vFinal = interval {
    gN(i, n: 7)
}
print("vFinal: \(vFinal)")

if !foundDifferent {
    print("ok")
}

