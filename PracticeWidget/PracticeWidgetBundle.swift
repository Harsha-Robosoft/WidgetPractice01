//
//  PracticeWidgetBundle.swift
//  PracticeWidget
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import WidgetKit
import SwiftUI

@main
struct PracticeWidgetBundle: WidgetBundle {
    var body: some Widget {
        DoggyWidget()
        PracticeWidget()
        PracticeWidgetColour()
//        PracticeWidgetLiveActivity()
//        CountdownWidget()
    }
}
