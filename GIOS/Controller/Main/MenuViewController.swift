//
//  MenuViewController.swift
//  GIOS
//
//  Created by 정종문 on 2021/02/11.
//

import UIKit
import SwiftyGif

class MenuViewController: UIViewController {
    
    @IBOutlet weak var gifImageView: UIImageView!
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var albumButton: UIButton!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var mapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setDisplayUI()
        setGIFLogo()
    }
    
    func setDisplayUI() {
        self.signButton.setTitle("Account", for: .normal)
        self.cameraButton.setTitle("Camera", for: .normal)
        self.albumButton.setTitle("Album", for: .normal)
        self.weatherButton.setTitle("Weather", for: .normal)
        self.mapButton.setTitle("Map", for: .normal)
    }
    
    func setGIFLogo() {
        do {
            let gif = try UIImage(gifName: "logo.gif")
            self.gifImageView.setGifImage(gif)
        } catch let error as NSError {
            print("GIF Error : \(error.localizedDescription)")
        }
    }
}
