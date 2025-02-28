//
//  DataScannerView.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import Foundation
import SwiftUI
import VisionKit

struct DataScannerView: UIViewControllerRepresentable {
    
    @Binding var recognizedItems: [RecognizedItem]
    @Binding var foundBarcode: Bool
    
    func makeUIViewController(context: Context) -> DataScannerViewController {
        let vc = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        return vc
    }
    
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        uiViewController.delegate = context.coordinator
        try? uiViewController.startScanning()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(recognizedItem: $recognizedItems, foundBarcode: $foundBarcode)
    }
    
    static func dismantleUIViewController(_ uiViewController: DataScannerViewController, coordinator: Coordinator) {
        uiViewController.stopScanning()
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        @Binding var recognizedItem: [RecognizedItem]
        @Binding var foundBarcode: Bool
        
        init(recognizedItem: Binding<[RecognizedItem]>, foundBarcode: Binding<Bool>) {
            self._recognizedItem = recognizedItem
            self._foundBarcode = foundBarcode
        }
        
        func dataScannerViewController(_ dataScanner: DataScannerViewController, didScan item: RecognizedItem) {
            print("Scanned: \(item)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItem: [RecognizedItem], allItems: [RecognizedItem]) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            self.recognizedItem = addedItem
            self.foundBarcode = true
            print("didAddItem \(addedItem)")
        }
        
        func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
            print("An error occurred: \(error.localizedDescription)")
        }
    }
}
