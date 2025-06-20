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
