# What is petit-felix?

``petit-felix`` is a Ruby Gem and standalone Ruby command-line program that allows you to create small print publications from a set of options and markdown files.

``petit-felix`` uses [prawndown-ext](https://rubygems.org/gems/prawndown-ext), a gem that extends [prawndown](https://rubygems.org/gems/prawndown) to render markdown in [prawn](https://rubygems.org/gems/prawn), a PDF generator in Ruby.

## What Motivated petit-felix?

I was working on my [Jekyll blog](https://punishedfelix.com) when I realized I didn't have print versions of my posts, which limited their distribution. I realized that I should make a script that automates turning markdown files into zines. However, I realized this software has a lot of potential to cover more broad use cases so I cleaned up the plugin and produced a system that was easier to extend over time and was very simple to work with.

``petit-felix`` is a reference to Félix Guattari, a French radical psychiatrist who distributed his own journals that he edited which had many contributors. This software is a little homage to that I guess lol.

## How is petit-felix Structured?

The entry point of the program is ``./lib/petit-felix.rb``. This application first processes all of the options to create a base line global option set for the entire run of the application, which can then be overridden by custom options for each file processed.

``petit-felix`` is sorted into two parts. ``Felix`` is the main command part of the application, and it has ``Tasks`` that assign work to ``Workers``, which are small programs that do specific tasks, like assembling the parts of the PDF file. The ``Workers`` read the options passed from ``Felix`` through the ``Tasks``, allowing ``Felix`` to act as an interface for all sorts of different kinds of ``Workers``. 

(I haven't tested it yet, but I want to make ``Workers`` easily user extendible as well, but that's a future goal)

``Felix`` is composed of the following classes:

- ``PetitFelix::Config`` - Where configs are loaded in.
- ``PetitFelix::Metadata`` - Metadata and file path parsers.
- ``PetitFelix::Error`` - Error printing code.
- ``PetitFelix::Generator`` - The main generator class.

The last class is the most interesting, so let's discuss it.

This class will take the value of the option ``worker`` (default: ``basic_pdf``) and use the worker assigned to that name to process the documents. This Worker is assigned work to create files organized by the Task that Felix runs when ``[PetitFelix::Generator].render_files(options)`` is exectuted.

``Tasks`` are a list of classes stored in ``./lib/felix/task``. The default task, ``PetitFelix::Task::DefaultTask`` has two methods that the interface expects:
- ``render_files`` - This processes the file input list and passes to ``render_zine`` the name of the current file to process.
- ``render_zine`` - This is where the worker is instructed to render the document based on the passed ``options``.

``Workers`` are classes stored in ``./lib/felix/worker`` with module ``PetitFelix::Worker`` and can do whatever to process the ``options`` they are passed. They do the work, while a corresponding ``Task`` is a representation of the organization of the work.
