//
//  BarcodeScannerViewModel.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import AVKit
import Foundation
import SwiftUI
import VisionKit

enum DataScannerAccessStatusType {
    case notDetermined
    case cameraAccessNotGranted
    case cameraNotAvailable
    case scannerNotAvailable
    case scannerAvailable
}


@MainActor
final class BarcodeScannerViewModel: ObservableObject {
    @Published var dataScannerAccesStatus: DataScannerAccessStatusType = .notDetermined
    @Published var recognizedItem: [RecognizedItem] = []
    
    
    
    private var isScannerAvailable: Bool {
        DataScannerViewController.isAvailable && DataScannerViewController.isSupported
    }
    
    func requestDataScannerAccessStatus() async {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            dataScannerAccesStatus = .cameraNotAvailable
            return
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            dataScannerAccesStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            
        case .restricted, .denied:
            dataScannerAccesStatus = .cameraAccessNotGranted
            
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                dataScannerAccesStatus = isScannerAvailable ? .scannerAvailable : .scannerNotAvailable
            } else {
                dataScannerAccesStatus = .cameraAccessNotGranted
            }
        default : break
        }
    }
    
}
