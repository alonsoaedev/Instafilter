//
//  ContentView.swift
//  Instafilter
//
//  Created by Alonso Acosta on 12/02/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import PhotosUI
import StoreKit
import SwiftUI

struct ContentView: View {
    @State private var processedImage: Image?
    @State private var filterIntensity: Double = 0.0
    @State private var filterRadius: Double = 0.0
    @State private var filterScale: Double = 0.0
    @State private var disableIntensityFilter: Bool = true
    @State private var disableRadiusFilter: Bool = true
    @State private var disableScaleFilter: Bool = true
    @State private var selectedItem: PhotosPickerItem?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilters = false
    
    @AppStorage("filter_count") var filterCount: Int = 0
    @Environment(\.requestReview) var requestReview
    
    let context: CIContext = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                    } else {
                        ContentUnavailableView(
                            "No picture",
                            systemImage: "photo.badge.plus",
                            description: Text("Tap to import a photo")
                        )
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                
                Group {
                    HStack {
                        Text("Intensity")
                        Slider(value: $filterIntensity)
                            .onChange(of: filterIntensity, applyProcessing)
                            .disabled(disableIntensityFilter)
                    }
                    
                    HStack {
                        Text("Radius")
                        Slider(value: $filterRadius)
                            .onChange(of: filterRadius, applyProcessing)
                            .disabled(disableRadiusFilter)
                    }
                    
                    HStack {
                        Text("Scale")
                        Slider(value: $filterScale)
                            .onChange(of: filterScale, applyProcessing)
                            .disabled(disableScaleFilter)
                    }
                    
                    HStack {
                        Button("Change Filter", action: changeFilter)
                        
                        Spacer()
                        
                        if let processedImage {
                            ShareLink(
                                item: processedImage,
                                preview: SharePreview("Instafilter image", image: processedImage)
                            )
                        }
                    }
                }
                .disabled(processedImage == nil)
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Instafilter")
            .confirmationDialog("Select a filter", isPresented: $showingFilters) {
                Button("Crystalize") { setFilter(CIFilter.crystallize()) }
                Button("Edges") { setFilter(CIFilter.edges()) }
                Button("Gaussian Blur") { setFilter(CIFilter.gaussianBlur()) }
                Button("Pixellate") { setFilter(CIFilter.pixellate()) }
                Button("Sepia Tone") { setFilter(CIFilter.sepiaTone()) }
                Button("Unsharp Mask") { setFilter(CIFilter.unsharpMask()) }
                Button("Vignette") { setFilter(CIFilter.vignette()) }
                Button("Cancel", role: .cancel) {  }
            }
        }
    }
    
    func changeFilter() {
        showingFilters = true
    }
    
    func loadImage() {
        Task {
            guard let imageData = try await selectedItem?.loadTransferable(type: Data.self) else { return }
            guard let inputImage = UIImage(data: imageData) else { return }
            
            let beginImage = CIImage(image: inputImage)
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
            applyProcessing()
        }
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) {
            disableIntensityFilter = false
            disableRadiusFilter = true
            disableScaleFilter = true
            currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey) {
            disableRadiusFilter = false
            disableIntensityFilter = true
            disableScaleFilter = true
            currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey) {
            disableScaleFilter = false
            disableIntensityFilter = true
            disableRadiusFilter = true
            currentFilter.setValue(filterScale * 100, forKey: kCIInputScaleKey)
        }
        
        guard let outputImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outputImage, from: outputImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        processedImage = Image(uiImage: uiImage)
    }
    
    // @MainActor ???
    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
        
        filterCount += 1
        
        if filterCount >= 20 {
            requestReview()
            filterCount = 0
        }
    }
}

#Preview {
    ContentView()
}
