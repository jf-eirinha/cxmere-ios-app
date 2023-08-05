//
//  ContentView.swift
//  Cxmere
//
//  Created by João Eirinha on 05/08/2023.
//

import SwiftUI
import PhotosUI

@MainActor
final class ContentViewViewModel: ObservableObject {
    @Published private(set) var selectedImage: UIImage? = nil
    @Published var imageSelection: PhotosPickerItem? = nil {
        didSet {
            setImage(from: imageSelection)
        }
    }
    
    private func setImage(from selection: PhotosPickerItem?) {
        guard let selection else { return }
        
        Task {
            if let data = try? await selection.loadTransferable(type: Data.self) {
                if let uiImage = UIImage(data: data){
                    selectedImage = uiImage
                    return
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var viewModel = ContentViewViewModel()
    
    var body: some View {
        VStack {
            
        if let image = viewModel.selectedImage {
            Image(uiImage: image).resizable().frame(width: 300, height: 300).cornerRadius(10)
        }
        
        PhotosPicker("Pick an image", selection: $viewModel.imageSelection, matching: .images)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
