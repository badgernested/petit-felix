# Using petit-felix

## Installing Ruby and petit-felix

## Markdown Files

Markdown is a commonly used syntax used when editing text files to display formatting when processed by a markdown reader. For example, headers in markdown documents are represented with ``#`` characters at the beginning of a line. Forms of Markdown are used all over the internet, such as on Github's documentation pages like this, Wikipedia editing, static generated blogs like Jekyll and even chat clients like Discord. You can learn more how to use Markdown quickly with this [cheat sheet](https://www.markdownguide.org/cheat-sheet/) here.

With ``petit-felix``, a little more in your Markdown files is expected. This is because it not only reads Markdown, but it also reads a set of metadata parameters that are stored on the top of the file. These parameters allow you to customize the output more, and are the same parameters you will see on the Task pages. This is also the same way it works in Jekyll's static post generation, so if you have used Jekyll before, this should be familiar.

The typical ``petit-felix`` compatible Markdown file looks like this:

```
---
title:  What My Cane Taught Me About Revolution
date:   2025-06-05
author: punishedfelix.com
---

# Heading 1

The text of the document goes here...
```

As you can see, it's separated into two parts:
- The first part is separated with ``---`` and contains a bunch of metadata parameters separated by a ``:`` character.
- The second part contains the markdown content.

> [!IMPORTANT]  
> In order to generate, ``title`` **must** be set in the options. This also mandates that all markdown parsed by ``petit-felix`` includes metadata parameters. Additionally, if using the Jekyll plugin provided, you must also include ``pdf: true`` in the file in order for it to generate.


