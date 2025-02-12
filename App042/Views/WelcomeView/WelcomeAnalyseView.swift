import SwiftUI

struct WelcomeAnalyseView: View {
    
    @EnvironmentObject var source: Source
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            VStack(spacing: 0) {
                titleAndImage
                
                Button {
                    withAnimation {
                        screen = .welcomeAccount
                    }
                } label: {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.1))
                }
                .padding(16)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
        .onAppear {
            if !source.isAnalysing {
                source.isAnalysing = true
                source.statsForChart {
                    withAnimation {
                        screen = .main
                    }
                } errorHandler: {
                    print("Error handler analyse")
                    withAnimation {
                        screen = .main
                    }
                }
            }
        }
    }
    
    private var titleAndImage: some View {
        VStack(spacing: 16) {
            Text("Please wait. the account is\nbeing analyzed…")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Image("WelcomeAnalyseImage")
                .resizable()
                .scaledToFit()
            
            HStack(spacing: 8) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                Text("Account analysis...")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
    }
}

struct WelcomeAnalyseView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .welcomeAccountAnalyse
    
    static var previews: some View {
        WelcomeAnalyseView(screen: $screen)
            .environmentObject(Source())
    }
    
}
