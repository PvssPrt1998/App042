import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @Environment(\.openURL) var openURL
    @EnvironmentObject var source: Source
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Settings")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 47, leading: 16, bottom: 8, trailing: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                proButton
                VStack(spacing: 32) {
                    contact
                    policy
                    changeAccountButton
                }
                .padding(16)
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    @ViewBuilder private var proButton: some View {
        if source.hasProSubscription {
            HStack(spacing: 8) {
                Image(systemName: "crown")
                    .font(.system(size: 20, weight: .regular))
                    .foregroundColor(.white)
                Text("PRO activated")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
            }
            .frame(height: 40)
            .padding(.horizontal, 16)
            .background(Color.cPrimary)
            .clipShape(.rect(cornerRadius: 4))
            .shadow(color: .cPrimary, radius: 16)
            .onTapGesture {
                withAnimation {
                    screen = .paywall1
                }
            }
            .frame(height: 72)
        } else {
            Button {
                withAnimation {
                    screen = .paywall1
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "crown")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                    Text("Buy PRO")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                }
                .frame(height: 40)
                .padding(.horizontal, 16)
                .background(Color.white.opacity(0.3))
                .clipShape(.rect(cornerRadius: 4))
                .frame(height: 72)
            }
        }
    }
    
    private var contact: some View {
        VStack(spacing: 0) {
//            Button {
//                
//            } label: {
//                HStack(spacing: 16) {
//                    Image(systemName: "envelope.fill")
//                        .font(.system(size: 16, weight: .medium))
//                        .foregroundColor(.white)
//                    
//                    HStack(spacing: 0) {
//                        Text("Contact us")
//                            .font(.system(size: 17, weight: .regular))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                        Image(systemName: "chevron.right")
//                            .font(.system(size: 16, weight: .medium))
//                            .foregroundColor(.white.opacity(0.3))
//                    }
//                    .frame(height: 54)
//                    .overlay(
//                        Rectangle()
//                            .fill(Color.white.opacity(0.15))
//                            .frame(height: 1)
//                        ,alignment: .bottom
//                    )
//                }
//            }
            
            Button {
                
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "square.and.arrow.up.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0) {
                        Text("Share the app")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(height: 54)
                    .overlay(
                        Rectangle()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 1)
                        ,alignment: .bottom
                    )
                }
            }
            
            Button {
                SKStoreReviewController.requestReviewInCurrentScene()
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "star.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0) {
                        Text("Rate the app")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(height: 54)
                    .overlay(
                        Rectangle()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 1)
                        ,alignment: .bottom
                    )
                }
            }
            
        }
    }
    
    private var policy: some View {
        VStack(spacing: 0) {
            Button {
                if let url = URL(string: "https://docs.google.com/document/d/1GppZuRQEzcaVnOMiI3kIQuGOpXWhFWEUz9yGKi7_sr4/edit?tab=t.0#heading=h.l97jy7i87fdb") {
                    openURL(url)
                }
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0) {
                        Text("Usage policy")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(height: 54)
                    .overlay(
                        Rectangle()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 1)
                        ,alignment: .bottom
                    )
                }
            }
            Button {
                if let url = URL(string: "https://docs.google.com/document/d/1HX_uw7owodhgF9653D8dhNwhbdNoGsQJhWuyNaaF7HA/edit?tab=t.0#heading=h.9k1agz8dd6mn") {
                    openURL(url)
                }
            } label: {
                HStack(spacing: 16) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    HStack(spacing: 0) {
                        Text("Privacy policy")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white.opacity(0.3))
                    }
                    .frame(height: 54)
                    .overlay(
                        Rectangle()
                            .fill(Color.white.opacity(0.15))
                            .frame(height: 1)
                        ,alignment: .bottom
                    )
                }
            }
        }
    }
    
    private var changeAccountButton: some View {
        Button {
            withAnimation {
                screen = .welcome
            }
        } label: {
            HStack(spacing: 16) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                HStack(spacing: 0) {
                    Text("Change account")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white.opacity(0.3))
                }
                .frame(height: 54)
                .overlay(
                    Rectangle()
                        .fill(Color.white.opacity(0.15))
                        .frame(height: 1)
                    ,alignment: .bottom
                )
            }
        }
    }
    
    func actionSheet() {
        guard let urlShare = URL(string: "https://docs.google.com/document/d/1HX_uw7owodhgF9653D8dhNwhbdNoGsQJhWuyNaaF7HA/edit?usp=sharing")  else { return }
        let activityVC = UIActivityViewController(activityItems: [urlShare], applicationActivities: nil)
        if #available(iOS 15.0, *) {
            UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?.rootViewController?
            .present(activityVC, animated: true, completion: nil)
        } else {
            UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
        }
    }
}

struct SettingsView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .main
    
    static var previews: some View {
        SettingsView(screen: $screen)
            .environmentObject(Source())
    }
}

extension SKStoreReviewController {
    public static func requestReviewInCurrentScene() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            DispatchQueue.main.async {
                requestReview(in: scene)
            }
        }
    }
}
