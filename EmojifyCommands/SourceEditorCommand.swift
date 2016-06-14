//
//  SourceEditorCommand.swift
//  EmojifyCommands
//
//  Created by Bhargav Gurlanka on 6/15/16.
//  Copyright © 2016 Bhargav Gurlanka. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    let emojiMap = [
        "love" : "💖",
        "happy": "🎉",
        "graduation": "🎓"
    ]
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: (NSError?) -> Void ) -> Void {
        guard let selection = invocation.buffer.selections.firstObject as? XCSourceTextRange else {
            completionHandler(NSError(domain: "Emojify", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid Selection"]))
            return
        }
        
        for lineNumber in selection.start.line ... selection.end.line {
            guard let line = invocation.buffer.lines[lineNumber] as? NSString else {
                continue
            }
            
            let i: Int, j: Int
            
            if lineNumber == selection.start.line {
                i = selection.start.column
                j = line.length - 1
            } else if lineNumber == selection.end.line {
                i = 0
                j = selection.end.column
            } else {
                i = 0
                j = line.length - 1
            }
            
            let range = NSRange(location: i, length: j - i)
            var modificationPart = line.substring(with: range)
            
            for (word, emoji) in emojiMap {
                modificationPart = modificationPart.replacingOccurrences(of: word, with: emoji)
            }
            
            invocation.buffer.lines.replaceObject(at: lineNumber, with: line.replacingCharacters(in: range, with: modificationPart))
        }
        
        completionHandler(nil)
    }
}
