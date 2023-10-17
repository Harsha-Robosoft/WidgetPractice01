//
//  PracticeWidget.swift
//  PracticeWidget
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import WidgetKit
import SwiftUI

struct PracticeWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack{
            Text("Trending Contents")
                .font(.body)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.top, 5)
            HStack{
                ForEach(entry.images!, id: \.self) { image in
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(8)
                        .shadow(color: .black.opacity(0.5), radius: 5, x: 5, y: 8)
                        .frame(width: 80, height:  90)
                        .padding(.horizontal, 5)
                        .padding(.top, 7)
                }
            }
            Spacer()
        }
    }
}

struct PracticeWidget: Widget {
    let kind: String = "PracticeWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PracticeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium])
    }
}

struct PracticeWidget_Previews: PreviewProvider {
    static var previews: some View {
        PracticeWidgetEntryView(entry: SimpleEntry(date: Date(), images: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
