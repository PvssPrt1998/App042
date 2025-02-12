import SwiftUI
import Combine

struct HomeView: View {
    
    @EnvironmentObject var source: Source
    @ObservedObject var imageLoader: ImageLoader
    @State var image: UIImage = UIImage()
    @State var filter: Filter = .week
    @Binding var screen: Screen
    
    init(avatarUrlString: String, screen: Binding<Screen>) {
        self._screen = screen
        imageLoader = ImageLoader(urlString: avatarUrlString)
    }
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            ScrollView(.vertical) {
                VStack(spacing: 0) {
                    account
                    filters
                    updateStat
                    audience
                    video
                }
                .padding(.bottom, 16)
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
                .shadow(color: source.hasProSubscription ? Color.cPrimary : Color.clear, radius: 16)
                .overlay(
                    Circle()
                        .stroke(Color.cPrimary, lineWidth: 4)
                )
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
    
    private var filters: some View {
        HStack(spacing: 8) {
            Text("Week")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(filter == .week ? .white : .white.opacity(0.1))
                .frame(height: 32)
                .padding(.horizontal, 16)
                .background(filter == .week ? Color.cPrimary : Color.white.opacity(0.1))
                .clipShape(.rect(cornerRadius: 4))
                .onTapGesture {
                    filter = .week
                }
            
            Text("Month")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(filter == .month ? .white : .white.opacity(0.1))
                .frame(height: 32)
                .padding(.horizontal, 16)
                .background(filter == .month ? Color.cPrimary : Color.white.opacity(0.1))
                .clipShape(.rect(cornerRadius: 4))
                .onTapGesture {
                    filter = .month
                }
            
            Text("Year")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(filter == .year ? .white : .white.opacity(0.1))
                .frame(height: 32)
                .padding(.horizontal, 16)
                .background(filter == .year ? Color.cPrimary : Color.white.opacity(0.1))
                .clipShape(.rect(cornerRadius: 4))
                .onTapGesture {
                    filter = .year
                }
            
            Text("All time")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(filter == .allTime ? .white : .white.opacity(0.1))
                .frame(height: 32)
                .padding(.horizontal, 16)
                .background(filter == .allTime ? Color.cPrimary : Color.white.opacity(0.1))
                .clipShape(.rect(cornerRadius: 4))
                .onTapGesture {
                    filter = .allTime
                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }
    
    private func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy HH:mm"//"yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    private var updateStat: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Update statistic")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                Text("Last update: " + (UserDefaults.standard.string(forKey: "RefreshDate") ?? "few hours ago"))
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Button {
                if let nickname = source.currentUser?.nickname {
                    source.getCurrentStatBy(nickname: nickname) { response in
                        UserDefaults.standard.set(dateToString(Date()), forKey: "RefreshDate")
                    } errorHandler: {
                        
                    }
                }
            } label: {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
            }
            
        }
        .padding(8)
        .background(Color.cPrimary)
        .clipShape(.rect(cornerRadius: 8))
        .padding(16)
    }
    
    private var audience: some View {
        VStack(spacing: 16) {
            Text("Audience")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            audienceStat
        }
        .padding(16)
    }
    
    private var followingSecond: Int {
        switch filter {
        case .week: source.weekCurrentUser?.following ?? 0
        case .month: source.monthCurrentUser?.following ?? 0
        case .year: source.yearCurrentUser?.following ?? 0
        case .allTime: source.allTimeCurrentUser?.following ?? 0
        }
    }
    
    private var followersSecond: Int {
        switch filter {
        case .week: source.weekCurrentUser?.followers ?? 0
        case .month: source.monthCurrentUser?.followers ?? 0
        case .year: source.yearCurrentUser?.followers ?? 0
        case .allTime: source.allTimeCurrentUser?.followers ?? 0
        }
    }
    
    private var viewsSecond: Int {
        switch filter {
        case .week: source.weekCurrentUser?.views ?? 0
        case .month: source.monthCurrentUser?.views ?? 0
        case .year: source.yearCurrentUser?.views ?? 0
        case .allTime: source.allTimeCurrentUser?.views ?? 0
        }
    }
    
    private var likesSecond: Int {
        switch filter {
        case .week: source.weekCurrentUser?.likes ?? 0
        case .month: source.monthCurrentUser?.likes ?? 0
        case .year: source.yearCurrentUser?.likes ?? 0
        case .allTime: source.allTimeCurrentUser?.likes ?? 0
        }
    }
    
    private var commentsSecond: Int {
        switch filter {
        case .week: source.weekCurrentUser?.comments ?? 0
        case .month: source.monthCurrentUser?.comments ?? 0
        case .year: source.yearCurrentUser?.comments ?? 0
        case .allTime: source.allTimeCurrentUser?.comments ?? 0
        }
    }
    
    private var sharesSecond: Int {
        switch filter {
        case .week: source.weekCurrentUser?.shares ?? 0
        case .month: source.monthCurrentUser?.shares ?? 0
        case .year: source.yearCurrentUser?.shares ?? 0
        case .allTime: source.allTimeCurrentUser?.shares ?? 0
        }
    }
    
    private var audienceStat: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Following")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Text("\(source.currentUser?.following ?? 0)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                    Text((followingSecond >= 0 ? "+" : "") + "\(followingSecond)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(followingSecond >= 0 ? .cBody : .cPrimary)
                }
            }
            .frame(height: 54)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                ,alignment: .bottom
            )
            HStack(spacing: 0) {
                Text("Followers")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Text("\(source.currentUser?.followers ?? 0)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                    Text((followersSecond >= 0 ? "+" : "") + "\(followersSecond)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(followersSecond >= 0 ? .cBody : .cPrimary)
                }
            }
            .frame(height: 54)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                ,alignment: .bottom
            )
