"""
BookData

The structure contains all metadata for generating the Book in LaTeX.

Fields:
- author
- title
- subtitle
- publisher
- year
- isbn
- chapter_files

Empty constructor adds "Author", "Title", and current year. All other fields are `nothing`.
If a field is `nothing`, the book renders without these commands.

The field `chapter_files` contains an array of paths to chapters already rendered in LaTeX.
"""
struct BookData
    author
    title
    subtitle
    publisher
    year
    isbn
    chapter_files
end

StringOrNothing = Union{String, Nothing}

function BookData(;
    author::String="Author",
    title::String="Title",
    subtitle::StringOrNothing=nothing,
    publisher::StringOrNothing=nothing,
    year::String=string(year(now())),
    isbn::StringOrNothing=nothing
)

    return BookData(author, title, subtitle, publisher, year, isbn, Vector{String}(undef, 0))
end

function BookData(
    chapters::AbstractArray;
    author::String="Author",
    title::String="Title",
    subtitle::StringOrNothing=nothing,
    publisher::StringOrNothing=nothing,
    year::String=string(year(now())),
    isbn::StringOrNothing=nothing)

    return BookData(author, title, subtitle, publisher, year, isbn, chapters)
end

function BookData(
    chapter_path::String;
    author::String="Author",
    title::String="Title",
    subtitle::StringOrNothing=nothing,
    publisher::StringOrNothing=nothing,
    year::String=string(year(now())),
    isbn::StringOrNothing=nothing)

    chapters = readdir(chapter_path)
    return BookData(author, title, subtitle, publisher, year, isbn, chapters)
end


function bookmetadata(book::BookData)
    return [
        book.author,
        book.title,
        book.subtitle,
        book.publisher,
        book.year,
        book.isbn
    ]
end

function metadata_commands(book::BookData)
    commands = [
        "\\newcommand{\\authorname}{$(book.author)}",
        "\\newcommand{\\booktitle}{$(book.title)}",
        "\\newcommand{\\subtitle}{$(book.subtitle)}",
        "\\newcommand{\\publisher}{$(book.publisher)}",
        "\\newcommand{\\editionyear}{$(book.year)}",
        "\\newcommand{\\isbn}{$(book.isbn)}"
    ]
    b = isnothing.(bookmetadata(book))
    commands[b] = "% " .* commands[b]
    commands .* "\n"
end

chapter_commands(book::BookData) = "\\input{" .* book.chapter_files .* "}\n"

function render_main(book, filepath::String="latex/project")
    commands = metadata_commands(book)
    chapters = chapter_commands(book)

    main_text = """
    \\documentclass[11pt,openany]{book}      % paper size is in preamble.sty

    %\\usepackage[utf8x]{inputenc}
    \\usepackage[T1]{fontenc}
    \\usepackage[czech]{babel}

    %%%%%%%%%% BOOK INFORMATION %%%%%%%%%%
    $(commands...)
    \\title{\\booktitle}
    \\author{\\authorname}

    \\usepackage{misc/options}

    \\begin{document}
    \\frontmatter
    \\input{frontmatter/titlepage}
    \\input{frontmatter/copyrightpage}
    %\\input{frontmatter/preface}
    %\\input{frontmatter/tocpage}

    \\mainmatter
    \\pagestyle{fancy}

    %%%%%%%%%% CHAPTER INPUT %%%%%%%%%%
    $(chapters...)

    \\end{document}
    """

    open("$filepath/main.tex", "w") do io
        write(io, main_text);
    end;
end

# TODO:
"""
Figure out a way to work with backups, Git versioning etc.

Idea: There is a core `project` folders, where the current version of the project is.
This is overwritten every time a new version is processed with this package.

Also, each time, a backup is made, consisting of only the chapter files. The folder with
backup is named by the current date probably (I doubt I will render multiple times during
one day.)

Also, the rendering and everything needs to work for multiple books!
"""