"""
Here we have functions to read the Obsidian folders, read through the frontmatter
and filter out only the relevant files.
"""

function get_markdown_files(folder::String)
    first_read = readdir(folder, join=true)
    _files = _recurrent_readdir.(first_read)
    files = _unpack_files(_files)
    md_files = filter(x -> endswith(x, ".md"), files)
    return md_files
end

function _recurrent_readdir(x)
    if !isfile(x)
        y = readdir(x, join=true)
        map(a -> _recurrent_readdir(a), y)
    else
        return x
    end
end

function _unpack_files(vec)
    t = typeof.(vec)
    unq = unique(t)
    l = length(unq)
    while l > 1 || unq[1] != String
        vec = vcat(vec...)
        t = typeof.(vec)
        unq = unique(t)
        l = length(unq)
    end
    return vec
end

function filter_frontmatter(files, book_title)
    relevant_files = []
    for f in files
        lines = readlines(f)
        end_ix = findnext(x -> x == "---", lines, 2)
        if isnothing(end_ix)
            continue
        end
        frontmatter = prod(lines[2:end_ix-1] .* "\n")
        if occursin("book:", frontmatter) && occursin("chapter:", frontmatter) && !occursin("template", f)
            book = match(r"book: (.+)", frontmatter).captures[1]
            if book == book_title
                push!(relevant_files, f)
            end
        end
    end
    return relevant_files
end

function get_scenes(book::BookData, srcfolder::String=obsidian_path)
    title = book.title
    files = get_markdown_files(srcfolder)
    scenes = filter_frontmatter(files, title)
    @info "Total number of scenes loaded: $(length(scenes))."
    return scenes
end

function process_scenes_text_to_dataframe(scenes)
    df = mapreduce(x -> process_file(x), vcat, scenes)
    sort!(df, [:chapter_number, :scene_number])
    return df
end

function write_chapters(book::BookData, nickname::String, scenes_df::DataFrame)

    separator = """

    \\vspace{1cm}

    \\begin{center}
    ***
    \\end{center}

    \\vspace{1cm}

    """

    project_path = "latex/project_$(nickname)"
    chapter_files = String[]

    for (i, chapter) in enumerate(groupby(scenes_df, :chapter_number))
        scenes = chapter.scene_content
        if length(scenes) == 1
            write_chapter_file(
                joinpath(project_path, "chapters", "chapter_$i"),
                czech_speech("\\chapter{}\n\n" * scenes[1])
            )
            push!(chapter_files, "chapters/chapter_$i")
        else
            a = chapter.scene_content[1:end-1] .* separator
            b = "\\chapter{}\n\n" * prod(a) * chapter.scene_content[end]
            write_chapter_file(
                joinpath(project_path, "chapters", "chapter_$i"),
                czech_speech(b)
            )
            push!(chapter_files, "chapters/chapter_$i")
        end
    end
    append!(book.chapter_files, chapter_files)
    render_main(book, "latex/project_$(nickname)")
end

function export_book(nickname::String)
    m = load_metadata(nickname)
    @info "Export for book $(m.title) started."
    book = BookData(; m...)
    scenes = get_scenes(book)
    df = process_scenes_text_to_dataframe(scenes)

    write_chapters(book, nickname, df)
    @info "Export finished."
end