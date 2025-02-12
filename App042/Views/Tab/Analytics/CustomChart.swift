import SwiftUI
import _SpriteKit_SwiftUI

struct CustomChart: View {
    
    let array: Array<Int>
    let filter: Filter
    let lowerPadding: CGFloat
    let topPadding: CGFloat
    
    var body: some View {
        SpriteView(scene: chartScene)
            .frame(width: 260, height: 91 - maxMinEqual + 2)
            .padding(.top, 8 + (array.max() != array.min() ? topPadding : 0) - 2)
//            .padding(.bottom, lowerPadding)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.white.opacity(0.03))
            .background(Color.bgMain)
    }
    
    private var maxMinEqual: CGFloat {
        if array.max() != array.min() {
            return lowerPadding + topPadding
        } else {
            return 20
        }
    }
    
    var chartScene: ChartScene {
        let scene = ChartScene(array: array, size: CGSize(width: 260, height: 91 - maxMinEqual + 2), divs: divsByFilter)
        scene.scaleMode = .aspectFill
        return scene
    }
    
    private var divsByFilter: Int {
        switch filter {
        case .week:
            return 7
        case .month:
            return 7
        case .year:
            return 12
        case .allTime:
            return 7
        }
    }
}

#Preview {
    CustomChart(array: [10, 30, 150, 100], filter: .week, lowerPadding: 10, topPadding: 10)
}
