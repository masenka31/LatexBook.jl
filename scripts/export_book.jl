using Pkg
# Pkg.activate(pwd())
Pkg.activate("/Users/masenka31/Documents/julia_projects/LatexBook.jl/")

if length(ARGS) == 0
    @error "Nickname of the project needs to be provided."
end

using LatexBook

nickname = ARGS[1]
export_book(nickname)