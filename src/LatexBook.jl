module LatexBook

using DrWatson
using BSON
using Dates

include("main.jl")
include("init.jl")
include("parse.jl")
include("files.jl")

export init_project
export BookData

const obsidian_path = folder = "/Users/masenka31/Library/Mobile Documents/iCloud~md~obsidian/Documents/ObsidianNotes/"
export obsidian_path

end
