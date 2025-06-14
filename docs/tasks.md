# Introduction to Tasks

Tasks are classes that instantiate Workers and call them to produce work. You can think of Tasks as the instructions that ``petit-felix`` uses to transform a passed set of options into an output.

Tasks inherit the class ``PetitFelix::Task::DefaultTask``, and are stored in ``./lib/task``. 

## Task Loading

Tasks are loaded dynamically upon initalization of ``petit-felix`` through ``PetitFelix::TaskManager``. This class will search for all loaded classes in the ``PetitFelix::Task`` module and add them to a collection that can be referenced by the Task's name with the ``task`` argument.

## Required Methods and Constants

Methods:

- ``render_files`` - This method gets all the files to be rendered and calls ``render_zine`` for each one.
- ``render_zine`` - This method actually renders the document.

Constants:

- ``NAME`` - The name of the task as passed by the ``task`` argument.
- ``DEFAULT_OPTIONS`` - The default base options as a hash for any given task. These are overridden by things like CLI arguments, passed arguments etc.

## Task List

- [basic_pdf](task/basic_pdf.md) - A worker that transforms Jekyll-styled markdown files into PDF output through a static template.
