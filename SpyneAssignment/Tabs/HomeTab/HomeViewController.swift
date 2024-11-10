//
//  HomeViewController.swift
//  SpyneAssignment
//
//  Created by Akash on 08/11/24.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
//        let camerVC = CameraViewController()
//        self.present(camerVC, animated: true, completion: nil)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
import Photos
class CameraViewController: UIViewController {
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var db:  RealmDB
    let file : FilesManager
    
    init(db: RealmDB, file: FilesManager) {
       
        self.db = db
        self.file = file
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the camera
        setupCamera()
        // Add a capture button
          let captureButton = UIButton(frame: CGRect(x: (view.frame.width - 70) / 2, y: view.frame.height - 200, width: 70, height: 70))
          captureButton.backgroundColor = UIColor.red.withAlphaComponent(0.7)
          captureButton.layer.cornerRadius = 35
          captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
          view.addSubview(captureButton)
    }
    
    private func setupCamera() {
        // Initialize the capture session
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = .high
        
        // Set up the device (back camera)
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: camera),
              let captureSession = captureSession else {
            print("Failed to access the back camera.")
            return
        }
        
        // Add input to capture session
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        }
        
        // Set up the output for photo capturing
        let photoOutput = AVCapturePhotoOutput()
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        // Set up the preview layer
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        if let previewLayer = videoPreviewLayer {
            view.layer.addSublayer(previewLayer)
        }
        
        // Start the capture session
        captureSession.startRunning()
    }
    
    // Capture Photo Button Action
    @objc func capturePhoto() {
        guard let captureSession = captureSession, captureSession.isRunning else {
            print("Capture session is not running")
            return
        }
        
        if let photoOutput = captureSession.outputs.first as? AVCapturePhotoOutput {
            let settings = AVCapturePhotoSettings()
            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    // Handle photo capture
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error)")
            return
        }
        
        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            print("Failed to convert photo data to UIImage")
            return
        }
        
        print("Photo captured: \(image)")
        
        
        let timeStamp = Date().timeIntervalSince1970
        
        let imageTask = ImageTask()
        imageTask.imageName = "spyne_\(timeStamp)"
        imageTask.imageURI = ""
        imageTask.captureDate = "\(timeStamp)"
        imageTask.uploadStatus = false
        
        db.saveDataRealm(imageTask)
        
        Task{
            await file.save(photo, "\(timeStamp)")
        }
        
        
    }
    
}
