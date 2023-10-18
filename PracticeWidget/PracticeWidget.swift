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
        ZStack{
            ContainerRelativeShape()
                .fill(.brown.gradient.opacity(0.6))
            VStack{
                Text("Trending Contents")
                    .font(.body)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundColor(.brown)
                    .padding(.top, 5)
                HStack{
                    ForEach(entry.images!, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.5), radius: 8, x: 5, y: 5)
                            .frame(width: 80, height:  90)
                            .padding(5)
                    }
                }
                Spacer()
            }
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
        PracticeWidgetEntryView(entry: SimpleEntry(date: Date(), images: [UIImage(imageLiteralResourceName: "testImage01"),UIImage(imageLiteralResourceName: "testImage02"),UIImage(imageLiteralResourceName: "testImage03")]))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}

