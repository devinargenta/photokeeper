//
//  CameraViewController.swift
//  PhotoKeeper
//
//  Created by Devin Argenta on 5/3/18.
//  Copyright © 2018 Devin Argenta. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {

    var store = PhotoStore.shared

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?

    let cameraButton = UIButton()

    // MARK: colors
    var blueblack = UIColor(hue: 0.6333, saturation: 0.15, brightness: 0.64, alpha: 1.0)
    lazy var blueblackCG = blueblack.cgColor

    // MARK: the app
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    func setupView() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barStyle = .blackTranslucent
        navigationController?.navigationBar.tintColor = .white
        navigationItem.leftBarButtonItem =
            UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(closeView))
        buildCameraButton()
        initializeCaptureDevice()
    }


    func buildCameraButton(){
        let camButtonLayer = cameraButton.layer
        cameraButton.frame = CGRect(x: 0, y: 0, width: 65, height: 65)
        let sbsize = cameraButton.bounds.size
        cameraButton.center.x = view.frame.width - (sbsize.width)
        cameraButton.center.y = view.frame.height - (sbsize.height)
        camButtonLayer.cornerRadius = 0.5 * cameraButton.bounds.size.width
        camButtonLayer.borderWidth = 1
        camButtonLayer.borderColor = blueblackCG
        camButtonLayer.shadowColor = blueblackCG
        camButtonLayer.shadowOpacity = 0.9
        camButtonLayer.shadowOffset = CGSize(width: 2, height: 2)
        camButtonLayer.shadowRadius = 2
        camButtonLayer.shadowPath = UIBezierPath(roundedRect: cameraButton.bounds, cornerRadius: 0.5 * sbsize.width).cgPath
        cameraButton.backgroundColor = .white
        cameraButton.setTitle("+", for: .normal)
        cameraButton.setTitleColor(blueblack, for: .normal)
        cameraButton.addTarget(self, action: #selector(takePhoto), for: UIControlEvents.touchUpInside)
        view.addSubview(cameraButton)
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {

    func initializeCaptureDevice() {

        guard let captureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            fatalError("No video device found")
        }

        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)

            captureSession = AVCaptureSession()
            captureSession?.sessionPreset = AVCaptureSession.Preset.photo
            captureSession?.addInput(input)

            // Get an instance of ACCapturePhotoOutput class
            capturePhotoOutput = AVCapturePhotoOutput()
            let settings = AVCapturePhotoSettings()
            settings.livePhotoVideoCodecType = .jpeg
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true

            if captureSession!.canAddOutput(capturePhotoOutput!) {
                captureSession?.addOutput(capturePhotoOutput!)
            }

            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds

            //start video capture
            view.layer.insertSublayer(videoPreviewLayer!, at: 0)
            captureSession?.startRunning()
        } catch {
            print(error)
        }
    }

    @objc func closeView() {
        dismiss(animated: true, completion: nil)
    }

    @objc func takePhoto() {
        // take a  photo
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.livePhotoVideoCodecType = .jpeg
        photoSettings.isAutoStillImageStabilizationEnabled = true
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
        guard let image = UIImage.init(data: imageData, scale: 1.0) else { return }
        let ppvc = PhotoPreviewViewController()
        ppvc.image = image
        navigationController?.pushViewController(ppvc, animated: false)
        }
    }
}
