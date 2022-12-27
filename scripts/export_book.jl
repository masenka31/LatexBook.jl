using Pkg
Pkg.activate(pwd())

if length(ARGS) == 0
    @error "Nickname of the project needs to be provided."
end

using LatexBook

nickname = ARGS[1]
export_book(nickname)