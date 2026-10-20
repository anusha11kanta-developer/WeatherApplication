//
//  ImageCacheFile.swift
//  WeatherForeCastApp
//
//  Created by Anusha on 10/19/26.
//

import Foundation
import UIKit

//final class ImageCacheService {
//    static let shared = NSCache<NSString, UIImage>()
//
//    func loadImage(from url: URL) async -> UIImage? {
//        let key = url.absoluteString as NSString
//
//        if let cached = Self.shared.object(forKey: key) {
//            return cached
//        }
//
//        guard let (data, _) = try? await URLSession.shared.data(from: url),
//              let image = UIImage(data: data) else {
//            return nil
//        }
//
//        Self.shared.setObject(image, forKey: key)
//        return image
//    }
//}
enum Strings {
    static let searchCity = "search_city"
    static let enterCity = "enter_city"
}
enum AlertState: Identifiable {
    case message(String)

    var id: String {
        switch self {
        case .message(let msg):
            return msg
        }
    }
}
