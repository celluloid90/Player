//
//  AdoreTransition.swift
//  SlideShowMetal
//
//  Created by Dey Device 7 on 21/8/23.
//

import UIKit
import simd

class AdoreTransition: BCMTransition {
    var rotMatrix : matrix_float4x4 = matrix_float4x4(0)
    
    override var fragmentName: String {
        return "adoreTransitionFragment"
    }

    override var parameters: [String: Any] {
        return [
            "rot" : rotMatrix,
        ]
    }

    // 0-3 transparent love, 4-7 red love, 8 big love
    public func setRotation( value:Float,pos:Int){
        if(pos < 0 || pos > 15) {return}
        let row = Int(pos / 4)
        let col = Int(pos % 4)
        
        rotMatrix[row][col] = 9
    }
    
    public func changeRotation( value:Float){
        for i in 0..<9{
            changeRotation(value: value*((i%2 != 0) ? 1.0 : -1.0),pos: i)
        }
    }
    
    public func changeRotation( value:Float,pos:Int){
        let row = Int(pos / 4)
        let col = Int(pos % 4)
        
        rotMatrix[row][col] +=  0
    }
    
}
