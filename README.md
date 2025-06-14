# petit-felix

[![Gem Version](https://badge.fury.io/rb/petit-felix.svg)](https://badge.fury.io/rb/petit-felix)

``petit-felix`` is a document generator ruby gem and standalone command line program that can input markdown files and produce very nice looking outputs depending on the worker assigned. You can use this to turn markdown files, specifically those used on [Jekyll](https://jekyllrb.com/) posts, into a printable format that looks nice. If your markdown files are not formatted like Jekyll files, it is easy to update them to work with ``petit-felix``.

If you're just getting started, check out the [Quickstart Guide](#quickstart-guide). But if you want to know more about ``petit-felix``, check out the [Documentation](#documentation).

# Quickstart Guide

You can run ``petit-felix`` in multiple ways:

- [In the CLI with ruby](#running-petit-felix-in-the-command-line-interface-cli).
- [Using bundler](#running-petit-felix-with-bundler).
- [As a Ruby Gem](#using-petit-felix-in-a-ruby-gem).
- [As a plugin for Jekyll](#using-the-petit-felix-jekyll-plugin).

``petit-felix`` works by passing arguments to "workers". Workers are different ways that files can be created with by ``petit-felix``. Each worker will read the arguments passed to the main program, and will produce outputs based on these arguments. It can also read command line arguments

The order of reading arguments from least important to most important is:

1. Default option values.
2. Options defined in ``./default.cfg``.
3. Command line arguments passed.
4. Any options passed as an argument from calling the class directly.
5. Options in the top level of the data files, in the same style as Jekyll markdown files.

## Arguments

You can pass arguments on the command line or through an options hash, depending on how you are running ``petit-felix``. 

To pass it through the command line, make sure each option starts with ``--``:

```
ruby ./petit-felix.rb --columns 2
``` 

You can also create an options hash and pass that in ruby code like this:

```
# options hash
options = {
	"input_files" => "./_posts",
	"output_dir" => "./pdf",
}

# Calling petit-felix
PetitFelix::Output.new(options: options)
```

The following arguments are global to the application and are not specific to a worker:
* ``task`` - The worker to use.
* ``input_files`` - A list of file path masks to process. It can be a path directly to a file like ``./md/2025-06-05-cane.md``, or it can be a mask that includes a set of files like ``./md/*.md``
* ``output_dir`` - Output directory.
* ``image_dir`` - The base directory for images.

The following arguments are **required** to be in the data files, or else they will not generate:
* ``title`` - The title as displayed on the front cover and filename.

The arguments for workers are specific to each worker, and you can read more about them on their specific documentation pages:

- [basic_pdf](docs/workers/basic_pdf) - A simple worker that makes a PDF file from a Jekyll style markdown page. Useful for turning Jekyll blogs into zines.

## Running petit-felix in the Command Line Interface (CLI)

You can run ``petit-felix`` through the command line using Ruby.

First, make sure the appropriate gem dependencies are installed:

```
gem install petit-felix
```

Then, run the script.

```
ruby ./petit-felix.rb
```

You can also run it using the ``.sh`` file provided, making it an executable script.

```
./petit-felix.rb
```

## Running petit-felix with bundler

You can also easily execute ``petit-felix`` with bundler.

To run ``petit-felix``, first make sure that bundler has the necessary gems installed.

```
bundle install
```

Then, just run it with ruby.

```
bundle exec ruby petit-felix.rb
```

You can pass arguments just like with the normal CLI interface.

## Using petit-felix in a Ruby Gem

``petit-felix`` can also be used in your ruby applications by passing a hash of arguments.

First, make sure that the ``petit-felix`` gem is installed:

```
gem install petit-felix
```

Or, if you need to add it to your gemfile:

```
gem 'petit-felix'
```

Then, when you want to call ``petit-felix``, you can do so with the following command:

```
# "options" is the argument passed as the options hash
PetitFelix::Output.new(options: options)
```

## Using the petit-felix Jekyll plugin

``petit-felix`` has a simple plugin included in the repository in ``./jekyll/_plugins`` that you can add to your Jekyll project's ``_plugins`` directory so you can produce PDFs of your files with your blog when you build it.

First, add the following value to your ``_config.yml`` file:

```
gen_pdf: true
```

> [!IMPORTANT]  
> This value **must** be set to true or else it will not generate any files.

With this set, you can now execute . Note that individual markdown files must be marked to include ``pdf: true`` in their metadata tags on the top of the file in order for a file to be produced. You can also add this line to ``./default.cfg`` as well to make all PDF files generate.

> [!CAUTION]
> Do not use ``bundle exec jeykll serve`` while ``pdf: true`` in ``_config.yml``. This can lead to infinitely looping updates of the auto-update hotloading feature. Make sure that ``pdf: true`` is disabled when deploying or it may cause issues.

# Documentation

1. [Introduction to petit-felix](docs/intro.md)
2. [Using petit-felix](docs/using.md)
3. [Introduction to Workers](docs/worker.md)
4. [Introduction to Tasks](docs/tasks.md)
    - [basic-pdf](docs/task/basic_pdf.md)
