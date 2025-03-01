//
//  BarcodeScanner.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import SwiftUI

struct BarcodeScannerView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var vm = BarcodeScannerViewModel()
    @State var searchFinished = false
    @Binding var barcode: String
    @Binding var isBarcodeFound: Bool
    
    // will have to store barcode and barcode found as a binding variable, maybe just one of them... and pass it back to library when dismissing the view
    
    var body: some View {
        NavigationStack{
            switch vm.dataScannerAccesStatus {
            case .scannerAvailable:
                mainView
            case .cameraNotAvailable:
                Text("Your device doesn't have a camera.")
            case .scannerNotAvailable:
                Text("Your device can't use this functionality.")
            case .cameraAccessNotGranted:
                Text("Please provide access to the camera in settings.")
            case .notDetermined:
                Text("Requesting access to camera...")
                ProgressView()
                
            }
        }
        .onAppear{
            isBarcodeFound = false
            Task {
                await vm.requestDataScannerAccessStatus()
            }
        }
        .onChange(of: isBarcodeFound) {
            if let barcode = vm.recognizedItem.first {
                switch barcode {
                case .barcode(let value):
                    self.barcode = value.payloadStringValue ?? ""
                    isBarcodeFound = true
                    dismiss()
                default:
                    dismiss()
                }
            }
        }
    }
    
    private var mainView: some View {
        DataScannerView(recognizedItems: $vm.recognizedItem, foundBarcode: $isBarcodeFound)
    }
}

#Preview {
    @Previewable @State var barcode: String = ""
    @Previewable @State var barcodeFound: Bool = false
    BarcodeScannerView(barcode: $barcode, isBarcodeFound: $barcodeFound)
}
