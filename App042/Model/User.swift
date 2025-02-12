import Foundation

struct User {
    var id: Int
    var nickname: String
    var avatarUrl: String?
    var createdAt: String?
    var followers: Int?
    var following: Int?
    var likes: Int?
    var diggs: Int?
    
    var views: Int?
    var videoLikes: Int?
    var comments: Int?
    var shares: Int?
    
    var followingWeekArray: Array<Int> = []
    var followersWeekArray: Array<Int> = []
    var likesWeekArray: Array<Int> = []
    var viewsWeekArray: Array<Int> = []
    var commentsWeekArray: Array<Int> = []
    var sharesWeekArray: Array<Int> = []
    
    var followersMonthArray: Array<Int> = []
    var followingMonthArray: Array<Int> = []
    var likesMonthArray: Array<Int> = []
    var viewsMonthArray: Array<Int> = []
    var commentsMonthArray: Array<Int> = []
    var sharesMonthArray: Array<Int> = []
    
    var followingYearArray: Array<Int> = []
    var followersYearArray: Array<Int> = []
    var likesYearArray: Array<Int> = []
    var viewsYearArray: Array<Int> = []
    var commentsYearArray: Array<Int> = []
    var sharesYearArray: Array<Int> = []
    
    var followersAllTimeArray: Array<Int> = []
}

struct Week {
    var mon: Int?
    var tu: Int?
    var wed: Int?
    var thu: Int?
    var fri: Int?
    var sat: Int?
    var sun: Int?
}
