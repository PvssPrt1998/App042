import SwiftUI

struct WelcomeView: View {
    
    @EnvironmentObject var source: Source
    
    @State var text = ""
    @State var isLoading = false
    
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            content
        }
        .onAppear {
            source.isAnalysing = false
        }
    }
    
    private var content: some View {
        VStack(spacing: 0) {
            upperView
            usernameBlock
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    private var upperView: some View {
        VStack(spacing: 16) {
            Text("Welcome to Tik Stat Helper")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Image("WelcomeImage")
                .resizable()
                .scaledToFit()
                .frame(height: 358)
        }
        .padding(16)
    }
    
    private var usernameBlock: some View {
        VStack(spacing: 16) {
            VStack(spacing: 8) {
                Text("Enter your username")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 0) {
                    Text("@")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                    TextField("", text: $text)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .overlay(
                            Text(text == "" ? "Placeholder" : "")
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white.opacity(0.3))
                                .allowsHitTesting(false)
                            ,alignment: .leading
                        )
                }
                .padding(16)
                .frame(height: 54)
                .background(Color.white.opacity(0.1))
            }
            
            Button {
                isLoading = true
                source.loadStat(by: text) {
                    if source.currentUser?.avatarUrl != nil {
                        withAnimation {
                            screen = .welcomeAccount
                        }
                    } else {
                        text = ""
                        isLoading = false
                    }
                } errorHandler: {
                    text = ""
                    isLoading = false
                }
            } label: {
                buttonContent
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.cPrimary)
            }
            .disabled(text == "" || isLoading)
            .opacity(text == "" ? 0.5 : 1)
        }
        .padding(16)
    }
    
    @ViewBuilder var buttonContent: some View {
        if isLoading {
            HStack(spacing: 8) {
                Text("Loading")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
            }
        } else {
            Text("Continue")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
        }
    }
}

struct WelcomeView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .paywall
    
    static var previews: some View {
        WelcomeView(screen: $screen)
            .environmentObject(Source())
    }
}
