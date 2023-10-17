//
//  ColourChange.swift
//  WidgetPractice01
//
//  Created by Harsha R Mundaragi  on 16/10/23.
//

import Foundation

import WidgetKit
import SwiftUI

struct SimpleEntryColour: TimelineEntry {
    let date: Date
    let colour: UIColor?
}

struct PracticeWidgetEntryViewColour : View {
    var entry: ProviderColour.Entry

    var body: some View {
        VStack{
            Circle()
                .frame(width: 90, height: 90, alignment: .center)
                .foregroundColor(Color(entry.colour ?? .cyan))
                
        }
    }
}

struct PracticeWidgetColour: Widget {
    let kind: String = "Practice Colour Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: ProviderColour()) { entry in
            PracticeWidgetEntryViewColour(entry: entry)
        }
        .configurationDisplayName("Colour")
        .description("Colour widget.")
        .supportedFamilies([.systemSmall])
    }
}

struct PracticeWidget_PreviewsColour: PreviewProvider {
    static var previews: some View {
        PracticeWidgetEntryViewColour(entry: SimpleEntryColour(date: Date(), colour: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}


struct ProviderColour: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntryColour {
        SimpleEntryColour(date: Date(), colour: .red)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntryColour) -> ()) {
        completion(SimpleEntryColour(date: Date(), colour: .red))
    }
    
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntryColour>) -> ()) {
        
        let totalCountdown = 5
        let colourArray: [UIColor] = [.green, .black, .yellow, .purple, .gray]
        var colorIndex = 0
        var entries = [SimpleEntryColour]()
        
        for i in 0...totalCountdown {
            let j = i + 1
            let components = DateComponents(second: j * 5)
            let refreshDate = Calendar.current.date(byAdding: components, to: Date())!
            let currentColor = colourArray[colorIndex]
            let entry = SimpleEntryColour(
                date: refreshDate,
                colour: currentColor
            )
            entries.append(entry)
            colorIndex = (colorIndex + 1) % colourArray.count
        }
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}


/*
 
 for i in 0...7 {
     let j = i + 1
     let components = DateComponents(hour: j * 24)
     let refreshDate = Calendar.current.date(byAdding: components, to: Date())!
     let entry = SimpleEntryColour(
         date: refreshDate,
         colour: currentColor
     )
     entries.append(entry)
 }
 
 */

