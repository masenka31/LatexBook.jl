module LatexBook

using DrWatson
using BSON
using Dates

using DotEnv
DotEnv.load!()

include("main.jl")
include("init.jl")
include("parse.jl")
include("files.jl")

const obsidian_path = ENV["OBSIDIAN_PATH"]
const projects_path = ENV["PROJECTS_PATH"]

export init_project
export export_book
export obsidian_path, projects_path 

end
