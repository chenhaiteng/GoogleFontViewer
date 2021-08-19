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

func g_v2(num: Int, upto: Int) -> Int {
    guard upto > 0 else {
        return 0
    }
    var result = 0
    for i in 0...upto {
        result += i.occurance(of: num)
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
// g(7777) = g(7000) + g(777) counting 6's

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
    if highDigit == n {
        result += r + 1
    }
    if highDigit > n {
        result += unit
    }
    return result
}

// O(logN) version
// Refer from https://www.geeksforgeeks.org/number-of-occurrences-of-2-as-a-digit-in-numbers-from-0-to-n/
extension Int {
    // To get the occurence of number x in range 0 upto N in specified place d, where 0 <= x < 10
    // d is based on 1, and start at the right-most end of N.
    // For example, if x is 2, N is 23, and d is 1, then N[d] == 3.
    // For numbers from 0 to 23, x appears in N[1] is [2, 12, 22], and appears in N[2] would be [20, 21, 22, 23]
    // And 2.occurence(at: 1, upto: 23) would be 3 and 2.occurence(at:2, upto:23) would be 4
    func occurence(at place: Int, upto: Int) -> Int {
        // To find number 2 occurence in a number 6110 at place 3, following fact can be observed:
        // 1. the number 2 occurs at 200..< 299, 1200..<1299, until 5200..<5299. Each group has 100==10^(3-1) elements.
        // 2. the groups repeat 6 times -- which 6 is the quotient of 6110/100/10 == 6100/(10^3)
        // 3. update 6110 to 6210, than the number 2 occurence is similar with 6110, but have one more group: 6200...6210, which number of elements would be 11 == 6210%(10^2) + 1 (1 for 6200 itself)
        // 4. for 6x10 where x > 2, the number of groups increase from the group of 6110 by 1
        let numOfDigits = upto.numOfDigits()
        guard self < 10, self >= 0, numOfDigits >= place else {
            return -1
        }
        let digit = upto.digit10(at: place)
        let pow = Int(pow(10.0, Double(place)))
        let elementCount = pow/10
        let quotient = upto/pow  //group number
        let remainder = upto % elementCount
        
        var result = 0
        switch digit {
        case Int.min..<self:
            result = quotient * elementCount
        case self:
            result = quotient * elementCount + 1 + remainder
        default:
            result = (quotient + 1) * elementCount
        }
        return result
    }
}

func gNplus(_ num: Int, n: Int) -> Int {
    let numOfDigits = num.numOfDigits()
    var count = 0
    for i in 1...numOfDigits {
        let r = n.occurence(at: i, upto: num)
        count += r
    }
    return count
}

// Demo and Test
// time should be vFinal < v2 < v1 in large numbers

func interval<T>(_ ofBlock: ()->T ) -> (result: T, time:TimeInterval) {
    let start = Date()
    let result = ofBlock()
    return (result, -start.timeIntervalSinceNow)
}


func testN(n:Int,  i: Int, log: Bool) -> Bool {
//    let v2 = interval {
//        g_v2(num: n, upto: i)
//    }

    let vFinal = interval {
        gN(i, n: n)
    }
    
    let vPlus = interval {
        gNplus(i, n: n)
    }
    
    if log {
        print("==== digit: \(n), occurence at :\(i) ====")
//        print("v2: \(v2)")
        print("vFinal: \(vFinal)")
        print("vPlus: \(vPlus)")
//        if v2.result != vFinal.result {
//            print("vFinal: \(vFinal)")
//        }
//        if v2.result != vPlus.result {
//            print("vPlus: \(vPlus)")
//        }
    }
    return vPlus != vFinal
//    return vFinal.result != v2.result || vPlus.result  != v2.result
}

func testNLoop(upto i: Int) {
    
    var foundDifferent = false

    for num in 0...i {
        let diff = testN(n: 2, i: num, log: false)
        if diff {
            foundDifferent = true
            testN(n: 2, i: num, log: true)
            break
        }
    }
        
    if !foundDifferent {
        print("ok")
    }
}


func test(digit:Int, upto: Int) -> Int {
    var count = 1
    var tens = 1
    var ott = 0
    var sum = 0
    var sNum = upto
    while sNum > 0 {
        let rem = sNum%10
        if rem < digit {
            sum += rem*ott
            ott = count*tens
            tens *= 10
        }
        else if rem == digit {
            sum += upto%tens + 1
            sum += rem*ott
            ott = count*tens
            tens *= 10
        }
        else {
            sum += ott*rem
            sum += tens
            ott = count*tens
            tens = tens*10
        }
        count += 1
        sNum /= 10
    }
    return sum
}

let loop = 1000000
let result = interval {
    for _ in 0..<loop {
        test(digit: 2, upto: 65535)
    }
}

let expected = interval {
    for _ in 0..<loop {
        gNplus(65535, n: 2)
    }
}
print("\(result.time/Double(loop))")
print("\(expected.time/Double(loop))")
//let a = interval {
//    for _ in 0..<1000 {
//        gN(100000000, n: 2)
//    }
//}
//
//let b = interval {
//    for _ in 0..<1000 {
//        gNplus(100000000, n: 2)
//    }
//}
//let c = interval {
//    for _ in 0..<1000 {
//        test(digit: 2, upto: 100)
//    }
//}


//long long int numberOf2sinRange(long long int number)
//{
//    int count = 1;
//    long long int tens = 1;
//    long long int ott = 0;
//    long long int sum = 0;
//    long long int sNum = number;
//
//    while(sNum)
//    {
//        int rem = sNum%10;
//
//        if(rem<2)
//        {
//            sum = sum + rem*ott ;
//            ott = (count)*tens;
//            tens = tens*10;
//
//        }
//        else if(rem==2)
//        {
//            sum = sum + number%tens +1;
//            sum = sum + rem*ott;
//            ott = (count)*tens;
//            tens = tens*10;
//        }
//        else
//        {
//            sum = sum + (ott)*rem;
//            sum = sum + tens;
//            ott = (count)*tens;
//            tens = tens*10;
//
//        }
//        count++;
//        sNum = sNum/10;
//    }
//
//    return sum;
//}
