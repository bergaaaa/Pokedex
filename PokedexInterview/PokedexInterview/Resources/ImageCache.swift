//
//  ImageCache.swift
//  PokedexInterview
//
//  Created by Gabriel Bergamo on 11/06/24.
//

import UIKit

/// An image cache object that will download an image from the network or return that image from a local `NSCache`.
/// The load image function is called on a background thread and returns the resulting image on the main thread.
final class ImageCache {
    // MARK: Private properties
    private lazy var queue = DispatchQueue(label: Self.queueLabel, qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .inherit)
    private static let queueLabel: String = "com.swiftPokedex.ios.imageDownload.queue"
    private let cache = NSCache<NSURL, UIImage>()

    // MARK: - Public properties
    /// A static constant value of `ImageCache` which makes it into a singleton object
    static let `default` = ImageCache()

    // MARK: - Init
    private init() {}

    // MARK: - Public functions
    /// Load an image from a given URL on a background thread or retrieve it from the local memory cache
    /// - parameters:
    ///     - urlString: The URL string to load the image from
    ///     - completion: A completion block that runs when the image is retrieved from cache or the network
    func loadImage(from urlString: String, completion: @escaping (UIImage?) -> Swift.Void) {
        guard let url = NSURL(string: urlString) else { fatalError("URL couldn't be created. This should never happen!") }

        if let cachedImage = cache.object(forKey: url) {
            DispatchQueue.main.async { completion(cachedImage) }
        } else {
            queue.async {
                do {
                    let data = try Data(contentsOf: url as URL)
                    let image = UIImage(data: data)
                    if let image = image { self.cache.setObject(image, forKey: url) }
                    DispatchQueue.main.async { completion(image) }
                } catch {
                    DispatchQueue.main.async { completion(nil) }
                }
            }
        }
    }
}
