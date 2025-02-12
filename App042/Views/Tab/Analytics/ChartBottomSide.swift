import SwiftUI

struct ChartBottomSide: View {
    
    let filter: Filter
    
    var body: some View {
        switch filter {
        case .week:
            weekFilter
        case .month:
            monthFilter
        case .year:
            yearFilter
        case .allTime:
            allTimeFilter
        }
    }
    
    private var allTimeFilter: some View {
        HStack(spacing: 0) {
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Mon")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Tue")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Wed")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Thu")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Fri")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Sat")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Sun")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var yearFilter: some View {
        HStack(spacing: 0) {
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Jan")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Feb")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Mar")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Apr")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("May")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Jun")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Jul")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Aug")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Sep")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Oct")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Nov")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Dec")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var monthFilter: some View {
        HStack(spacing: 0) {
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("01")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("05")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("10")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("15")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("20")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("25")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("30")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private var weekFilter: some View {
        HStack(spacing: 0) {
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Mon")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(width: 26)
            Spacer()
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Tue")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(width: 26)
            Spacer()
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Wed")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(width: 26)
            Spacer()
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Thu")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(width: 26)
            Spacer()
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Fri")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(width: 26)
            Spacer()
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Sat")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(width: 26)
            Spacer()
            VStack(spacing: 5) {
                Rectangle()
                    .fill(Color.white.opacity(0.1))
                    .frame(width: 1, height: 10)
                Text("Sun")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(.white.opacity(0.3))
            }
            .frame(width: 26)
        }
    }
}

#Preview {
    ChartBottomSide(filter: .week)
        .padding(20)
        .background(Color.bgMain)
}
