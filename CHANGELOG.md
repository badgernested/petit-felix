## [0.1.13] - 2025-06-24

- Added ``PetitFelix::Process`` class, which separates generation from initialization.
- Fixed bug with default fonts not working with ``template_pdf``
- Fixed issue with lingering print message.

## [0.1.12] - 2025-06-21

- Bug fixes:
	- Fixed left-to-right output being printed right-to-left
	- Made sure 2-page prints always have page count divisible by 4 so that it prints correctly
	- Fixed bug with ``pdf-single`` not properly loading properties.
- Added some default parameters to ``pdf-single``.

## [0.1.11] - 2025-06-20

- Added ``set_alternate_pages`` method. This needs to be used at the beginning of a document to alter behavior for ``alternate_pages``.
- Made it so all command line parameters not defined are treated as properties

Note: Margins for alternating pages is not automated. I will have to figure out a way to make this work without rendering the pages twice... may be the only option though

## [0.1.10] - 2025-06-20

- Added ``copy_page``, ``paste_page`` and ``alternate_pages`` functions to template reader.

## [0.1.9] - 2025-06-19

- Bug fixes:
  - Fixed bug crash regarding validating floats 

## [0.1.8] - 2025-06-18

- Bug fixes:
	- Fixed output error caused by prawndown-ext

## [0.1.6] - 2025-06-18

- Bug fixes:
  - ``elif`` command was always choosing ``false`` if defined as ``false`` in the string.
- Code cleanup
	- Made code easier to read with better spacing.
	- Improved error handling with templates and expressions.

## [0.1.5] - 2025-06-18

- Added ``template_pdf`` worker. This worker reads JSON template files and processes them into PDF.
- Added many basic methods for ``template_pdf``.
- Added ability to customize margins per page and per bounding box. This allows for margins to make double sided printing better.
- Added ``pdf-single`` worker. This is a specific template that creates a similar output to the former ``basic-pdf``.
- Renamed ``basic-pdf`` to ``basic-pdf-classic``.

## [0.1.4] - 2025-06-14

- Minor improvements to worker class to be compatible with prawndown-ext changes

## [0.1.3] - 2025-06-13

- Major cleanup to the system to match documentation, further separation between worker and task classes.
- Added a ton of new features to ``basic-pdf`` (see the documentation on [basic_pdf](/docs/workers/basic_pdf.md) for more info).
- Allowed tasks to contain their own configs.
- Tasks are now loaded dynamically from ``lib/task``.

## [0.1.2] - 2025-06-12

- Transitioned towards having workers called by arguments.
- Added error printing class.
- Fixed bug with output directory for PDFs

## [0.1.1] - 2025-06-12

- Added support for the correct image file paths for images
- Added Jekyll script

## [0.1.0] - 2025-06-10

- Initial release
