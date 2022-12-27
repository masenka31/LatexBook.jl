using DataFrames

# struct Scene
#     scene_number::Int
#     scene_separator::String
#     content
# end

# struct Chapter
#     chapter_name::String
#     chapter_number::Int
#     content
# end

boldface(s::String) = replace(s, r"\*\*(.*)\*\*" => s"\\textbf{\1}")
italics(s::String) = replace(s, r"([^*]{0,1})\*([^*]+)\*([^*])" => s"\1\\textit{\2}\3")
czech_speech(s::String) = replace(s, r"([^\"]{0,1})(\"([^\"]+)\")([^\"]{0,1})" => s"\1\\uv{\3}\4")

"""
    parse_file(lines)

Goes through frontmatter and content of the file to find out the metadata for the file,
and preparse the context of the text.
"""
function parse_file(lines)
    
    end_ix = findnext(x -> x == "---", lines, 2)

    dict = Dict()
    for line in lines[2:end_ix-1]
        if occursin("book", line)
            book = match(r"book: (.+)", line).captures[1]
            push!(dict, :book => String(book))
        elseif occursin("scene_number", line)
            scene_number = match(r"scene_number: (.+)", line).captures[1]
            if scene_number == "undefined"
                push!(dict, :scene_number => 999)    
            else
                push!(dict, :scene_number => parse(Int, scene_number))
            end
        elseif occursin("chapter_name", line)
            chapter_name = match(r"chapter_name: (.+)", line).captures[1]
            push!(dict, :chapter_name => String(chapter_name))
        elseif occursin("chapter_number", line)
            chapter_number = match(r"chapter_number: (.+)", line).captures[1]
            if chapter_number == "undefined"
                push!(dict, :chapter_number => 999)
            else    
                push!(dict, :chapter_number => parse(Int, chapter_number))
            end
        end
    end

    ff = findfirst(x -> occursin("Topics:", x), lines)
    isnothing(ff) ? start_ix = end_ix + 1 : start_ix = ff + 2
    _content = filter(x -> length(x) > 1, lines[start_ix:end])
    content = prod(_content .* "\n\n")
    content = boldface(content)
    content = italics(content)
    push!(dict, :scene_content => content)

    return dict
end

function write_chapter_file(chapter_name::String, content)
    open("$chapter_name.tex", "w") do io
        write(io, content);
    end;
end

function process_file(file)
    lines = readlines(file)
    dict = parse_file(lines)
    DataFrame(dict)
end
