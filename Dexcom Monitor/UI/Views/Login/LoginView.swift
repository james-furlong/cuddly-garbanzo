//
//  LoginView.swift
//  Dexcom Monitor
//
//  Created by James on 28/12/2022.
//

import SwiftUI

struct LoginView: View {
    enum ViewState {
        case start
        case clientName
        case userName
        case login
        case complete(Bool)
        
        var title: String {
            switch self {
                case .start: return "Get started"
                case .clientName: return "Your name"
                case .userName: return "Their name"
                case .login: return "Login"
                case .complete(let isSuccess): return isSuccess ? "Success" : "Error"
            }
        }
        
        var subtitle: String {
            switch self {
                case .start: return "We just need to get a few details from you"
                case .clientName: return "What would you like us to call you?"
                case .userName: return "What is the name of the person you're following?"
                case .login: return "We just need you to log into your follow account"
                case .complete(let isSuccess): return isSuccess ? "Let's head to your dashboard" : "Something went wrong, try again later"
            }
        }
    }
    
    
    
    let viewModel: LoginViewModel = LoginViewModel()
    
    
    @State var showDetails: Bool = true
    
    var body: some View {
        ZStack {
            RadialGradient(
                colors: [Color("BackgroundMain"), Color("BackgroundSupp")],
                center: .center,
                startRadius: 1,
                endRadius: 700
            ).edgesIgnoringSafeArea(.all)
            
            VStack {
                Button("Press to show details") {
                    withAnimation {
                        showDetails.toggle()
                    }
                }

                if showDetails {
                    // Moves in from the bottom
                    VStack {
                        Text("Dexcom Monitor")
                            .font(.system(size: 35))
                            .frame(maxWidth: .infinity)
                        
                        // Moves in from leading out, out to trailing edge.
                        Text("Details go here.")
//                            .transition(.slide)
                        
                        // Starts small and grows to full size.
                        Text("Details go here.")
//                            .transition(.scale)
                    }
                    .transition(.backslide)
                }
            }

//            VStack(spacing: 0) {
//                VStack {
//                    if isShowing {
//                        Text("Dexcom Monitor")
//                            .font(.system(size: 35))
//                            .transition(.move(edge: .bottom))
//                    }
//                }
//
//                VStack {
//                    if isShowing {
//                        Button {
//                            viewModel.signIn()
//                        } label: {
//                            Text("Login")
//                                .font(.system(size: 20).bold())
//                                .foregroundColor(Color("FontMain"))
//                        }
//                        .padding()
//                        .transition(.move(edge: .leading))
//                    }
//                }
//            }
//
//            VStack {
//                Spacer()
//
//                Button("Test") { isShowing.toggle() }
//                    .foregroundColor(.black)
//                    .padding()
//            }
        }
    }
    
    init() {
        setupSink()
    }
    
    func setupSink() {
        viewModel.authCompleteSubject.sink { isComplete in
            // TODO: Move to dashboard
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
