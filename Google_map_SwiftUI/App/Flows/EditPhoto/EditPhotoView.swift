//
//  EditPhotoView.swift
//  Google_map_SwiftUI
//
//  Created by Александра Макей on 14.12.2023.
//

import SwiftUI
import AVFoundation

struct EditPhotoView: View {
    //MARK: - Properties
    @Binding var image: UIImage?
    var alert = Alerts()
    //MARK: - Show view
    @State private var showImageLibrary = false
    @State private var showCamera = false
    @State private var showMainView = false
    @State private var isCameraNotAvailable = false
    
    var body: some View {
        VStack {
            VStack {
                if let uiImage = image {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                } else {
                    Image(uiImage: UIImage(systemName: "person.fill")!)
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.gray)
                        .frame(width: UIScreen.main.bounds.width/4, height: UIScreen.main.bounds.height/4)
                }
            }
            
            Spacer().frame(height: 50)
            VStack(spacing: 16) {
                Button("Take Image") {
                    if UIImagePickerController.isSourceTypeAvailable(.camera) {    self.showCamera.toggle()
                        
                    } else {
                        self.isCameraNotAvailable = true
                    }
                }
                Button("Select Image") {
                    self.showImageLibrary.toggle()
                }
                Button("Save") {
                    if let image = image {
                        FilesManager.saveImage(imageName: FilesManager.userImageName, image: image)
                    }
                    self.showMainView.toggle()
                }
            }.padding()
            
        }
        //MARK: - Presenters
        .sheet(isPresented: $showImageLibrary, onDismiss: loadImageFromLibrary) {
            ImagePicker(selectedImage: $image, sourceType: .photoLibrary) { _ in }
        }
        .sheet(isPresented: $showCamera, onDismiss: loadImageFromCamera) {
            ImagePicker(selectedImage: $image, sourceType: .camera) { _ in }
        }
        .fullScreenCover(isPresented: $showMainView) {
            MainView()
        }
        .alert(isPresented: $isCameraNotAvailable) {
            self.alert.showCameraNotAvailable()
        }
    }
    
    func loadImageFromLibrary() {
        print("Load image from user library success")
    }
    
    func loadImageFromCamera() {
        print("Load image from user camera success")
    }
}
//
//#Preview {
//    MainView()
//}

