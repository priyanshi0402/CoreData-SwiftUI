//
//  SplashScreenView.swift
//  CoreData-SwiftUI
//
//  Created by SARVADHI on 21/09/23.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.1
    @State private var textOpacity: Double = 0
    @EnvironmentObject private var appRootManager: AppRootManager
    
    var body: some View {
        VStack {
            Image(systemName: "sparkles")
                .font(.system(size: 100 * logoScale))
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 10, x: 0, y: 5)
                .scaleEffect(logoScale)
            Text("Your App Name")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .offset(y: 50)
                .opacity(textOpacity)
            
        }
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        .background(Color.black)
        .ignoresSafeArea()
        
        .onAppear() {
            withAnimation(.easeInOut(duration: 1.5)) {
                logoScale = 1.0
                let statesData = CoreDataHelper.shared.fetchData(type: States.self, entityName: "States")
                if statesData.count == 0 {
                    let country = currentCountry
                    Task {
                        do {
                            let response = try await APIManager.shared.fetchStateData(from: "https://www.universal-tutorial.com/api/states/\(country)")
                            APIManager.shared.storeStatesInCoreData(data: response)
                            print(response)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                withAnimation(.spring()) {
                                    appRootManager.currentRoot = .home
                                }
                            }
                        } catch {
                            print(error)
                        }
                        
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation(.spring()) {
                            appRootManager.currentRoot = .home
                        }
                    }
                    print(statesData)
                }                
            }
            withAnimation(.easeIn(duration: 1.0).delay(0.5)) {
                textOpacity = 1.0 // Final opacity value
            }
        }
        
    }
}

var currentCountry: String {
    if let countryCode = Locale.current.regionCode {
        let locale = Locale(identifier: "en_US")
        return locale.localizedString(forRegionCode: countryCode) ?? "Unknown"
    } else {
        return ""
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}
