# LatexBook.jl

This is a very primitive package to create a Latex book structure from Markdown files.

The package is inspired by the usage of Obsidian. In Obsidian, each file is a note with content. The page can (and for this purpose has to) start with a frontmatter, something like metadata information about the note.

For this package, the metadata has to contain four keywords:
- book
- scene_number
- chapter_number
- chapter_name

You can also use any other keywords based on your organization, but these four have to be here. (The chapter name does not need to be filled.)

In the end, the frontmatter must have lines as following:

```
---
book: This is the name of the book!
scene_number: 1
chapter_number: 1
chapter_name: TBD
---
```

The next line can include Topics, but if not, that is fine. Then, content needs to come. Have in mind, that Latex paragraphs are done by using double "\n". The programm reads lines from your markdown file and is able to process this.

## Setup

The package works with environment variables. Therefore, you need to setup
```
OBSIDIAN_PATH=""
PROJECTS_PATH=""
```
to point to the correct system Obsidian path and path to create your projects in. The projects path has to exist already.

## How to use

### Initialization

Run the `init_project` function to interactively go through project creation process. You can do it via
```
julia --project=. scripts/init_project.jl
```
or by `using LatexBook` and running `init_project()`.

The script will ask for author name, book name, and other information. Note that the book name needs to be the same string as is written in the frontmatter of your .md book files. Otherwise the script will not be able to filter our the correct files.

### Export book

To run exporter, simply run
```
julia --project=. scripts/export_book.jl book_nickname
```
with `book_nickname` being the nickname you chose in the initialization process.