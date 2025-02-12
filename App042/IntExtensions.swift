import Foundation

extension Int {
    
    var makeShortInt: String {
        if self == 0 {
            return "0"
        } else
        if self / 1000000000 > 0 {
            return "\(self / 1000000000)B"
        } else
        if self / 1000000 > 0 {
            return "\(self / 1000000)M"
        } else
        if self / 1000 > 0 {
            return "\(self / 1000)K"
        } else {
            return "\(self)"
        }
    }
    
    var roundToGreatest: Self {
        var i = self
        var signCounter = 0
        var mostSign = 0
        while i > 0 {
            mostSign = i % 10
            i = i / 10
            signCounter += 1
        }
        signCounter -= 1
        mostSign += 1
        for _ in 0..<signCounter {
            mostSign *= 10
        }
        return mostSign
    }
    
    var roundToLowest: Self {
        var i = self
        var signCounter = 0
        var mostSign = 0

        while i > 0 {
            mostSign = i % 10
            i = i / 10
            signCounter += 1
        }
        signCounter -= 1
        
        mostSign -= 1
        
        for _ in 0..<signCounter {
            mostSign *= 10
        }
        
        if mostSign <= 10 {
            return 0
        } else {
            return mostSign
        }
    }
}
