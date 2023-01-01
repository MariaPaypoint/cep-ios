//
//  LottieView.swift
//  cep
//
//  Created by Maria Novikova on 02.01.2023.
// https://github.com/airbnb/lottie-ios/blob/b4bd0604ded9574807f41b4004b57dd1226a30a4/Example/macOS/ViewController.swift

import SwiftUI
import Lottie
 
struct LottieView: UIViewRepresentable {
    
    let lottieFile: String = "animation_done"
 
    //let animationView = LottieAnimationView()
    var animationView: LottieAnimationView
 
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
 
        animationView.animation = LottieAnimation.named(lottieFile)
        animationView.contentMode = .scaleAspectFit
        //animationView.play()
 
        view.addSubview(animationView)
 
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        animationView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
 
        return view
    }
 
    func updateUIView(_ uiView: UIViewType, context: Context) {
 
    }
}
