//
//  MTFadegrayscaleTransition.swift
//  MTTransitions
//
//  Created by alexiscn on 2019/1/28.
//

public class MTFadegrayscaleTransition: BCMTransition {
    
    public var intensity: Float = 0.3 

    override var fragmentName: String {
        return "FadegrayscaleFragment"
    }

    override var parameters: [String: Any] {
        return [
            "intensity": intensity
        ]
    }
}
