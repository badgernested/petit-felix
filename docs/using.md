# Using petit-felix

## Installation

### Installing Ruby and Rubygems

First, make sure that [Ruby is installed on your machine](https://www.ruby-lang.org/en/documentation/installation/), then make sure [Rubygems is also installed](https://rubygems.org/pages/download). You can test your installation by running the following in the console:

```
ruby -v
gem -v
```

If all is well, you will see the version number displayed.

### Running petit-felix

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

#### Arguments

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

#### Calling petit-felix
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

#### Running petit-felix in the Command Line Interface (CLI)

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

#### Running petit-felix with bundler

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

#### Using petit-felix in a Ruby Gem

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

#### Using the petit-felix Jekyll plugin

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


