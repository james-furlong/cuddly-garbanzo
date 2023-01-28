//
//  OnboardingView.swift
//  Dexcom Monitor
//
//  Created by James on 28/1/2023.
//

import SwiftUI

struct OnboardingView: View {
    private let complete: () -> ()
    @State private var showLogin: Bool = false
    @State var currentCell: WalkthroughCell = .insights
    
    // MARK: - Initialization
    
    init(completion: @escaping () -> ()) {
        self.complete = completion
    }
    
    var body: some View {
            ZStack {
                if showLogin {
                    LoginView { complete() }
                        .transition(.slide)
                }
                else {
                    VStack {
                        WalkthroughView(cell: currentCell)
                            .transition(.slide)
                            .padding(.top, 40)
                        
                        Button {
                            currentCell = currentCell.next
                        } label: {
                            HStack {
                                Spacer()
                                
                                Text(currentCell.buttonText)
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
                    
                    VStack {
                        HStack {
                            Button {
                                currentCell = currentCell.prev
                            } label: {
                                Image(systemName: "chevron.left.2")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color("Font"))
                            }
                            .isHidden(currentCell.backButtonIsHidden)
                            .padding()
                            
                            Spacer()
                        }
                        
                        Spacer()
                    }
                }
            }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView { }
    }
}
