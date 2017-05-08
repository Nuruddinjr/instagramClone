//
//  Comment.swift
//  InstagramClone
//
//  Created by Nuruddin on 5/8/17.
//  Copyright © 2017 IUTlab. All rights reserved.
//


import Foundation
class Comment {
    var commentText: String?
    var uid: String?
}

extension Comment {
    static func transformComment(dict: [String: Any]) -> Comment {
        let comment = Comment()
        comment.commentText = dict["commentText"] as? String
        comment.uid = dict["uid"] as? String
        return comment
    }
}
