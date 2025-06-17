# petit-felix

[![Gem Version](https://badge.fury.io/rb/petit-felix.svg)](https://badge.fury.io/rb/petit-felix)

``petit-felix`` is a document generator ruby gem and standalone command line program that can input markdown files and produce very nice looking outputs depending on the worker assigned. You can use this to turn markdown files, specifically those used on [Jekyll](https://jekyllrb.com/) posts, into a printable format that looks nice. If your markdown files are not formatted like Jekyll files, it is easy to update them to work with ``petit-felix``.

If you're just getting started, check out the [Quickstart Guide](#quickstart-guide). But if you want to know more about ``petit-felix``, check out the [Documentation](#documentation).

# Quickstart Guide

If you just want to run ``petit-felix`` out of the box and have Ruby, Rubygems and Bundler installed, download the contents of the repository:

```
git clone git@github.com:badgernested/petit-felix.git
```

Then, install the dependencies:

```
bundle install
```

Then, just run it with ruby.

```
bundle exec ruby ./petit-felix.rb [arguments]
```

This will process the files in ``./md`` and output them to a new directory, ``./output``.

To view other ways to use ``petit-felix``, refer to the [usage documentation](docs/using.md).

# Documentation

1. [Introduction to petit-felix](docs/intro.md)
2. [Using petit-felix](docs/using.md)
3. [Introduction to Workers](docs/worker.md)
4. [Introduction to Tasks](docs/tasks.md)
    - [basic-pdf-classic](docs/task/basic_pdf_classic.md)
