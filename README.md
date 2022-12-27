# Book

This is a very primitive package to create a Latex book structure from Markdown files.

The package is inspired by the usage of Obsidian. In Obsidian, each file is a note with content. The page can (and for this purpose has to) start with a frontmatter, something like metadata information about the note.

For this package, the metadata has to contain four keywords:
- book
- scene_number
- chapter_number
- chapter_name

You can also use any other keywords based on your organization, but these four have to be here. (The chapter name does not need to be filed.)

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