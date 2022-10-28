//
//  MockData.swift
//  FlowMenu
//
//  Created by Bing Bing on 2022/10/28.
//

import UIKit

private let CONTENT = """
    I'm here just to
    ⊂_ヽ
    　 ＼＼ show my beautiful
    　　 ＼(°ʖ°)
    　　　 >　⌒ヽ
    　　　/ 　 へ＼
    　　 /　　/　＼＼ 💎badge
    　　 ﾚ　ノ　　 ヽ_つ
    　　/　/
    　 /　/|
    　(　(ヽ
    　|　|、＼
    　| 丿 ＼ ⌒)
    　| |　　) /
    ノ )　　Lﾉ
    (_／
"""

struct MockData {
    var tintColor: UIColor
    
    var title: String
    var time: String
    var content: String
    var subtitle: String
    var body1: String?
    var body2: String?
    var body3: String?
    
    static var mocks: [MockData] = [
        MockData(tintColor: .systemPurple,
                 title: "WORK & TRAVEL AROUND THE WORLD",
                 time: "Today, 3:15 PM",
                 content: CONTENT,
                 subtitle: "Instructional",
                 body1: "Rolla"),
        MockData(tintColor: .systemBlue,
                 title: "Geology 101 Report",
                 time: "Yesterday, 6:36 PM",
                 content: CONTENT,
                 subtitle: "Essay",
                 body1: "John"),
        MockData(tintColor: .systemCyan,
                 title: "Easy Decorating",
                 time: "Monday, 10:00 PM",
                 content: CONTENT,
                 subtitle: "Contemporary Report",
                 body1: "Bing"),
        MockData(tintColor: .systemOrange,
                 title: "Academic Report Cover Page.",
                 time: "Tuesday, 7:30 AM",
                 content: CONTENT,
                 subtitle: "Academic Report",
                 body1: "Mercy"),
        MockData(tintColor: .systemRed,
                 title: "LOREM IPSUM.",
                 time: "Friday, 12:30 PM",
                 content: CONTENT,
                 subtitle: "Professional Report.",
                 body1: "Anna"),
        MockData(tintColor: .systemGray,
                 title: "A History of LightHouses.",
                 time: "Thursday, 4:16 PM",
                 content: CONTENT,
                 subtitle: "School Report",
                 body1: "Dva"),
        MockData(tintColor: .systemMint,
                 title: "Memories of a Traveler",
                 time: "Yesterday, 1:12 PM",
                 content: CONTENT,
                 subtitle: "Personal Novel",
                 body1: "Jack"),
        MockData(tintColor: .systemPink,
                 title: "A SHATTER IN THE DARK.",
                 time: "Yesterday, 3:18 PM",
                 content: CONTENT,
                 subtitle: "Edgy Novel",
                 body1: "Baptis"),
        MockData(tintColor: .systemBrown,
                 title: "THREE TALES",
                 time: "Saturday, 5:30 PM",
                 content: CONTENT,
                 subtitle: "Simple Novel",
                 body1: "Sigma"),
        MockData(tintColor: .systemYellow,
                 title: "STORIES OF THE NIGHT SKY",
                 time: "Sunday, 2:10 PM",
                 content: CONTENT,
                 subtitle: "Modern Novel",
                 body1: "King"),
        MockData(tintColor: .systemGreen,
                 title: "The Seasons of Paris",
                 time: "Sunday, 10:20 PM",
                 content: CONTENT,
                 subtitle: "Tranditional Novel",
                 body1: "Road"),
    ]
}
