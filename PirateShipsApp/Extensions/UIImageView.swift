//
//  UIImageView.swift
//  PirateShipsApp
//
//  Created by Victor Magalhaes on 17/03/19.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation
import UIKit

fileprivate let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    public func loadImage(_ URLString: String, placeHolder: UIImage?) {
        
        self.image = nil
        if let cachedImage = imageCache.object(forKey: NSString(string: URLString)) {
            self.image = cachedImage
            return
        }
        
        if let url = URL(string: URLString) {
            URLSession.shared.dataTask(with: url, completionHandler: { [weak self] (data, _, error) in
                
                let status = (data, error)
                
                switch status {
                case (.some(let data), _):
                    if let downloadedImage = UIImage(data: data) {
                        imageCache.setObject(downloadedImage, forKey: NSString(string: URLString))
                        DispatchQueue.main.async {
                            self?.image = downloadedImage
                        }
                    } else {
                        guard let placeHolder = placeHolder else { return }
                        DispatchQueue.main.async {
                            self?.image = placeHolder
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        self?.image = placeHolder
                    }
                }
            }).resume()
        }
    }
}