//            HStack(spacing: 0) {
//                Text("Profile views")
//                    .font(.system(size: 17, weight: .regular))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                HStack(spacing: 16) {
//                    Text("468")
//                        .font(.system(size: 17, weight: .regular))
//                        .foregroundColor(.white)
//                    Text("+42")
//                        .font(.system(size: 17, weight: .regular))
//                        .foregroundColor(.cBody)
//                }
//            }
//            .frame(height: 54)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                ,alignment: .bottom
            )
        }
    }
    
    private var video: some View {
        VStack(spacing: 16) {
            Text("Video")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            videoStat
        }
        .padding(16)
    }
    
    private var videoStat: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Text("Views")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Text("\(source.currentUser?.views ?? 0)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                    Text((viewsSecond >= 0 ? "+" : "") + "\(viewsSecond)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(viewsSecond >= 0 ? .cBody : .cPrimary)
                }
            }
            .frame(height: 54)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                ,alignment: .bottom
            )
            HStack(spacing: 0) {
                Text("Likes")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Text("\(source.currentUser?.likes ?? 0)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                    Text((likesSecond >= 0 ? "+" : "") + "\(likesSecond)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(likesSecond >= 0 ? .cBody : .cPrimary)
                }
            }
            .frame(height: 54)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                ,alignment: .bottom
            )
            HStack(spacing: 0) {
                Text("Comments")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Text("\(source.currentUser?.comments ?? 0)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                    Text((commentsSecond >= 0 ? "+" : "") + "\(commentsSecond)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(commentsSecond >= 0 ? .cBody : .cPrimary)
                }
            }
            .frame(height: 54)
            .overlay(
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                ,alignment: .bottom
            )
            
            HStack(spacing: 0) {
                Text("Shares")
                    .font(.system(size: 17, weight: .regular))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 16) {
                    Text("\(source.currentUser?.shares ?? 0)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.white)
                    Text((sharesSecond >= 0 ? "+" : "") + "\(sharesSecond)")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(sharesSecond >= 0 ? .cBody : .cPrimary)
                }
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
    
    private var nickname: String {
        if let nickname = source.currentUser?.nickname {
            return "@" + nickname
        } else {
            return "Unable to load nickname"
        }
    }
}

struct HomeView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .main
    
    static var previews: some View {
        HomeView(avatarUrlString: "https://p16-sign-va.tiktokcdn.com/tos-maliva-avt-0068/625f878837f61af987825c64f74a12c7~c5_720x720.jpeg?lk3s=a5d48078&nonce=28602&refresh_token=af7546ccafc9f9ab43846b994e891bc3&x-expires=1739091600&x-signature=TyUR1Scg79Kr2PE9b06NZpO0Le8%3D&shp=a5d48078&shcp=81f88b70", screen: $screen)
            .environmentObject(Source())
    }
    
}
