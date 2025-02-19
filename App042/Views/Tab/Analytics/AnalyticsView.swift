import SwiftUI

struct AnalyticsView: View {
    
    @EnvironmentObject var source: Source
    @Binding var screen: Screen
    @State var filter: Filter = .week
    
    var body: some View {
        ZStack {
            Color.bgMain.ignoresSafeArea()
            
            VStack(spacing: 0) {
                Text("Analytics")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 47, leading: 16, bottom: 8, trailing: 16))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Rectangle()
                    .fill(Color.white.opacity(0.15))
                    .frame(height: 1)
                
                if !source.hasProSubscription {
                    buyOffer
                }
                filters
                ScrollView(.vertical) {
                    charts
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
    private func lowerPadding(min: Int, max: Int) -> CGFloat {
        print("min max \(min) - \(max)")
        let minRounded = min.roundToLowest
        let maxRounded = max.roundToGreatest
        let dif = min - minRounded
        if dif <= 0 { return 0 }
        let yStep = 91 / CGFloat(maxRounded - minRounded)
        return yStep * CGFloat(dif)
    }
    
    private func topPadding(min: Int, max: Int) -> CGFloat {
        print("upper padding \(min) - \(max)")
        let minRounded = min.roundToLowest
        let maxRounded = max.roundToGreatest
        let dif = maxRounded - max
        if dif >= 0 { return 0 }
        let yStep = 91 / CGFloat(maxRounded - minRounded)
        return yStep * CGFloat(dif)
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
//            
//            Text("All time")
//                .font(.system(size: 12, weight: .semibold))
//                .foregroundColor(filter == .allTime ? .white : .white.opacity(0.1))
//                .frame(height: 32)
//                .padding(.horizontal, 16)
//                .background(filter == .allTime ? Color.cPrimary : Color.white.opacity(0.1))
//                .clipShape(.rect(cornerRadius: 4))
//                .onTapGesture {
//                    filter = .allTime
//                }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
    }
    
    private var buyOffer: some View {
        VStack(spacing: 16) {
            Text("Analytics is available with a PRO version")
                .font(.system(size: 17, weight: .regular))
                .foregroundColor(.white)
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
        .padding(16)
    }
    
    @ViewBuilder private var charts: some View {
        switch filter {
        case .week:
            weekCharts
        case .month:
            monthCharts
        case .year:
            yearCharts
        case .allTime:
            EmptyView()
        }
    }
    
    private var yearCharts: some View {
        VStack(spacing: 16) {
            chart(title: "Followers", min: source.currentUser?.followersYearArray.min() ?? source.currentUser?.followersYearArray.first ?? 0, max: source.currentUser?.followersYearArray.max() ?? source.currentUser?.followersYearArray.first ?? 0, array: source.currentUser?.followersYearArray ?? [])
            chart(title: "Likes", min: source.currentUser?.likesYearArray.min() ?? source.currentUser?.likesYearArray.first ?? 0, max: source.currentUser?.likesYearArray.max() ?? source.currentUser?.likesYearArray.first ?? 0, array: source.currentUser?.likesYearArray ?? [])
            chart(title: "Likes", min: source.currentUser?.likesYearArray.min() ?? source.currentUser?.likesYearArray.first ?? 0, max: source.currentUser?.likesYearArray.max() ?? source.currentUser?.likesYearArray.first ?? 0, array: source.currentUser?.likesYearArray ?? [])
            chart(title: "Views", min: source.currentUser?.viewsYearArray.min() ?? source.currentUser?.viewsYearArray.first ?? 0, max: source.currentUser?.viewsYearArray.max() ?? source.currentUser?.viewsYearArray.first ?? 0, array: source.currentUser?.viewsYearArray ?? [])//
            chart(title: "Shares", min: source.currentUser?.sharesYearArray.min() ?? source.currentUser?.sharesYearArray.first ?? 0, max: source.currentUser?.likesYearArray.max() ?? source.currentUser?.sharesYearArray.first ?? 0, array: source.currentUser?.sharesYearArray ?? [])//
        }
        .padding(16)
    }
    
    private var weekCharts: some View {
        VStack(spacing: 16) {
            chart(title: "Followers", min: source.currentUser?.followersWeekArray.min() ?? source.currentUser?.followersWeekArray.first ?? 0, max: source.currentUser?.followersWeekArray.max() ?? source.currentUser?.followersWeekArray.first ?? 0, array: source.currentUser?.followersWeekArray ?? [])
            chart(title: "Likes", min: source.currentUser?.likesWeekArray.min() ?? source.currentUser?.likesWeekArray.first ?? 0, max: source.currentUser?.likesWeekArray.max() ?? source.currentUser?.likesWeekArray.first ?? 0, array: source.currentUser?.likesWeekArray ?? [])
                .onAppear {
                    print("views \(source.currentUser?.viewsWeekArray)")
                }
            if source.currentUser?.views != nil {
                chart(title: "Views", min: source.currentUser?.viewsWeekArray.min() ?? source.currentUser?.viewsWeekArray.first ?? 0, max: source.currentUser?.viewsWeekArray.max() ?? source.currentUser?.viewsWeekArray.first ?? 0, array: source.currentUser?.viewsWeekArray ?? [])//
            }
            if source.currentUser?.comments != nil {
                chart(title: "Comments", min: source.currentUser?.commentsWeekArray.min() ?? source.currentUser?.commentsWeekArray.first ?? 0, max: source.currentUser?.commentsWeekArray.max() ?? source.currentUser?.commentsWeekArray.first ?? 0, array: source.currentUser?.commentsWeekArray ?? [])
            }
            if source.currentUser?.shares != nil {
                chart(title: "Shares", min: source.currentUser?.sharesWeekArray.min() ?? source.currentUser?.sharesWeekArray.first ?? 0, max: source.currentUser?.likesWeekArray.max() ?? source.currentUser?.sharesWeekArray.first ?? 0, array: source.currentUser?.sharesWeekArray ?? [])//
            }
        }
        .padding(16)
    }
    
    private var monthCharts: some View {
        VStack(spacing: 16) {
            chart(title: "Followers", min: source.currentUser?.followersMonthArray.min() ?? source.currentUser?.followersMonthArray.first ?? 0, max: source.currentUser?.followersMonthArray.max() ?? source.currentUser?.followersMonthArray.first ?? 0, array: source.currentUser?.followersMonthArray ?? [])
            chart(title: "Likes", min: source.currentUser?.likesWeekArray.min() ?? source.currentUser?.likesMonthArray.first ?? 0, max: source.currentUser?.likesMonthArray.max() ?? source.currentUser?.likesMonthArray.first ?? 0, array: source.currentUser?.likesMonthArray ?? [])
            chart(title: "Likes", min: source.currentUser?.likesMonthArray.min() ?? source.currentUser?.likesMonthArray.first ?? 0, max: source.currentUser?.likesMonthArray.max() ?? source.currentUser?.likesMonthArray.first ?? 0, array: source.currentUser?.likesMonthArray ?? [])
            chart(title: "Views", min: source.currentUser?.viewsMonthArray.min() ?? source.currentUser?.viewsMonthArray.first ?? 0, max: source.currentUser?.viewsMonthArray.max() ?? source.currentUser?.viewsMonthArray.first ?? 0, array: source.currentUser?.viewsMonthArray ?? [])//
            chart(title: "Shares", min: source.currentUser?.sharesMonthArray.min() ?? source.currentUser?.sharesMonthArray.first ?? 0, max: source.currentUser?.sharesMonthArray.max() ?? source.currentUser?.sharesMonthArray.first ?? 0, array: source.currentUser?.sharesMonthArray ?? [])//
        }
        .padding(16)
    }
    
    private var xOffsetByFilter: CGFloat {
        switch filter {
        case .week:
            return 31.77
        case .month:
            return 31.77
        case .year:
            return 20.4
        case .allTime:
            return 31.77
        }
    }
    
    private func chart(title: String, min: Int, max: Int, array: Array<Int>) -> some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 0) {
                chartLeftSide(min: min, max: max)
                VStack(spacing: 0) {
                    CustomChart(array: array, filter: filter,
                                lowerPadding: lowerPadding(min: min, max: max),
                                topPadding: topPadding(min: min, max: max)
                    )
                    chartBottomSide
                }
            }
            .frame(width: 326, height: 140)
            .optionalBlur(source.hasProSubscription ? false : true)
        }
        .padding(16)
        .background(Color.white.opacity(0.03))
        .clipShape(.rect(cornerRadius: 8))
        .onAppear {
            print("chart min max \(min) - \(max)")
        }
    }
    
