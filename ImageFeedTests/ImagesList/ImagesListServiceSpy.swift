//
//  ImagesListServiceSpy.swift
//  ImageFeedTests
//
//  Created by Anastasia Gorbunova on 08.02.2024.
//
import ImageFeed
import Foundation

final class ImagesListServiceSpy: ImagesListServiceProtocol {
    var photosWereUpdated: Bool = false
    static let shared = ImagesListServiceSpy()
    private (set) var photos: [Photo] = []
    
    func fetchPhotosNextPage() {
        photosWereUpdated = true
    }
    
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, Error>) -> Void) {}
}
