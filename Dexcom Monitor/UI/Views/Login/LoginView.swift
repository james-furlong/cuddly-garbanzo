//
//  LoginView.swift
//  Dexcom Monitor
//
//  Created by James on 28/12/2022.
//

import SwiftUI
import Combine

struct LoginView: View {
    
    private var cancellables = Set<AnyCancellable>()
    private var details: LoginDetailModel = LoginDetailModel()
    var authModel: OAuthModel = OAuthModel(api: DexcomAPI())
    
    @State private var viewState: LoginViewState = .clientName
    @State private var showDetails: Bool = true
    @State private var inputText: String = ""
    @FocusState private var textFieldFocused: LoginViewState?

    var body: some View {
        GeometryReader { geo in
            VStack {
                VStack {
                    if showDetails {
                        VStack(alignment: .center) {
                            Text(viewState.title)
                                .font(.system(size: 35))
                                .foregroundColor(Color("Font"))
                                .fontWeight(.semibold)
                                
                            
                            Text(viewState.subtitle)
                                .foregroundColor(Color("Font"))
                                .multilineTextAlignment(.center)
                                .padding(.bottom, 20)
                        }
                        .frame(width: geo.size.width - 50)
                        .transition(.opacity)
                        
                        VStack(alignment: .center) {
                            TextField("", text: $inputText)
                                .padding()
                                .background(Color("BackgroundSupp"))
                                .foregroundColor(Color("Font"))
                                .cornerRadius(20)
                                .isHidden(viewState.hideTextField)
                        }
                        .frame(width: geo.size.width - 50)
                        .transition(.backslide)
                    }
                }
                .frame(width: geo.size.width)
                .padding(.top, 30)
                
                Spacer()
                
                VStack {
                    Spacer()
                    
                    HStack {
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showDetails = false
                            }
                            submitField()
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text(viewState.submitTitle)
                                    .font(.system(size: 20))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("Charcoal"))
                                    .padding()
                                
                                Spacer()
                            }
                        }
                        .frame(height: 55)
                        .background(Color("Accent"))
                        .cornerRadius(20)
                        .padding(.bottom, 50)
                        .padding(.trailing, 30)
                        .padding(.leading, 30)
                    }
                }
                .frame(width: geo.size.width)
            }
        }
        .background(Color("Background"))
        .edgesIgnoringSafeArea(.all)
    }
    
    init() {
        setupSink()
    }
    
    private func submitField() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            details.update(with: inputText, for: viewState)
            inputText = ""
            viewState = viewState.nextState
            withAnimation {
                showDetails = true
            }
        }
    }
    
    mutating func setupSink() {
        authModel.authCompleteSubject
            .sink { isComplete in
                // TODO: Move to dashboard
            }
            .store(in: &cancellables)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
