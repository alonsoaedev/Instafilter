//
//  ContentView.swift
//  Instafilter
//
//  Created by Alonso Acosta on 12/02/26.
//

import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    
    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
    
    func loadImage() {
        let inputImage = UIImage(resource: .example)
        let begingTime = CIImage(image: inputImage)
        
        let context = CIContext()
        
//        let currentFilter = CIFilter.sepiaTone()
//        let currentFilter = CIFilter.pixellate()
        let currentFilter = CIFilter.crystallize()
        
        currentFilter.inputImage = begingTime
        let inputKeys = currentFilter.inputKeys
        
        // sepiaTone
//        currentFilter.intensity = 1
        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(1, forKey: kCIInputIntensityKey)
        }
        
        // pixellate
//        currentFilter.scale = 5
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(5, forKey: kCIInputScaleKey)
        }
        
        // crystallize
        //        currentFilter.radius = 5
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(5, forKey: kCIInputRadiusKey)
        }
        
        guard let outpuImage = currentFilter.outputImage else { return }
        guard let cgImage = context.createCGImage(outpuImage, from: outpuImage.extent) else { return }
        
        let uiImage = UIImage(cgImage: cgImage)
        image = Image(uiImage: uiImage)
    }
}

#Preview {
    ContentView()
}
