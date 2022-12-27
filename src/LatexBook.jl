module LatexBook

using DrWatson
using BSON
using Dates

include("main.jl")
include("init.jl")
include("parse.jl")
include("files.jl")

export init_project
export export_book

const obsidian_path = "/Users/masenka31/Library/Mobile Documents/iCloud~md~obsidian/Documents/ObsidianNotes/"
const projects_path = "/Users/masenka31/Library/Mobile Documents/com~apple~CloudDocs/Books.jl/projects"

export obsidian_path, projects_path 

end
