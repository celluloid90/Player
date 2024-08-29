//
//  TemplateUtils.swift
//  SlideShowMaker
//
//  Created by BCL Device7 on 7/12/22.
//

import UIKit

func randomFloat() -> Float{
    return Float.random(in: 0...1)
}

func getSine(_ theta: Float,_ piMul: Float = 0.5)-> Float {
    return sin(piMul * Float.pi * theta)
}

func smoothStep(_ low: Float,_ high: Float,_ progress: Float) -> Float {
    if(progress < low) {return 0}
    if(progress > high) {return 1}
    return (progress-low) / (high == low ? 0.0001 : (high-low))
}

func smoothStep(_ low: Float,_ high: Float,toLow:Float, toHigh:Float, _ progress: Float) -> Float {
    return toLow + smoothStep(low, high, progress) * toLow + (toHigh - toLow * 2)
}

func fract(_ value: Float) -> Float {
    return value - Float(Int(value))
}

func msToUs(ms: Int64) -> Int64{
    return ms * 1000
}

func currentTimeInMillisecond() -> Int64 {
    return Int64(Date().timeIntervalSince1970 * 1000)
}

func getRadian(_ angle: Float) -> Float {
    return Float.pi / 180 * angle
}
