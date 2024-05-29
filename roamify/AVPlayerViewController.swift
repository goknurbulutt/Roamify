//
//  AVPlayerViewController.swift
//  Roamify
//
//  Created by Göknur Bulut on 2.05.2024.
//

import UIKit
import AVKit
import AVFoundation

class FullScreenVideoViewController: UIViewController {
    
    var player: AVPlayer?
    var playerViewController: AVPlayerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Video dosyasının adını ve uzantısını belirtin
        guard let videoURL = Bundle.main.url(forResource: "rota_animasyon", withExtension: "mp4") else {
            print("Video dosyası bulunamadı.")
            return
        }

        // AVPlayer nesnesini oluşturun
        player = AVPlayer(url: videoURL)

        // AVPlayerViewController nesnesini oluşturun ve AVPlayer ile ilişkilendirin
        playerViewController = AVPlayerViewController()
        playerViewController?.player = player

        // AVPlayerViewController'ı tam ekran modunda göstermek için kullanıcıya sunulan ekran boyutunu alın
        let screenSize = UIScreen.main.bounds.size

        // AVPlayerViewController'ı mevcut ekran boyutuna göre boyutlandırın
        playerViewController?.view.frame = CGRect(origin: .zero, size: screenSize)

        // AVPlayerViewController'ı mevcut view'e ekleyin
        addChild(playerViewController!)
        view.addSubview(playerViewController!.view)
        playerViewController?.didMove(toParent: self)

        // AVPlayer'ı oynat
        player?.play()
    }
}
