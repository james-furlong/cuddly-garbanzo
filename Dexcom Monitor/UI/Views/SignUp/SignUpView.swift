//
//  SignUpView.swift
//  Dexcom Monitor
//
//  Created by James on 28/12/2022.
//

import SwiftUI

struct SignUpView: View {
    let viewModel: SignUpViewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color("BackgroundMain"), Color("BackgroundSupp")],
                center: .center,
                startRadius: 1,
                endRadius: 700
            ).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                VStack {
                    Text("Dexcom Monitor")
                        .font(.system(size: 35))
                }
                
                VStack {
                    Button {
                        viewModel.signIn()
                    } label: {
                        Text("Login")
                            .font(.system(size: 20).bold())
                            .foregroundColor(Color("FontMain"))
                    }
                    .padding()
                }
            }
        }
    }
    
//    init() {
//        setupSink()
//    }
//    
//    func setupSink() {
//        viewModel.authCompleteSubject.sink { isComplete in
//            // TODO: Move to dashboard
//        }
//    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
