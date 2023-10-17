//
//  DogWidgetTest.swift
//  PracticeWidgetExtension
//
//  Created by Harsha R Mundaragi  on 17/10/23.
//


import WidgetKit
import SwiftUI

struct DoggyEntry: TimelineEntry {
    let date: Date
    let image: UIImage
}

struct DoggyWidgetView: View {
    
    let entry: DoggyEntry
    
    var body: some View {
        Image(uiImage: entry.image)
            .resizable()
            .scaledToFill()
            .clipped()
    }
}

struct DoggyTimelineProvider: TimelineProvider {

    typealias Entry = DoggyEntry

    func placeholder(in context: Context) -> Entry {
        let sample = UIImage(named: "sample-doggy")!
        return DoggyEntry(date: Date(), image: sample)
    }

    func getSnapshot(in context: Context, completion: @escaping (Entry) -> ()) {
        
        var snapshotDoggy: UIImage
        
        if context.isPreview && !DoggyFetcher.cachedDoggyAvailable {
            // Use local sample image as snapshot if cached image not available
            snapshotDoggy = UIImage(named: "sample-doggy")!
        } else {
            // Use cached image as snapshot
            snapshotDoggy = DoggyFetcher.cachedDoggy!
        }
        
        let entry = DoggyEntry(date: Date(), image: snapshotDoggy)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        Task {

            // Fetch a random doggy image from server
            guard let image = try? await DoggyFetcher.fetchRandomDoggy() else {
                return
            }
            
            let entry = DoggyEntry(date: Date(), image: image)
            
            // Next fetch happens 15 minutes later
            let nextUpdate = Calendar.current.date(
                byAdding: DateComponents(minute: 1),
                to: Date()
            )!
            
            let timeline = Timeline(
                entries: [entry],
                policy: .after(nextUpdate)
            )
            
            completion(timeline)
        }
    }
}


struct Doggy: Decodable {
    let message: URL
    let status: String
}

struct DoggyFetcher {
    
    enum DoggyFetcherError: Error {
        case imageDataCorrupted
    }
    
    /// The path where the cached image located
    private static var cachePath: URL {
        URL.cachesDirectory.appending(path: "doggy.png")
    }

    /// The cached dog image
    static var cachedDoggy: UIImage? {
        guard let imageData = try? Data(contentsOf: cachePath) else {
            return  nil
        }
        return UIImage(data: imageData)
    }

    /// Is cached image currently available
    static var cachedDoggyAvailable: Bool {
        cachedDoggy != nil
    }
    
    /// Call the Dog API and then download and cache the dog image
    static func fetchRandomDoggy() async throws -> UIImage {

        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!

        // Fetch JSON data
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let doggy = try JSONDecoder().decode(Doggy.self, from: data)
        
        // Download image from URL
        let (imageData, _) = try await URLSession.shared.data(from: doggy.message)
        
        guard let image = UIImage(data: imageData) else {
            throw DoggyFetcherError.imageDataCorrupted
        }
        
        // Spawn another task to cache the downloaded image
        Task {
            try? await cache(imageData)
        }
        
        return image
    }
    
    /// Save the dog image locally
    private static func cache(_ imageData: Data) async throws {
        try imageData.write(to: cachePath)
    }
}


struct DoggyWidget: Widget {
    let kind = "com.SwiftSenpaiDemo.DoggyWidgetView"
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: DoggyTimelineProvider()
        ) { entry in
            DoggyWidgetView(entry: entry)
        }
        .configurationDisplayName("Doggy Widget")
        .description("Unlimited doggy all day long.")
        .supportedFamilies([
            .systemSmall,
        ])
    }
}


