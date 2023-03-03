#!/bin/tclsh

proc get_item {item_id} {
    exec curl -s "https://hacker-news.firebaseio.com/v0/item/$item_id.json?print=pretty"
}

proc get_comment_ids {item_id} {
    exec jq ".kids\[\]" << [get_item $item_id]
}

proc get_comment {comment_id} {
    exec jq "\[$comment_id, .text\]" << [get_item $comment_id]
}

proc get_comments {comment_ids} {
    set comments [dict create]
    set csv ""

    foreach comment_id $comment_ids {
        dict set comments $comment_id [get_comment $comment_id]
    }

    foreach comment [dict keys $comments] {
        set comment_csv [exec jq -r "@csv" << [dict get $comments $comment]]
        set csv [string trim "$csv
$comment_csv"]
    }

    return $csv
}

proc run {} {
    set whoshiring [open "whoshiring.csv" "w"]
    set comment_ids [get_comment_ids 34983767]
    puts $whoshiring [get_comments $comment_ids]
    close $whoshiring
}

run
