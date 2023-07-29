//
//  TrimVideoViewController.swift
//  DevReels
//
//  Created by HoJun on 2023/05/16.
//  Copyright © 2023 DevReels. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import PryntTrimmerView
import SnapKit
import Then
import PhotosUI

final class VideoTrimmerViewController: ViewController {

    // MARK: - Properties
    
    private let muteButton = UIButton().then {
        $0.setImage(UIImage(systemName: "speaker.wave.2.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        $0.setImage(UIImage(systemName: "volume.slash")?.withTintColor(.devReelsColor.primary90 ?? UIColor.orange, renderingMode: .alwaysOriginal), for: .selected)
    }

    private let albumButton = UIButton().then {
        $0.tintColor = .devReelsColor.neutral1000
        $0.setImage(UIImage(systemName: "photo.stack"), for: .normal)
    }
    
    private let cancelButton = UIButton().then {
        $0.setTitleColor(.devReelsColor.neutral100, for: .normal)
        $0.setTitle("취소", for: .normal)
    }

    private let nextButton = UIButton().then {
        $0.setTitleColor(.devReelsColor.neutral100, for: .disabled)
        $0.setTitleColor(.devReelsColor.primary80, for: .normal)
        $0.setTitle("다음", for: .normal)
        $0.isEnabled = false
    }
    
    private let playerView = UIView()
    private let trimmerView = TrimmerView()

    var player: AVPlayer?
    var playbackTimeCheckerTimer: Timer?
    var trimmerPositionChangedTimer: Timer?

    private var videoPicker: UIImagePickerController?
    private var videoSourceURL: URL?
    private var videoDestinationURL: URL?
    
    let selectedVideoURLSubject = PublishSubject<URL>()
    let startTimeSubject = PublishSubject<CMTime>()
    let endTimeSubject = PublishSubject<CMTime>()
    
    private var viewModel: VideoTrimmerViewModel
    
    init(viewModel: VideoTrimmerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configurePicker()
        configureNavigationBar()
        configureTrimmerView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - binds

    override func bind() {
        
        albumButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.presentPicker()
            })
            .disposed(by: disposeBag)
        
        let muteObservable = muteButton.rx.tap
            .withUnretained(self)
            .map {
                $0.0.muteButton.isSelected.toggle()
                return $0.0.muteButton.isSelected
            }
            .asObservable()
            
        
        let input = VideoTrimmerViewModel.Input(
            isMute: muteObservable,
            nextButtonTapped: nextButton.rx.tap.throttle(.seconds(1), scheduler: MainScheduler.instance),
            cancelButtonTapped: cancelButton.rx.tap.throttle(.seconds(1), scheduler: MainScheduler.instance),
            selectedVideoURL: selectedVideoURLSubject.asObserver(),
            startTime: startTimeSubject.asObserver(),
            endTime: endTimeSubject.asObserver()
        )
        
        let output = viewModel.transform(input: input)
                
        output.nextButtonEnabled
            .drive(nextButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Methods
    
    private func configureNavigationBar() {
        navigationItem.title = "비디오 수정하기"
    }
    
    private func configureTrimmerView() {
        trimmerView.handleColor = .white
        trimmerView.mainColor = .devReelsColor.primary90 ?? .orange
        trimmerView.positionBarColor = .white
        trimmerView.maskColor = UIColor(red: 9 / 255, green: 30 / 255, blue: 66 / 255, alpha: 0.6)
    }

    private func play() {
        guard let player = player else { return }

        if !player.isPlaying {
            player.play()
            startPlaybackTimeChecker()
        } else {
            player.pause()
            stopPlaybackTimeChecker()
        }
    }

    private func loadAsset(_ asset: AVAsset) {
        trimmerView.asset = asset
        trimmerView.delegate = self
        addVideoPlayer(with: asset, playerView: playerView)
    }

    private func addVideoPlayer(with asset: AVAsset, playerView: UIView) {
        let playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        let layer = AVPlayerLayer(player: player)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = CGRect(x: 0, y: 0, width: playerView.frame.width, height: playerView.frame.height)
        layer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerView.layer.sublayers?.forEach({ $0.removeFromSuperlayer() })
        playerView.layer.addSublayer(layer)
        updateTime()
    }


    private func startPlaybackTimeChecker() {
        stopPlaybackTimeChecker()
        playbackTimeCheckerTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                                        target: self,
                                                        selector: #selector(onPlaybackTimeChecker),
                                                        userInfo: nil,
                                                        repeats: true)
    }

    private func stopPlaybackTimeChecker() {
        playbackTimeCheckerTimer?.invalidate()
        playbackTimeCheckerTimer = nil
    }

    @objc func onPlaybackTimeChecker() {

        guard let startTime = trimmerView.startTime,
              let endTime = trimmerView.endTime,
              let player = player else { return }

        let playBackTime = player.currentTime()
        trimmerView.seek(to: playBackTime)

        if playBackTime >= endTime {
            player.seek(to: startTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
            trimmerView.seek(to: startTime)
        }
    }
    
    private func updateTime() {
        if let start = trimmerView.startTime,
            let end = trimmerView.endTime {
            let duration = (end - start).seconds
            startTimeSubject.onNext(start)
            endTimeSubject.onNext(end)
        }
    }

    override func layout() {

        view.addSubview(playerView)
        playerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.5)
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        view.addSubview(trimmerView)
        trimmerView.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(56)
        }
        
        view.addSubview(muteButton)
        muteButton.snp.makeConstraints { make in
            make.top.equalTo(trimmerView.snp.bottom).offset(30)
            make.leading.equalTo(trimmerView.snp.leading)
        }
        
        view.addSubview(albumButton)
        albumButton.snp.makeConstraints { make in
            make.top.equalTo(trimmerView.snp.bottom).offset(30)
            make.trailing.equalTo(trimmerView.snp.trailing)
        }

        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.leading.equalTo(trimmerView.snp.leading)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.trailing.equalTo(trimmerView.snp.trailing)
        }
    }
}

// MARK: - Tirmmer Delegate

extension VideoTrimmerViewController: TrimmerViewDelegate {
    func positionBarStoppedMoving(_ playerTime: CMTime) {
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
        player?.play()
        startPlaybackTimeChecker()
        updateTime()
    }

    func didChangePositionBar(_ playerTime: CMTime) {
        stopPlaybackTimeChecker()
        player?.pause()
        player?.seek(to: playerTime, toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero)
    }
}

// MARK: - Picker

extension VideoTrimmerViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    private func configurePicker() {
        videoPicker = UIImagePickerController()
        videoPicker?.delegate = self
        videoPicker?.sourceType = .savedPhotosAlbum
        videoPicker?.mediaTypes = ["public.movie"]
        videoPicker?.allowsEditing = false
    }

    private func presentPicker() {
        guard let videoPicker else { return }
        present(videoPicker, animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
       self.dismiss(animated: true)
     }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true)

        if let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            DispatchQueue.main.async { [weak self] in
                self?.selectedVideoURLSubject.onNext(url)
                self?.loadAsset(AVAsset(url: url))
            }
        }
    }
}
