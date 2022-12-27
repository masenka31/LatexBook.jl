### TESTING THIS OUT
using Revise
using LatexBook
using BSON

nickname = "rovnovaha"
m = BSON.load("data/metadata/metadata_$(nickname).bson")
book = BookData(;m[:metadata]...)

separator = "***"

open("scene.tex", "w") do io
    write(io, b);
end;

s = open("data/file3.md") do file
    read(file, String)
end

using Book: process_file

files = readdir("data")
files = filter(x -> endswith(x, ".md"), files)
df = mapreduce(x -> process_file("data/$x"), vcat, files)
sort!(df, [:chapter_number, :scene_number])
separator = "***"

for (i, chapter) in enumerate(groupby(df, :chapter_number))
    scenes = chapter.scene_content
    if length(scenes) == 1
        write_chapter_file("chapter_$i", czech_speech(scenes[1]))
    else
        a = chapter.scene_content[1:end-1] .* ("\n\n\n" * separator * "\n\n\n")
        b = prod(a) * chapter.scene_content[end]
        write_chapter_file("chapter_$i", czech_speech(b))
    end
end

