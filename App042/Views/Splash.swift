import SwiftUI

struct Splash: View {
    
    @EnvironmentObject var source: Source
    @State var value: Double = 0
    @Binding var screen: Screen
    @AppStorage("firstLaunch") var firstLaunch = true
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()

            Image("appiconSplash")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
            
            RoundedRectangle(cornerRadius: 4)
                .fill(Color.white.opacity(0.1))
                .frame(width: 128, height: 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white)
                        .frame(width: max(4, value * 128))
                    ,alignment: .leading
                )
                .padding(.top, UIScreen.main.bounds.height * 0.75)
        }
        .onAppear {
            stroke()
            source.load { loaded in
                if loaded {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        if firstLaunch {
                            firstLaunch = false
                            screen = .onboarding
                        } else {
                            screen = .welcome
                        }
                        
                    }
                }
            }
        }
    }
    
    
    private func stroke() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if value < 1 {
                withAnimation {
                    value += 0.05
                }
                stroke()
            }
        }
    }
}

struct Splash_Preview: PreviewProvider {
    
    @State static var splash: Screen = .splash
    
    static var previews: some View {
        Splash(screen: $splash)
            .environmentObject(Source())
    }
}
