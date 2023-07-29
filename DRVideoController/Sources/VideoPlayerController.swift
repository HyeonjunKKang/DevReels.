//
//  VideoPlayerController.swift
//  DevReels
//
//  Created by hanjongwoo on 2023/05/14.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import AVFoundation
import RxSwift
import RxCocoa

public protocol PlayVideoLayerContainer {
    var videoURL: String? { get set }
    var videoLayer: AVPlayerLayer { get set }
    func visibleVideoHeight() -> CGFloat
}

public final class VideoPlayerController: NSObject, NSCacheDelegate {
    
    public var shouldPlay = true {
        didSet {
            self.currentVideoContainer()?.shouldPlay = shouldPlay
        }
    }
    
    var minimumLayerHeightToPlay: CGFloat = 60
    
    var mute = false
    
    var preferredPeakBitRate: Double = 1000000
    
    var disposeBag = DisposeBag()
    
    static private var playerViewControllerKVOContext = 0
    
    public static let sharedVideoPlayer = VideoPlayerController()

    private var videoURL: String?
    
    /// 동영상 URL을 키로 저장하고 플레이어 항목이 URL에 연결될 때 True로 저장합니다
    /// 상태 변경에 대해 관찰 중입니다.
    /// 재생되지 않는 플레이어 항목에 대한 관찰자를 제거하는 데 도움이 됩니다.
    public var observingURLs: [String: Bool] = [:]

    private var videoCache = NSCache<NSString, VideoContainer>()
    
    private var videoLayers = VideoLayers()

    public var currentLayer: AVPlayerLayer?
    
    private var playerItemStatusObservation: NSKeyValueObservation?
    
    private override init() {
        super.init()
        videoCache.delegate = self
    }

    deinit {
        print("DEBUG:: 비디오레이어 해제 - 리테인 사이클, 메모리 릭 없음")
    }
}

// MARK: - Public Method

public extension VideoPlayerController {
    /// URL에 해당하는 Video Container가 없을 경우 asset을 다운로드
    /// asset을 이용하여 새로운 플레이어 목록을 만들어줌
    func setupVideoFor(url: String) {
        if self.videoCache.object(forKey: url as NSString) != nil {
            return
        }
        guard let URL = URL(string: url) else {
            return
        }
        let asset = AVURLAsset(url: URL)
        let requestedKeys = ["playable"]
        asset.loadValuesAsynchronously(forKeys: requestedKeys) { [weak self] in
            guard let strongSelf = self else {
                return
            }
            /*
             asset이 성공적으로 로드되었는지 확인하고, 성공하지 않은 경우 AVPlayer와 AVPlayerItem을 생성하지 않고 비디오 컨테이너를 캐시하지 않도록 하여, 필요할 때 다시 다운로드를 시도할 수 있도록 해야합니다.
             */
            var error: NSError?
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            switch status {
            case .loaded:
                break
            case .failed, .cancelled:
                print("Failed to load asset successfully")
                return
            default:
                print("Unkown state of asset")
                return
            }
            let player = AVPlayer()
            let item = AVPlayerItem(asset: asset)
            DispatchQueue.main.async {
                let videoContainer = VideoContainer(player: player, item: item, url: url)
                strongSelf.videoCache.setObject(videoContainer, forKey: url as NSString)
                videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
                /*
                 playVideo 메서드가 호출되었지만 asset을 얻지 못한 경우에는 이전 비디오가 실행되지 않았을 것이므로, 비디오를 다시 재생하려고 시도해본다.
                 */
                if strongSelf.videoURL == url, let layer = strongSelf.currentLayer {
                    strongSelf.playVideo(withLayer: layer, url: url)
                }
            }
        }
    }
    
    // url과 layer를 받아 Video 재생
    func playVideo(withLayer layer: AVPlayerLayer, url: String) {
        videoURL = url
        currentLayer = layer
        
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            layer.player = videoContainer.player
            videoContainer.playOn = true
            addObservers(url: url, videoContainer: videoContainer)
        }
        
