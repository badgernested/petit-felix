# basic_pdf

``basic_pdf_classic`` is a worker that produces zines from markdown files from a predefined template.

## Arguments

This is a list of all the arguments for ``basic_pdf``.

### Front Cover Elements

* ``front_cover`` - If ``true``, will create the front cover.
* ``author`` - The author of the work. Displayed on the front cover.
* ``front_cover_image`` - The front cover art. Images are stored in ``./assets/images``.
* ``date`` - The date of original publication.
* ``front_extra_page`` - Inserts an empty page after the cover if true. Useful for double sided prints.
* ``front_publisher`` - A small text field on the bottom of the cover, for including things like publisher or group information.
* ``front_default_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the default fonts for each style for the front cover. Otherwise, it will use the default font set in the global configuration.
* ``front_title_size`` - Sets the font of the title on the front cover.
* ``front_title_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the fonts for each style for the front title. 
* ``front_author_size`` - Sets the font of the author section on the front cover.
* ``front_author_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the fonts for each style for the front author field. 
* ``front_date_size`` - Sets the font of the date on the front cover.
* ``front_date_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the fonts for each style for the front date field. 
* ``front_publisher_size`` - Sets the font of the publisher info on the front cover.
* ``front_publish_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the fonts for each style for the front publisher field.

### Back Cover Elements

* ``back_text`` - Text displayed on the back cover.
* ``back_text_margin`` - How much to push in the margins for the text on the back cover.
* ``back_text_size`` - The size of the font of the back text.
* ``back_cover`` - If ``true``, will create the back cover.
* ``back_cover_image`` - The back cover art. Images are stored in ``./assets/images``.
* ``back_author`` - The author of the work. Displayed on the bottom of the back cover. Could be used for account names or websites.
* ``back_author_size`` - The size of the text for the back author.
* ``back_publisher_size`` - Sets the font of the publisher info on the back cover.
* ``back_extra_page`` - Inserts an empty page before the back cover if true. Useful for double sided prints.
* ``back_default_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the default fonts for each style for the front cover. Otherwise, it will use the default font set in the global configuration.
* ``back_author_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the fonts for each style for the front author field. 
* ``back_publish_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the fonts for each style for the front publisher field.

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
* ``image_height`` - The height of in-line images.
* ``image_width`` - The width of in-line images.

### Text Formatting Elements

* ``columns`` - How many columns to display in the text.
* ``markdown_margin_array`` - Array of margin JSON objects that format markdown pages. They will repeat through the array each page on margins. Example: ``[{"left":50,"right":50,"top":10,"bottom":30}]`` makes every markdown page have ``50`` for left and right margins, ``10`` for the top margin and ``30`` for the bottom margin.
* ``page_layout`` - Whether or not to render in ``portrait`` or ``landscape`` mode. Note: ``landscape`` cover is incomplete currently, working on it...

### Paginator

* ``paginator`` - If true, renders the paginator on the bottom of the page.
* ``paginator_alternate`` - If true, the paginator will alternate sides.
* ``paginator_start`` - Which page to start on. 
* ``paginator_start_count`` - Which number to start counting on for the paginator.
* ``paginator_size`` - Text size of the paginator.
* ``paginator_font_[normal,italic,bold,bold_italic]`` - A set of 4 options that lets you set the fonts for each style for the paginator.
