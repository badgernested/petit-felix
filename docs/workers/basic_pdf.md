# basic_pdf

``basic_pdf`` is a worker that produces zines from markdown files from a predefined template.

## Arguments

This is a list of all the arguments for ``basic_pdf``.

### Front Cover Elements

* ``front_cover`` - If ``true``, will create the front cover.
* ``author`` - The author of the work. Displayed on the front cover.
* ``front_cover_image`` - The front cover art. Images are stored in ``./assets/images``.
* ``date`` - The date of original publication.
* ``front_extra_page`` - Inserts an empty page after the cover if true. Useful for double sided prints.

### Back Cover Elements

* ``back_cover`` - If ``true``, will create the back cover.
* ``back_cover_image`` - The back cover art. Images are stored in ``./assets/images``.
* ``author_back`` - The author of the work. Displayed on the bottom of the back cover. Could be used for account names or websites.
* ``back_extra_page`` - Inserts an empty page before the back cover if true. Useful for double sided prints.

### Styling Elements

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

### Text Formatting Elements

* ``columns`` - How many columns to display in the text.
* ``margin`` - How much to move in the margins.
* ``page_layout`` - Whether or not to render in ``portrait`` or ``landscape`` mode. Note: ``landscape`` cover is incomplete currently, working on it...
