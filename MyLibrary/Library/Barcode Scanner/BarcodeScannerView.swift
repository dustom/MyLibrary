//
//  BarcodeScanner.swift
//  MyLibrary
//
//  Created by Tomáš Dušek on 28.02.2025.
//

import SwiftUI

struct BarcodeScannerView: View {
    @StateObject private var vm = BarcodeScannerViewModel()
    @State private var isBarcodeFound: Bool = false
    
    var body: some View {
        
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
            Text("Requesing access to camera...")
            ProgressView()
            
        }
        Text("")
            .onAppear{
                Task {
                    await vm.requestDataScannerAccessStatus()
                }
            }
            .fullScreenCover(isPresented: $isBarcodeFound) {
                if let barcode = vm.recognizedItem.first {
                    switch barcode {
                    case .barcode(let value):
                        SearchView(barcode: value.payloadStringValue)
                    default:
                        SearchView()
                    }
                }
            }
    }
    
    private var mainView: some View {
        DataScannerView(recognizedItems: $vm.recognizedItem, foundBarcode: $isBarcodeFound)
    }
}

#Preview {
    BarcodeScannerView()
}
