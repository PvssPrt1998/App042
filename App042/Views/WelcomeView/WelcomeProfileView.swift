import SwiftUI
import Combine

struct WelcomeProfileView: View {
    
    @EnvironmentObject var source: Source
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    @Binding var screen: Screen
    
    init(avatarUrlString: String, screen: Binding<Screen>) {
        self._screen = screen
        imageLoader = ImageLoader(urlString: avatarUrlString)
    }
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            VStack(spacing: 0) {
                account
                confirmation
            }
        }
    }
    
    
    private var account: some View {
        VStack(spacing: 16) {
            accountPhoto
            accountStat
        }
        .padding(16)
    }
    
    private var accountPhoto: some View {
        VStack(spacing: 8) {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: 128, height: 128)
                .clipped()
                .clipShape(.circle)
                .onReceive(imageLoader.didChange) { data in
                    self.image = UIImage(data: data) ?? UIImage()
                }
            Text(nickname)
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
        }
    }
    
    private var accountStat: some View {
        HStack(spacing: 0) {
            VStack(spacing: 4) {
                Text("\(source.currentUser?.following ?? 0)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text("Following")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 4) {
                Text("\(source.currentUser?.followers ?? 0)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text("Followers")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 4) {
                Text("\(source.currentUser?.likes ?? 0)")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                Text("Likes")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var confirmation: some View {
        VStack(spacing: 8) {
            Text("Is this the right account?")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack(spacing: 8) {
                Button {
                    withAnimation {
                        screen = .welcome
                    }
                } label: {
                    Text("No")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.white.opacity(0.1))
                }
                Button {
                    withAnimation {
                        screen = .welcomeAccountAnalyse
                    }
                } label: {
                    Text("Yes")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Color.cPrimary)
                }
            }
            
        }
        .padding(16)
    }
    
    private var nickname: String {
        if let nickname = source.currentUser?.nickname {
            return "@" + nickname
        } else {
            return "Unable to load nickname"
        }
    }
}

struct WelcomeProfileView_Preview: PreviewProvider {
    @State static var screen: Screen = .welcomeAccount
    
    static var previews: some View {
        WelcomeProfileView(avatarUrlString: "https://p16-sign-sg.tiktokcdn.com/aweme/720x720/tos-alisg-avt-0068/9db397e7ad8a41f4d0553a0fd6694f97.jpeg?lk3s=a5d48078&nonce=35553&refresh_token=ee401ed30d50afe15c28540da09e6eb6&x-expires=1739091600&x-signature=yB9FwT050vUh%2BCfKaqvMoQP%2FMlI%3D&shp=a5d48078&shcp=81f88b70", screen: $screen)
            .environmentObject(Source())
    }
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, self != nil else { return }
            DispatchQueue.main.async { [weak self] in
                self?.data = data
            }
        }
        task.resume()
    }
}
