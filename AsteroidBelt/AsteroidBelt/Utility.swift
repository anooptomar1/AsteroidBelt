//
//  Utility.swift
//  Interaction
//
//  Created by Nadia Yudina on 3/13/16.
//  Copyright © 2016 Nadia. All rights reserved.
//

import UIKit
import GameplayKit

func randomInt(_ lowest: Int, highest: Int) -> Int {
    let die = GKRandomDistribution(lowestValue: lowest, highestValue: highest)
    return die.nextInt()
}

func randomFloat(_ firstNum: CGFloat, secondNum: CGFloat) -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
}


extension UIColor {
    
    class func starRedColor() -> UIColor {
        return UIColor(red: 236/255, green: 48/255.0, blue: 36/255.0, alpha: 1)
    }
}
