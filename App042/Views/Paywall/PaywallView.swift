import SwiftUI

struct PaywallView: View {
    
    @EnvironmentObject var source: Source
    @Environment(\.openURL) var openURL
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @State var isYearly = false
    
    @Binding var screen: Screen
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            LinearGradient(stops: [
                .init(color: .gradientColor1, location: 0.1),
                .init(color: .black, location: 0.6),
            ], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            Image("PaywallImage")
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 358)
                .padding(.horizontal, 16)
                .ignoresSafeArea()
                .frame(maxHeight: .infinity, alignment: .top)
            content
                .padding(EdgeInsets(top: 16, leading: 16, bottom: 48 - safeAreaInsets.bottom, trailing: 16))
            Button {
                withAnimation {
                    screen = .welcome
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
                    .frame(width: 32, height: 32)
            }
            .padding(.trailing, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }
    
    private var content: some View {
        VStack(spacing: 16) {
            Text("Analyze your TikTok")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            Text("Get advanced statistics with your PRO account. Keep an eye on the charts and invent a strategy for your promotion.")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.bottom, 16)
            
            paywallSelection
            
            paywallButtons
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    private var paywallSelection: some View {
        VStack(spacing: 8) {
            paywallYearly
            paywallWeekly
        }
    }
    
    private var paywallYearly: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading , spacing: 0) {
                Text(source.returnName(product: source.productsApphud[0]))
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .trailing , spacing: 0) {
                Text(source.returnPriceSign(product: source.productsApphud[0]) + source.returnPrice(product: source.productsApphud[0]))
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)
                
                Text("per year")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .frame(height: 96)
        .background(Color.white.opacity(0.1))
        .clipShape(.rect(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isYearly ? Color.gradientColor1 : Color.clear, lineWidth: 1)
        )
        .onTapGesture {
            isYearly = true
        }
        .frame(height: 115)
        .overlay(
            Text("Save 84%")
                .font(.system(size: 11, weight: .regular))
                .foregroundColor(.black)
                .frame(width: 66, height: 21)
                .background(Color.white)
                .clipShape(.rect(cornerRadius: 4))
                .padding(.horizontal, 16)
            
            ,alignment: .topLeading
        )
    }
    
    private var paywallWeekly: some View {
        HStack(spacing: 8) {
            Text(source.returnName(product: source.productsApphud[1]))
                .font(.system(size: 22, weight: .regular))
                .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .trailing , spacing: 0) {
                Text(source.returnPriceSign(product: source.productsApphud[1]) + source.returnPrice(product: source.productsApphud[1]))
                    .font(.system(size: 22, weight: .regular))
                    .foregroundColor(.white)
                
                Text("per week")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
        }
        .padding(16)
        .frame(height: 96)
        .background(Color.white.opacity(0.1))
        .clipShape(.rect(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(!isYearly ? Color.gradientColor1 : Color.clear, lineWidth: 1)
        )
        .onTapGesture {
            isYearly = false
        }
    }
    
    private var paywallButtons: some View {
        VStack(spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "checkmark.shield.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                Text("Cancel anytime")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
            
            Button {
                
                source.startPurchase(product: isYearly ? source.productsApphud[0] : source.productsApphud[1]) { bool in
                    if bool {
                        print("Subscription purchased")
                        source.hasProSubscription = true
                        withAnimation {
                            screen = .welcome
                        }
                    } else {
                        withAnimation {
                            screen = .welcome
                        }
                    }
                }
            } label: {
                Text("Continue")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.cPrimary)
            }
            
            Button {
                source.restorePurchase { bool in
                    if bool {
                        source.hasProSubscription = false
                    }
                }
            } label: {
                Text("Restore purchase")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            
            HStack(spacing: 16) {
                Button {
                    if let url = URL(string: "https://docs.google.com/document/d/1GppZuRQEzcaVnOMiI3kIQuGOpXWhFWEUz9yGKi7_sr4/edit?tab=t.0#heading=h.l97jy7i87fdb") {
                        openURL(url)
                    }
                } label: {
                    Text("Terms of use")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.3))
                }
                
                Button {
                    if let url = URL(string: "https://docs.google.com/document/d/1HX_uw7owodhgF9653D8dhNwhbdNoGsQJhWuyNaaF7HA/edit?tab=t.0#heading=h.9k1agz8dd6mn") {
                        openURL(url)
                    }
                } label: {
                    Text("Privacy policy")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.3))
                }
            }
        }
    }
}

struct PaywallView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .paywall
    
    static var previews: some View {
        PaywallView(screen: $screen)
            .environmentObject(Source())
    }
}
