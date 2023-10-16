//
//  PracticeWidget.swift
//  PracticeWidget
//
//  Created by Harsha R Mundaragi  on 13/10/23.
//

import WidgetKit
import SwiftUI

struct SimpleEntry: TimelineEntry {
    let date: Date
    let resultData: [AllDetails]?
}

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
                ForEach(0..<3, id: \.self) { i in
                    if let posterPath = entry.resultData?[i].poster_path {
                            Image(uiImage: getImage(urlString: "https://image.tmdb.org/t/p/w500\(posterPath)"))
                                .resizable()
                                .scaledToFill()
                                .cornerRadius(8)
                                .shadow(color: .black.opacity(0.5), radius: 5, x: 5, y: 8)
                                .frame(width: 80, height:  90)
                                .padding(.horizontal, 5)
                                .padding(.top, 7)

                    }
                }
            }
            Spacer()
                
        }
    }
    
    func getImage(urlString: String) -> UIImage {
        guard let imageUrl = URL(string: urlString) else { return #imageLiteral(resourceName: "3389edd6054cba3517b0c54a13d6b791") }
        let imageData = try?
            Data(contentsOf: imageUrl)
        if let imageData = imageData{
            guard let image = UIImage(data: imageData) else { return #imageLiteral(resourceName: "3389edd6054cba3517b0c54a13d6b791") }
            return image
        }
        return #imageLiteral(resourceName: "3389edd6054cba3517b0c54a13d6b791")
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
        PracticeWidgetEntryView(entry: SimpleEntry(date: Date(), resultData: nil))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}



struct ResultData: Decodable {
    let results: [AllDetails]
}

struct AllDetails: Decodable {
    let backdrop_path: String
    let id: Int
    let title: String?
    let original_title: String?
    let name: String?
    let poster_path: String
    let media_type: String
    
    
    var imageUrl: URL? {
        return URL(string: "https://image.tmdb.org/t/p/w500\(poster_path)")
    }
}
