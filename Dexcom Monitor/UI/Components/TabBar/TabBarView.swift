//
//  TabBarView.swift
//  Dexcom Monitor
//
//  Created by James on 27/12/2022.
//

import SwiftUI

struct TabBarView: View {
    @State private var isPresenting = false
    @State private var selectedTab: Tab = .home
    @State private var oldSelectedTab: Tab = .home
    
    private var tabs: [Tab] = [.home, .data, .add, .message, .profile]
    private var tabBackground: UIColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
        
            TabView(selection: $selectedTab) {
                DashboardView()
                    .ignoresSafeArea()
                    .tag(Tab.home)
                
                Color(.green)
                    .ignoresSafeArea()
                    .tag(Tab.data)
                
                Color(.clear)
                    .ignoresSafeArea()
                    .tag(Tab.add)
                
                Color(.gray)
                    .ignoresSafeArea()
                    .tag(Tab.message)
                
                Color(.systemPink)
                    .ignoresSafeArea()
                    .tag(Tab.profile)
            }
            .onChange(of: selectedTab) {
                if selectedTab == .add {
                    self.isPresenting = true
                    self.selectedTab = self.oldSelectedTab
                }
                else {
                    self.oldSelectedTab = $0
                }
            }
            .sheet(isPresented: $isPresenting, onDismiss: { self.selectedTab = self.oldSelectedTab}) {
                testSheet
            }
            
            // Custom tab bar
            HStack(spacing: 0) {
                ForEach(tabs, id: \.self) { tab in
                    Button(action: {
                        selectedTab = tab
                    }, label: {
                        tab.image
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20.0, height: 20.0)
                            .foregroundColor(selectedTab == tab ? .white : tab.color)
                            .padding(10)
                            .background(tab == .add ? .purple : .clear)
                            .cornerRadius(30)
                    })
                    .frame(width: 25.0, height: 30.0)
                    
                    if tab != tabs.last { Spacer() }
                }
            }
            .padding(.horizontal, 30)
            .padding(.vertical)
            .background(Color(tabBackground))
            .cornerRadius(30)
            .padding(.horizontal, 50)
            .padding(.vertical, 10)
        }
    }
    
    var testSheet : some View {
        VStack{
            Text("testing")
        }
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

enum Tab {
    case home
    case data
    case add
    case message
    case profile
    
    var image: Image {
        switch self {
            case .home: return Image(systemName: "house.fill")
            case .data: return Image(systemName: "chart.xyaxis.line")
            case .add: return Image(systemName: "plus")
            case .message: return Image(systemName: "bubble.left.fill")
            case .profile: return Image(systemName: "person.fill")
        }
    }
    
    var color: Color {
        switch self {
            case .add: return .white
            default: return .gray
        }
    }
}
