import Foundation
import UIKit
import ApphudSDK

final class Source: ObservableObject {
    
    var hasProSubscription = false
    
    var productsApphud: Array<ApphudProduct> = []
    private var paywallID = "main"
    
    var currentUser: User?
    var weekCurrentUser: User?
    var monthCurrentUser: User?
    var yearCurrentUser: User?
    var allTimeCurrentUser: User?
    
    let apiKey = "0d326d61-d725-4c1c-89c4-c675877a3783"
    let urlString = "https://backend.infinityappworks.shop/api"
    
    var isAnalysing = false
    
    @MainActor func load(completion: @escaping (Bool) -> Void) {
        loadPaywalls { value in
            if self.hasActiveSubscription() {
                self.hasProSubscription = true
            }
            completion(value)
        }
    }
    
    @MainActor
    func startPurchase(product: ApphudProduct, escaping: @escaping(Bool)->Void) {
        let selectedProduct = product
        Apphud.purchase(selectedProduct) { result in
            if let error = result.error {
                debugPrint(error.localizedDescription)
                escaping(false)
            }
            debugPrint(result)
            if let subscription = result.subscription, subscription.isActive() {
                escaping(true)
            } else if let purchase = result.nonRenewingPurchase, purchase.isActive() {
                escaping(true)
            } else {
                if Apphud.hasActiveSubscription() {
                    escaping(true)
                }
            }
        }
    }
    
