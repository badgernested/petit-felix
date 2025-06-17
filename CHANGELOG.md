## [0.2.0] - 2025-06-17

- Added ``template_pdf`` worker. This worker reads JSON template files and processes them into PDF.
- Added many basic methods for ``template_pdf``.
- Added ability to customize margins per page and per bounding box. This allows for margins to make double sided printing better.

## [0.1.4] - 2025-06-14

- Minor improvements to worker class to be compatible with prawndown-ext changes

## [0.1.3] - 2025-06-13

- Major cleanup to the system to match documentation, further separation between worker and task classes.
- Added a ton of new features to ``basic_pdf`` (see the documentation on [basic_pdf](/docs/workers/basic_pdf.md) for more info).
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