    private var chartBottomSide: some View {
        VStack(spacing: 0) {
            Rectangle()
                 .fill(Color.white.opacity(0.1))
                 .frame(height: 1)
            
            ChartBottomSide(filter: filter)
        }
    }
    
    private func chartStep(min: Int, max: Int) -> Int {
        print("chart step minmax \(min) - \(max)")
        return (max.roundToGreatest - min.roundToLowest) / 5
    }
    
    private func chartLeftSide(min: Int, max: Int) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .trailing, spacing: 0) {
                HStack(spacing: 5) {
                    Text(max.roundToGreatest.makeShortInt)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.3))
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 12, height: 1)
                }
                .frame(height: 16)
                Spacer()
                HStack(spacing: 5) {
                    Text("\((min.roundToLowest + chartStep(min: min, max: max) * 3).makeShortInt)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.3))
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 12, height: 1)
                }
                .frame(height: 16)
                .hidden()
                Spacer()
                HStack(spacing: 5) {
                    Text("\((min.roundToLowest + chartStep(min: min, max: max) * 2).makeShortInt)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.3))
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 12, height: 1)
                }
                .frame(height: 16)
                .hidden()
                Spacer()
                HStack(spacing: 5) {
                    Text("\((min.roundToLowest + chartStep(min: min, max: max)).makeShortInt)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.3))
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 12, height: 1)
                }
                .frame(height: 16)
                .hidden()
                Spacer()
                HStack(spacing: 5) {
                    Text("\(min.roundToLowest.makeShortInt)")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundColor(.white.opacity(0.3))
                    Rectangle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 12, height: 1)
                }
            }
            .padding(.bottom, 10)
            
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 1)
        }
        .padding(.bottom, 28)
        .frame(height: 140)
        .onAppear {
            print("chart leftSide onAppear \(min) - \(max)")
        }
    }
}

struct AnalyticsView_Preview: PreviewProvider {
    
    @State static var screen: Screen = .main
    
    static var previews: some View {
        AnalyticsView(screen: $screen)
            .environmentObject(Source())
    }
}

extension View {
    @ViewBuilder func optionalBlur(_ isBlur: Bool) -> some View {
        if isBlur {
            self
                .blur(radius: 16)
                .overlay(
                    Image(systemName: "lock.fill")
                        .font(.system(size: 24, weight: .regular))
                        .foregroundColor(.white)
                )
        } else {
            self
        }
    }
}