    @MainActor
    func restorePurchase(escaping: @escaping (Bool) -> Void) {
        print("restore")
        Apphud.restorePurchases { subscriptions, _, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                escaping(false)
            }
            if subscriptions?.first?.isActive() ?? false {
                escaping(true)
            }
            if Apphud.hasActiveSubscription() {
                escaping(true)
            }
        }
    }
    
    @MainActor
    func loadPaywalls(completion: @escaping (Bool) -> Void) {
        Apphud.paywallsDidLoadCallback { paywalls, arg in
            if let paywall = paywalls.first(where: {$0.identifier == self.paywallID}) {
                Apphud.paywallShown(paywall)
                let products = paywall.products
                self.productsApphud = products
                completion(products.count >= 2 ? true : false)
            }
        }
    }
    
    @MainActor
    func hasActiveSubscription() -> Bool {
        Apphud.hasActiveSubscription()
    }
    
    @MainActor
    func returnPrice(product: ApphudProduct) -> String {
        return product.skProduct?.price.stringValue ?? ""
    }
    
    @MainActor
    func returnPriceSign(product: ApphudProduct) -> String {
        return product.skProduct?.priceLocale.currencySymbol ?? ""
    }
    
    @MainActor
    func returnName(product: ApphudProduct) -> String {
        guard let subscriptionPeriod = product.skProduct?.subscriptionPeriod else { return "" }
        
        switch subscriptionPeriod.unit {
        case .day:
            return "Weekly"
        case .week:
            return "Weekly"
        case .month:
            return "Monthly"
        case .year:
            return "Yearly"
        @unknown default:
            return "Unknown"
        }
    }
    
    func statsForChart(completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        //week
        let weekDays = daysToMonday() - 1
        let monthDays = daysToFirstDayMonth()
        let yearDays = daysAmountToJan()
        statChartIncreaseBy(days: weekDays, filter: .week) {
            self.currentUser!.followersWeekArray.append(self.currentUser!.followers!)
            self.currentUser!.likesWeekArray.append(self.currentUser!.likes!)
            self.currentUser!.viewsWeekArray.append(self.currentUser!.views!)
            self.currentUser!.commentsWeekArray.append(self.currentUser!.comments!)
            self.currentUser!.sharesWeekArray.append(self.currentUser!.shares!)
            if let views = self.currentUser?.views {
                print("currentUser views \(views)")
                self.currentUser!.viewsWeekArray.append(views)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.statChartIncreaseBy(days: monthDays, filter: .month) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.statChartIncreaseBy(days: yearDays, filter: .year) {
                            completion()
                        } errorHandler: {
                            errorHandler()
                        }
                    }
                } errorHandler: {
                    errorHandler()
                }
            }
        } errorHandler: {
            errorHandler()
        }
    }
    
    func storeUserRequest(_ nickname: String, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        guard let url = URL(string: urlString + "/user") else { return }
        let deviceUUID = UIDevice.current.identifierForVendor?.uuidString ?? "DeviceID"
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "api-token")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = [
            "app_id": deviceUUID,
            "app_bundle": "string",
            "nickname": nickname
        ]
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
            errorHandler()
            return
        }
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                errorHandler()
                return
            }
            
            // ensure there is valid response code returned from this HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                print("Invalid Response received from the server")
                errorHandler()
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                errorHandler()
                print("nil Data received from the server")
                return
            }
            
            do {
                let storeUserResponse = try JSONDecoder().decode(UserResponse.self, from: responseData)
                completion()
            } catch let error {
                errorHandler()
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    func getUserRequest(_ nickname: String, completion: @escaping (UserResponse) -> Void, errorHandler: @escaping () -> Void) {
        guard let url = URL(string: urlString + "/user/" + nickname) else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "api-token")
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                errorHandler()
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                errorHandler()
                print("nil Data received from the server")
                return
            }
            
            do {
                let userResponse = try JSONDecoder().decode(UserResponse.self, from: responseData)
                if userResponse.detail != "Not Found", let id = userResponse.id, let nickname = userResponse.nickname, let avatarUrl = userResponse.avatar {
                    self.currentUser = User(id: id, nickname: nickname, avatarUrl: avatarUrl)
                }
                completion(userResponse)
            } catch let error {
                errorHandler()
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    func getCurrentStatBy(nickname: String, completion: @escaping (StatResponse) -> Void, errorHandler: @escaping () -> Void) {
        guard let url = URL(string: urlString + "/stats/" + nickname + "/current") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "api-token")
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                errorHandler()
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                errorHandler()
                print("nil Data received from the server")
                return
            }
            
            do {
                let statResponse = try JSONDecoder().decode(StatResponse.self, from: responseData)
                if statResponse.detail != "Not Found" || statResponse.userStats != nil,
                   let currentUser = statResponse.userStats,
                   let videoStat = statResponse.videoStats,
                   let createdAt = currentUser.createdAt,
                   let followers = currentUser.followers,
                   let following = currentUser.following,
                   let likes = currentUser.likes,
                   let diggs = currentUser.diggs
                {
                    self.currentUser?.createdAt = createdAt
                    self.currentUser?.followers = followers
                    self.currentUser?.following = following
                    self.currentUser?.likes = likes
                    self.currentUser?.diggs = diggs
                    
                    self.currentUser?.views = self.countViewsWithVideoStat(videoStat)
                    self.currentUser?.comments = self.countVideoCommentsWithVideoStat(videoStat)
                    self.currentUser?.shares = self.countVideoSharesWithVideoStat(videoStat)
                    DispatchQueue.main.async {
                        self.objectWillChange.send()
                    }
                    completion(statResponse)
                } else {
                    errorHandler()
                }
            } catch let error {
                errorHandler()
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    func countViewsWithVideoStat(_ videoStats: [VideoStat]) -> Int {
        return videoStats.map { stat in
            guard let views = stat.views else { return 0 }
            return views
        }.reduce(0, +)
    }
    
    func countVideoCommentsWithVideoStat(_ videoStats: [VideoStat]) -> Int {
        return videoStats.map { stat in
            guard let views = stat.comments else { return 0 }
            return views
        }.reduce(0, +)
    }
    
    func countVideoSharesWithVideoStat(_ videoStats: [VideoStat]) -> Int {
        return videoStats.map { stat in
            guard let views = stat.comments else { return 0 }
            return views
        }.reduce(0, +)
    }
    
    private func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy HH:mm"//"yyyy/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    func checkStoreCheckUserRequest(_ nickname: String, completion: @escaping (UserResponse) -> Void, errorHandler: @escaping () -> Void) {
        getUserRequest(nickname) { userResponse in
            UserDefaults.standard.set(self.dateToString(Date()), forKey: "RefreshDate")
            if userResponse.detail == "Not Found" || userResponse.id == nil {
                self.storeUserRequest(nickname) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
                        self.getUserRequest(nickname) { userResponse in
                            completion(userResponse)
                        } errorHandler: {
                            errorHandler()
                        }
                    }
                } errorHandler: {
                    errorHandler()
                }
            } else {
                completion(userResponse)
            }
        } errorHandler: {
            errorHandler()
        }
    }
    
    func loadStat(by nickname: String, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        checkStoreCheckUserRequest(nickname) { userResponse in
            self.getCurrentStatBy(nickname: nickname) { statResponse in
                self.statIncreaseBy(days: self.daysToMonday(), filter: .week) {
                    self.statIncreaseBy(days: self.daysToFirstDayMonth(), filter: .month) {
                        print(self.monthCurrentUser?.followers)
                        self.statIncreaseBy(days: self.daysAmountToJan(), filter: .year) {
                            self.statIncreaseBy(days: 9999, filter: .allTime) {
                                completion()
                            } errorHandler: {
                                errorHandler()
                            }
                        } errorHandler: {
                            errorHandler()
                        }
                    } errorHandler: {
                        errorHandler()
                    }
                } errorHandler: {
                    errorHandler()
                }
            } errorHandler: {
                errorHandler()
            }
        } errorHandler: {
            errorHandler()
        }
    }
    
    func statChartIncreaseBy(days: Int, filter: Filter, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        var daysI = days
        guard let currentUser = currentUser else {
            errorHandler()
            return
        }
        guard let url = URL(string: urlString + "/stats/" + currentUser.nickname + "/increase?days=\(days)") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "api-token")
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                errorHandler()
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                errorHandler()
                print("nil Data received from the server")
                return
            }
            
            do {
                let statResponse = try JSONDecoder().decode(StatResponse.self, from: responseData)
                var isSet = false
                if filter == .week {
                    daysI -= 1
                    isSet = self.weekChartFill(statResponse)
                    if isSet {
                        if daysI >= 1 {
                            self.statChartIncreaseBy(days: daysI, filter: .week) {
                                completion()
                            } errorHandler: {
                                errorHandler()
                            }
                        } else {
                            completion()
                        }
                    } else {
                        errorHandler()
                    }
                } else if filter == .month {
                    while daysI % 5 != 0 {
                        daysI -= 1
                    }
                    daysI -= 5
                    if daysI == 0 {
                        daysI += 1
                    }
                    
                    isSet = self.monthChartFill(statResponse)
                    if isSet {
                        if daysI >= 1 {
                            self.statChartIncreaseBy(days: daysI, filter: .month) {
                                completion()
                            } errorHandler: {
                                errorHandler()
                            }
                        } else {
                            completion()
                        }
                    } else {
                        errorHandler()
                    }
                } else if filter == .year {
                    daysI -= 30
                    print(daysI)
                    isSet = self.yearChartFill(statResponse)
                    if isSet {
                        if daysI >= 1 {
                            self.statChartIncreaseBy(days: daysI, filter: .year) {
                                completion()
                            } errorHandler: {
                                errorHandler()
                            }
                        } else {
                            completion()
                        }
                    } else {
                        errorHandler()
                    }
                } else if filter == .allTime {
                    daysI -= 1
                    
                    isSet = self.allTimeChartFill(statResponse)
                    if isSet {
                        if daysI >= 1 {
                            self.statChartIncreaseBy(days: daysI, filter: .allTime) {
                                completion()
                            } errorHandler: {
                                errorHandler()
                            }
                        } else {
                            completion()
                        }
                    } else {
                        errorHandler()
                    }
                } else {
                    completion()
                }

            } catch let error {
                errorHandler()
                print("error: ", error)
            }
        }
        task.resume()
    }
    
    func weekChartFill(_ statResponse: StatResponse) -> Bool {
        if statResponse.detail != "Not Found" || statResponse.userStats != nil,
           let currentUser = statResponse.userStats,
           self.currentUser != nil,
           let followers = currentUser.followers,
           let likes = currentUser.likes
        {
            self.currentUser!.followersWeekArray.append((self.currentUser?.followers)! - followers)
            self.currentUser!.likesWeekArray.append((self.currentUser?.likes)! - likes)
            if let video = statResponse.videoStats
            {
                self.currentUser!.viewsWeekArray.append((self.currentUser?.views)! - countViewsWithVideoStat(video))
                self.currentUser!.commentsWeekArray.append((self.currentUser?.comments)! - countVideoCommentsWithVideoStat(video))
                self.currentUser!.sharesWeekArray.append((self.currentUser?.shares)! - countVideoSharesWithVideoStat(video))
            }
            return true
        } else {
            return false
        }
    }
    func monthChartFill(_ statResponse: StatResponse) -> Bool {
        if statResponse.detail != "Not Found" || statResponse.userStats != nil,
           let currentUser = statResponse.userStats,
           self.currentUser != nil,
           let followers = currentUser.followers,
           let likes = currentUser.likes
        {
            self.currentUser!.followersMonthArray.append((self.currentUser?.followers)! - followers)
            self.currentUser!.likesMonthArray.append((self.currentUser?.likes)! - likes)
            if let video = statResponse.videoStats
            {
                self.currentUser!.viewsMonthArray.append((self.currentUser?.views)! - countViewsWithVideoStat(video))
                self.currentUser!.commentsMonthArray.append((self.currentUser?.comments)! - countVideoCommentsWithVideoStat(video))
                self.currentUser!.sharesMonthArray.append((self.currentUser?.shares)! - countVideoSharesWithVideoStat(video))
            }
            return true
        } else {
            return false
        }
    }
    func yearChartFill(_ statResponse: StatResponse) -> Bool {
        if statResponse.detail != "Not Found" || statResponse.userStats != nil,
           let currentUser = statResponse.userStats,
           self.currentUser != nil,
           let followers = currentUser.followers,
           let likes = currentUser.likes
        {
            self.currentUser!.followersYearArray.append((self.currentUser?.followers)! - followers)
            self.currentUser!.likesYearArray.append((self.currentUser?.likes)! - likes)
            if let video = statResponse.videoStats
            {
                self.currentUser!.viewsYearArray.append((self.currentUser?.views)! - countViewsWithVideoStat(video))
                self.currentUser!.commentsYearArray.append((self.currentUser?.comments)! - countVideoCommentsWithVideoStat(video))
                self.currentUser!.sharesYearArray.append((self.currentUser?.shares)! - countVideoSharesWithVideoStat(video))
            }
            return true
        } else {
            return false
        }
    }
    func allTimeChartFill(_ statResponse: StatResponse) -> Bool {
        if statResponse.detail != "Not Found" || statResponse.userStats != nil,
           let currentUser = statResponse.userStats,
           self.currentUser != nil,
           let followers = currentUser.followers
        {
            self.currentUser!.followersAllTimeArray.append((self.currentUser?.followers)! - followers)
            return true
        } else {
            return false
        }
    }
    
    func statIncreaseBy(days: Int, filter: Filter, completion: @escaping () -> Void, errorHandler: @escaping () -> Void) {
        guard let currentUser = currentUser else {
            errorHandler()
            return
        }
        guard let url = URL(string: urlString + "/stats/" + currentUser.nickname + "/increase?days=\(days)") else { return }
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        request.addValue(apiKey, forHTTPHeaderField: "api-token")
        
        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Post Request Error: \(error.localizedDescription)")
                errorHandler()
                return
            }
            
            // ensure there is data returned
            guard let responseData = data else {
                errorHandler()
                print("nil Data received from the server")
                return
            }
            
            do {
                let statResponse = try JSONDecoder().decode(StatResponse.self, from: responseData)
                
                switch filter {
                case .week: self.setWeekUser(statResponse) ? completion() : errorHandler()
                case .month: self.setMonthUser(statResponse) ? completion() : errorHandler()
                case .year: self.setYearUser(statResponse) ? completion() : errorHandler()
                case .allTime: self.setAllTimeUser(statResponse) ? completion() : errorHandler()
                }
            } catch let error {
                errorHandler()
                print("error: ", error)
            }
        }
        task.resume()
    }

    func cutStrDate() -> String? {
        guard let currentUser = currentUser, let dateStr = currentUser.createdAt else { return nil}
        let yearStr = dateStr[0] + dateStr[1] + dateStr[2] + dateStr[3]
        let monthStr = dateStr[5] + dateStr[6]
        let dayStr = dateStr[8] + dateStr[9]
        let str = yearStr + "-" + monthStr + "-" + dayStr
        return str
    }
    
    func daysToMonday() -> Int {
        switch Date().weekday() {
        case 1: return 7
        case 2: return 1
        case 3: return 2
        case 4: return 3
        case 5: return 4
        case 6: return 5
        case 7: return 6
        default: return 1
        }
    }
    
    func monthAmountToJan() -> Int {
        return Date().month()
    }
    
    func daysAmountToJan() -> Int {
        guard let date = dateFromString("2025-01-01") else { return 0 }
        return Date().interval(ofComponent: .day, fromDate: date)
    }
    
    func daysAfterCreated(_ strDate: String) -> Int {
        guard let date = dateFromString(strDate) else { return 0 }
        return Date().interval(ofComponent: .day, fromDate: date)
    }
    
    func daysToFirstDayMonth() -> Int {
        return Date().day()
    }
    
    func dateFromString(_ str: String) -> Date? {
        let startDate = str
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let formatedStartDate = dateFormatter.date(from: startDate)
        return formatedStartDate
    }
    
    func setWeekUser(_ statResponse: StatResponse) -> Bool {
        if statResponse.detail != "Not Found" || statResponse.userStats != nil,
           let currentUser = statResponse.userStats,
           let videoStat = statResponse.videoStats,
           let createdAt = currentUser.createdAt,
           let followers = currentUser.followers,
           let following = currentUser.following,
           let likes = currentUser.likes,
           let diggs = currentUser.diggs
        {
            self.weekCurrentUser = self.currentUser
            self.weekCurrentUser?.createdAt = createdAt
            self.weekCurrentUser?.followers = followers
            self.weekCurrentUser?.following = following
            self.weekCurrentUser?.likes = likes
            self.weekCurrentUser?.diggs = diggs
            
            self.weekCurrentUser?.views = self.countViewsWithVideoStat(videoStat)
            self.weekCurrentUser?.comments = self.countVideoCommentsWithVideoStat(videoStat)
            self.weekCurrentUser?.shares = self.countVideoSharesWithVideoStat(videoStat)
            return true
        } else {
            return false
        }
    }
    
    func setMonthUser(_ statResponse: StatResponse) -> Bool {
        print("Month")
        if statResponse.detail != "Not Found" || statResponse.userStats != nil,
           let currentUser = statResponse.userStats,
           let videoStat = statResponse.videoStats,
           let createdAt = currentUser.createdAt,
           let followers = currentUser.followers,
           let following = currentUser.following,
           let likes = currentUser.likes,
           let diggs = currentUser.diggs
        {
            self.monthCurrentUser = self.currentUser
            self.monthCurrentUser?.createdAt = createdAt
            self.monthCurrentUser?.followers = followers
            self.monthCurrentUser?.following = following
            self.monthCurrentUser?.likes = likes
            self.monthCurrentUser?.diggs = diggs
            
            self.monthCurrentUser?.views = self.countViewsWithVideoStat(videoStat)
            self.monthCurrentUser?.comments = self.countVideoCommentsWithVideoStat(videoStat)
            self.monthCurrentUser?.shares = self.countVideoSharesWithVideoStat(videoStat)
            return true
        } else {
            return false
        }
    }
    
    func setAllTimeUser(_ statResponse: StatResponse) -> Bool {
        if statResponse.detail != "Not Found" || statResponse.userStats != nil,
           let currentUser = statResponse.userStats,
           let videoStat = statResponse.videoStats,
           let createdAt = currentUser.createdAt,
           let followers = currentUser.followers,
           let following = currentUser.following,
           let likes = currentUser.likes,
           let diggs = currentUser.diggs
        {
            self.allTimeCurrentUser = self.currentUser
            self.allTimeCurrentUser?.createdAt = createdAt
            self.allTimeCurrentUser?.followers = followers
            self.allTimeCurrentUser?.following = following
            self.allTimeCurrentUser?.likes = likes
            self.allTimeCurrentUser?.diggs = diggs
            
            self.allTimeCurrentUser?.views = self.countViewsWithVideoStat(videoStat)
            self.allTimeCurrentUser?.comments = self.countVideoCommentsWithVideoStat(videoStat)
            self.allTimeCurrentUser?.shares = self.countVideoSharesWithVideoStat(videoStat)
            return true
        } else {
            return false
        }
    }
    
    func setYearUser(_ statResponse: StatResponse) -> Bool {
        if statResponse.detail != "Not Found" || statResponse.userStats != nil,
           let currentUser = statResponse.userStats,
           let videoStat = statResponse.videoStats,
           let createdAt = currentUser.createdAt,
           let followers = currentUser.followers,
           let following = currentUser.following,
           let likes = currentUser.likes,
           let diggs = currentUser.diggs
        {
            self.yearCurrentUser = self.currentUser
            self.yearCurrentUser?.createdAt = createdAt
            self.yearCurrentUser?.followers = followers
            self.yearCurrentUser?.following = following
            self.yearCurrentUser?.likes = likes
            self.yearCurrentUser?.diggs = diggs
            
            self.yearCurrentUser?.views = self.countViewsWithVideoStat(videoStat)
            self.yearCurrentUser?.comments = self.countVideoCommentsWithVideoStat(videoStat)
            self.yearCurrentUser?.shares = self.countVideoSharesWithVideoStat(videoStat)
            return true
        } else {
            return false
        }
    }
}

extension Date {
    func weekday() -> Int {
        let timeZone = TimeZone(abbreviation: "UTC")
        let component =  Calendar.current.dateComponents(in: timeZone!, from: self)
        return component.weekday!
    }
    
    func month() -> Int {
        let timeZone = TimeZone(abbreviation: "UTC")
        let component =  Calendar.current.dateComponents(in: timeZone!, from: self)
        return component.month!
    }
    
    func day() -> Int {
        let timeZone = TimeZone(abbreviation: "UTC")
        let component =  Calendar.current.dateComponents(in: timeZone!, from: self)
        return component.day!
    }
    
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {

        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}

enum Weekday: Int {
    case sunday = 1
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
