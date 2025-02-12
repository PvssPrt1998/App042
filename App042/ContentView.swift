import SwiftUI

struct ContentView: View {
    
    @State var screen: Screen = .splash
    @EnvironmentObject var source: Source
    
    var body: some View {
        switch screen {
        case .splash:
            Splash(screen: $screen)
        case .onboarding:
            Onboarding(screen: $screen)
        case .paywall:
            PaywallView(screen: $screen)
        case .welcome:
            WelcomeView(screen: $screen)
        case .main:
            Tab(screen: $screen)
        case .welcomeAccount:
            WelcomeProfileView(avatarUrlString: source.currentUser!.avatarUrl!, screen: $screen)
        case .welcomeAccountAnalyse:
            WelcomeAnalyseView(screen: $screen)
        case .paywall1:
            Paywall1(screen: $screen)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Source())
}
