function prepare_metadata_and_save(;nickname, author, title, subtitle=nothing, publisher=nothing, isbn=nothing)
    # creates and saves metadata for your book
    metadata = (
        author=author,
        title=title,
        subtitle=subtitle,
        publisher=publisher,
        isbn=isbn
    )
    safesave(datadir("metadata/$(nickname).bson"), Dict(:metadata => metadata))
    @info "Metadata saved with nickname `$nickname`."

    # creates the latex directory in your book based on the initial data
    cp(datadir("project_template"), joinpath(projects_path, "project_$nickname"))
    @info "Project folder generated at `$(joinpath(projects_path, "project_$nickname"))`."

    # generates the main.tex file based on the metadata provided
    book = BookData(;metadata...)
    render_main(book, joinpath(projects_path, "project_$nickname"))
    @info "File `main.tex` generated."
end

function init_project_interactive()
    println("What is the name of the author?")
    author = readline()
    println("What is the title of the book?")
    title = readline()

    subtitle = yes_or_no("Does the book have a subtitle?", if_yes_question="What is the subtitle of the book?")
    publisher = yes_or_no("Does the book have a publisher?", if_yes_question="What is the publisher of the book?")
    isbn = yes_or_no("Does the book have ISBN?", if_yes_question="What is the ISBN of the book?")

    println("Give a nickname for your book - it is best to have a single word lwoercase nickname, because this will serve as a /key/ to all generation etc.")
    nickname = readline()

    prepare_metadata_and_save(;nickname=nickname, author=author, title=title, subtitle=subtitle, publisher=publisher, isbn=isbn)
end

function init_project(;interactive=true, kwargs...)
    if interactive
        init_project_interactive()
    else
        prepare_metadata_and_save(;kwargs...)
    end
end

function yes_or_no(question; if_yes_question, if_no_question=nothing)
    println(question * " [y/n]")
    answer = readline()
    if answer == "y"
        println(if_yes_question)
        result = readline()
    elseif answer == "n"
        if !isnothing(if_no_question)
            println(if_no_question)
            result = realine()
        else
            result = nothing
        end
    else
        @warn "Please, answer only 'y' or 'n'."
        result = yes_or_no(question, if_yes_question=if_yes_question, if_no_question=if_no_question)
    end
    return result
end