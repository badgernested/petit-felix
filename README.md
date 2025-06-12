# What is PetitFelix?

PetitFelix is a document generating tool that takes markdown files, that contains a separate metadata section, and assembles them into a printable format such as PDF. This could be used to easily make small scale publications for local art scenes and stuff, but it's pretty early in development.

# How do I use PetitFelix?

This tool might be a little challenging at first to use. A long term goal is to make the software easier for people with little experience in computers to use, but also having a useful command line interface.

## Configuration

You can configure the default settings of your output with the ``./default.cfg`` file.

Metadata is written in a style similar to this:
```
front_cover: true
back_cover: true
author: badgernested
```

See the Metadata section below for more information on using metadata tags.

## Setting Up Source Files

To create documents, you will need to draft text documents that contains metadata separated from the content. You can separate this data with a lone line that has ``---`` on it.

The order of loading configs is:
1. Defaults are loaded.
2. Configs loaded in ``./default.cfg`` are loaded.
3. Configs passed as command line arguments are loaded.
4. Configs in file metadata are loaded for each file.

### File Metadata

Metadata is used to change how the file is rendered, including things such as title, cover art, etc. as well as options for text sizes and things like that. Metadata defined in the file overrides the metadata loaded by the options.

To write metadata, use it in this kind of format:
```
title: "Test title"
date: 2025-05-04
---
[[content...]]
```

Notice the separator between the markdown content and the metadata. This is very important or else PetitFelix will not work.

### Command Line Arguments

When calling ``./petitfelix.rb`` from the command line, you can also pass arguments to modify the output.

Each argument is prefixed with ``--``. See the example below:

```
ruby ./petitfelix.rb --columns 3
```

This will output the default otuput with 3 columns for the text.

## Metadata Elements

The basic document builder supports the following tags:

* Required Elements
	* ``title`` - The title as displayed on the front cover and filename.
* Front Cover Elements
	* ``front_cover`` - If ``true``, will create the front cover.
	* ``author`` - The author of the work. Displayed on the front cover.
	* ``front_cover_image`` - The front cover art. Images are stored in ``./assets/images``.
	* ``date`` - The date of original publication.
	* ``front_extra_page`` - Inserts an empty page after the cover if true. Useful for double sided prints.
* Back Cover Elements
	* ``back_cover`` - If ``true``, will create the back cover.
	* ``back_cover_image`` - The back cover art. Images are stored in ``./assets/images``.
	* ``author_back`` - The author of the work. Displayed on the bottom of the back cover. Could be used for account names or websites.
	* ``back_extra_page`` - Inserts an empty page before the back cover if true. Useful for double sided prints.
* Styling Elements
	* ``default_font_size`` - Default paragraph text font size.
	* ``header[1-6]_size`` - 6 different variables for indicating font size for different headers.
	* ``quote_size`` - Quote text size.
	* ``default_line_spacing`` - Default spacing between lines.
	* ``quote_line_spacing`` - Quote spacing between lines.
	* ``header[1-6]_line_spacing`` - Quote spacing between headers.
	* ``font_normal`` - Path to the default font for the normal font face. 
	* ``font_italic`` - Path to the default font for the *italic* font face. 
	* ``font_bold`` - Path to the default font for the **bold** font face. 
	* ``font_bold_italic`` - Path to the default font for the ***bold italic*** font face. 
	* ``quote_font_normal`` - Path to the quote font for the normal font face. 
	* ``quote_font_italic`` - Path to the quote font for the *italic* font face. 
	* ``quote_font_bold`` - Path to the quote font for the **bold** font face. 
	* ``quote_font_bold_italic`` - Path to the quote font for the ***bold italic*** font face. 
	* ``quote_font_spacing`` - Amount of spacing between characters in quotes.
* Text Formatting Elements
	* ``columns`` - How many columns to display in the text.
	* ``margin`` - How much to move in the margins.
	* ``page_layout`` - Whether or not to render in ``portrait`` or ``landscape`` mode. Note: ``landscape`` cover is incomplete currently, working on it...
* Filesystem (Only tested on global config settings and command line arguments)
	* ``input_files`` - A list of file path masks to process. It can be a path directly to a file like ``./md/2025-06-05-cane.md``, or it can be a mask that includes a set of files like ``./md/2025-*.md``
	* ``output_dir`` - Output directory.
	* ``image_dir`` - The base directory for cover images.

The front cover looks like this.

In future versions this will be more customizable but currently just laying out the groundwork first!

## Content

To create documents, you will need to have files written in markdown.

Markdown is a style of formatting that uses special characters to modify how text is rendered, similar to what you might see in printed media or on a website. This allows users to render very nice looking articles while just focusing on text output, but can also be a useful way to store formatting information for other purposes.

The following markdown tags are currently supported:
- ``#`` - this tag is used to indicate headers. ``#`` is header 1, ``##`` is header 2, etc.
- ``links``
- ``bold``
- ``italic``
- ``strikeout``

The following is removed:
- ``<iframe>``, such as video links from YouTube or other embedded media

The following is removed, but will be added in a future update:
- ``images``

For more on Markdown, view [the markdown reference](https://www.markdownguide.org/basic-syntax/).

## Running PetitFelix

PetitFelix is currently a very simple ruby script that you can execute from the command line. I will be adding better deployment/automation in the future.

### Ruby

You will need the following ruby gem dependencies installed:

```
gem install prawn
gem install prawndown-ext
```

Once you have the dependencies installed, you can execute it by simply calling:

```
ruby ./petitfelix.rb
```

### Bundler

You can also use ``bundler`` to run PetitFelix. To run, first install the gems in the gemfile:

```
bundle install
```

Then, you can run PetitFelix like so:

```
bundle exec ruby petitfelix.rb
```

