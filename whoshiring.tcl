#!/bin/tclsh

namespace eval ::whoshiring {
    # Export commands
    namespace export create_csv create_sqlite_from_csv create_html_from_sqlite
    namespace ensemble create
    variable whoshiring_id 35424807
}

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

proc ::whoshiring::create_sqlite_from_csv {} {
    exec sqlite3 whoshiring.sqlite "create table if not exists whoshiring (item_id, ad)" ".mode csv" ".import whoshiring.csv whoshiring" ".exit"
}

proc ::whoshiring::create_html_from_sqlite {} {
    set html [open "whoshiring.html" "w"]
    puts $html [exec sqlite3 whoshiring.sqlite "select '<li><label>' || item_id || '<input type=\"checkbox\" /></label><p>' || ad || '</p></li>' from whoshiring"]
    close $html
}

proc ::whoshiring::create_csv {} {
    variable whoshiring_id
    set whoshiring [open "whoshiring.csv" "w"]
    set comment_ids [get_comment_ids $whoshiring_id]
    puts $whoshiring [get_comments $comment_ids]
    close $whoshiring
}

proc run {} {
    whoshiring create_csv
    whoshiring create_sqlite_from_csv
    whoshiring create_html_from_sqlite
}

# Main method (or load w/ `source whoshiring.tcl` in tclsh)
if {[info exists argv0] && [file tail [info script]] eq [file tail $argv0]} {
    run
}