        DispatchQueue.main.async {
            if let videoContainer = self.videoCache.object(forKey: url as NSString),
               videoContainer.player.currentItem?.status == .readyToPlay {
                videoContainer.playOn = true
            }
        }
    }
    
    // url과 layer를 받아 Video 일시정지
    func pauseVideo(forLayer layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
        }
    }

    
    // Layer 제거
    func removeLayerFor(cell: PlayVideoLayerContainer) {
        if let url = cell.videoURL {
            removeFromSuperLayer(layer: cell.videoLayer, url: url)
        }
    }
    
    // 재생종료 후 실행
    @objc func playerDidFinishPlaying(note: NSNotification) {
        guard let playerItem = note.object as? AVPlayerItem,
              let currentPlayer = currentVideoContainer()?.player
        else {
            return
        }
        
        if let currentItem = currentPlayer.currentItem, currentItem == playerItem {
            currentPlayer.seek(to: CMTime.zero)
            currentPlayer.play()
        }
    }
    
    /// 스크롤이 멈출 때 최대로 보이는 비디오 레이어 높이를 가진 UITableViewCell의 비디오 플레이어를 재생
    func pausePlayeVideosFor(tableView: UITableView, appEnteredFromBackground: Bool = false) {
        
        let visisbleCells = tableView.visibleCells
        var videoCellContainer: PlayVideoLayerContainer?
        
        var maxHeight: CGFloat = 0.0
        
        for cellView in visisbleCells {
            print(cellView)
            guard let containerCell = cellView as? PlayVideoLayerContainer,
                  let videoCellURL = containerCell.videoURL else {
                continue
            }
            let height = containerCell.visibleVideoHeight()
            if maxHeight < height {
                maxHeight = height
                videoCellContainer = containerCell
            }
            
            pauseRemoveLayer(layer: containerCell.videoLayer, url: videoCellURL, layerHeight: height)
        }
        
        guard let videoCell = videoCellContainer,
              let videoCellURL = videoCell.videoURL else {
            return
        }
        
        let minCellLayerHeight = videoCell.videoLayer.bounds.size.height * 0.5

        let minimumVideoLayerVisibleHeight = max(minCellLayerHeight, minimumLayerHeightToPlay)
        
        if maxHeight > minimumVideoLayerVisibleHeight {
            if appEnteredFromBackground {
                setupVideoFor(url: videoCellURL)
            }
            playVideo(withLayer: videoCell.videoLayer, url: videoCellURL)
        }
    }
    
    /// 캐시에서 객체가 제거될 때, 관찰 대상 URL을 false로 설정
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let videoObject = obj as? VideoContainer {
            observingURLs[videoObject.url] = false
        }
    }
}

// MARK: - Private Method

private extension VideoPlayerController {
    private func getStatus(for asset: AVURLAsset) -> AVKeyValueStatus {
        var error: NSError?
        let status = asset.statusOfValue(forKey: "playable", error: &error)
        return status
    }
    
    private func removeFromSuperLayer(layer: AVPlayerLayer, url: String) {
        videoURL = nil
        currentLayer = nil
        
        if let videoContainer = self.videoCache.object(forKey: url as NSString) {
            videoContainer.playOn = false
            removeObserverFor(url: url)
        }
        
        layer.player = nil
    }
    
    private func pauseRemoveLayer(layer: AVPlayerLayer, url: String, layerHeight: CGFloat) {
        pauseVideo(forLayer: layer, url: url)
    }
    
    private func currentVideoContainer() -> VideoContainer? {
        if let currentVideoUrl = videoURL {
            if let videoContainer = videoCache.object(forKey: currentVideoUrl as NSString) {
                return videoContainer
            }
        }
        return nil
    }

    private func addObservers(url: String, videoContainer: VideoContainer) {
        let observingURL = observingURLs[url]
        guard observingURL == false || observingURL == nil else {
            return
        }
        
        guard let currentItem = videoContainer.player.currentItem else { return }
        
        currentItem.rx.observe(AVPlayerItem.Status.self, "status")
            .compactMap { $0 }
            .filter { $0 == .readyToPlay }
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self,
                      let item = videoContainer.player.currentItem,
                      let currentItem = strongSelf.currentVideoContainer()?.player.currentItem,
                      item == currentItem,
                      strongSelf.currentVideoContainer()?.playOn == true else {
                    return
                }
                
                strongSelf.currentVideoContainer()?.playOn = true
            })
            .disposed(by: disposeBag)
        
        let item = currentItem.observe(\.status, options: [.new, .initial]) { [weak self] playerItem, change in
            guard let newStatus = change.newValue else { return }
            
            if newStatus == .readyToPlay {
                if let currentItem = self?.currentVideoContainer()?.player.currentItem,
                   playerItem === currentItem,
                   self?.currentVideoContainer()?.playOn == true {
                    self?.currentVideoContainer()?.playOn = true
                }
            }
        }
        
        playerItemStatusObservation = item
        
        observingURLs[url] = true
    }

    
    private func removeObserverFor(url: String) {
        print("Removing observer for URL: \(url)")

        guard let videoContainer = self.videoCache.object(forKey: url as NSString),
              let currentItem = videoContainer.player.currentItem,
              observingURLs[url] == true else {
            return
        }
        
        currentItem.rx.observe(AVPlayerItem.Status.self, "status")
            .take(1)
            .subscribe(onNext: { [weak self] _ in
                guard let strongSelf = self,
                      let item = videoContainer.player.currentItem,
                      let currentItem = strongSelf.currentVideoContainer()?.player.currentItem,
                      item == currentItem,
                      strongSelf.currentVideoContainer()?.playOn == true else {
                    return
                }
                
                strongSelf.currentVideoContainer()?.playOn = true
            })
            .disposed(by: disposeBag)
        
        playerItemStatusObservation = nil
    }
}
