import SwiftUI
import StoreKit

struct Onboarding: View {
    @State var selection = 0
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            TabView(selection: $selection) {
                onboardingImage("OnboardingImage1")
                    .tag(0)
                    .gesture(DragGesture())
                onboardingImage("OnboardingImage2")
                    .tag(1)
                    .gesture(DragGesture())
                onboardingImage("OnboardingImage3")
                    .tag(2)
                    .gesture(DragGesture())
                onboardingImage("OnboardingImage4")
                    .tag(3)
                    .gesture(DragGesture())
                onboardingImage("OnboardingImage5")
                    .tag(4)
                    .gesture(DragGesture())
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .gesture(DragGesture())
            .overlay(
                VStack(spacing: 0) {
                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 1)
                    VStack(spacing: 0) {
                        VStack(spacing: 16) {
                            Text(titleForSelection)
                                .font(.system(size: 28, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                            Text(descriptionForSelection)
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxHeight: .infinity)
                        
                        VStack(spacing: 8) {
                            Button {
                                if selection < 4 {
                                    if selection == 2 {
                                        registerForNotification()
                                    }
                                    if selection == 3 {
                                        SKStoreReviewController.requestReviewInCurrentScene()
                                    }
                                    withAnimation {
                                        selection += 1
                                    }
                                } else {
                                    withAnimation {
                                        screen = .paywall
                                    }
                                }
                            } label: {
                                Text("Next")
                                    .font(.system(size: 17, weight: .regular))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 54)
                                    .background(Color.cPrimary)
                            }
                            indicators
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 32, trailing: 16))
                    .frame(height: 250)
                }
                
                ,alignment: .bottom
            )
            .ignoresSafeArea()
        }
    }
    
    private func onboardingImage(_ title: String) -> some View {
        Image(title)
            .resizable()
            .scaledToFit()
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 250 - safeAreaInsets.bottom, trailing: 16))
            .frame(maxHeight: .infinity)
    }
    
    private var indicators: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(selection == 0 ? Color.white : Color.white.opacity(0.1))
                .frame(height: selection == 0 ? 12 : 8)
            Circle()
                .fill(selection == 1 ? Color.white : Color.white.opacity(0.1))
                .frame(height: selection == 1 ? 12 : 8)
            Circle()
                .fill(selection == 2 ? Color.white : Color.white.opacity(0.1))
                .frame(height: selection == 2 ? 12 : 8)
            Circle()
                .fill(selection == 3 ? Color.white : Color.white.opacity(0.1))
                .frame(height: selection == 3 ? 12 : 8)
            Circle()
                .fill(selection == 4 ? Color.white : Color.white.opacity(0.1))
                .frame(height: selection == 4 ? 12 : 8)
        }
        .frame(height: 12)
    }
    
    private var titleForSelection: String {
        switch selection {
        case 0: return "Know Your Stats!"
        case 1: return "Track Your Growth"
        case 2: return "Deep Dive into Analytics"
        case 3: return "Stay Updated!"
        default: return "Help us grow up"
        }
    }
    
    private var descriptionForSelection: String {
        switch selection {
        case 0: return "Track followers, likes, views, and more — all in one place."
        case 1: return "See how your followers, likes, and views change over time with easy-to-read trends"
        case 2: return "Analyze your audience’s behavior, track video engagement, and uncover key insights."
        case 3: return "Get real-time notifications about your account’s growth."
        default: return "Rate us on the AppStore"
        }
    }
    
    func registerForNotification() {
            //For device token and push notifications.
            UIApplication.shared.registerForRemoteNotifications()
            
            let center : UNUserNotificationCenter = UNUserNotificationCenter.current()
            //        center.delegate = self
            
            center.requestAuthorization(options: [.sound , .alert , .badge ], completionHandler: { (granted, error) in
                if ((error != nil)) { UIApplication.shared.registerForRemoteNotifications() }
                else {
                    
                }
            })
        }
}

struct Onboarding_Preview: PreviewProvider {
    
    @State static var screen: Screen = .onboarding
    
    static var previews: some View {
        Onboarding(screen: $screen)
            .environmentObject(Source())
    }
    
}
