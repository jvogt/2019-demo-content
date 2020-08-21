# Chef Desktop Documentation

This folder contains the source for the Chef Desktop documentation.

## The fastest way to contribute

The fastest way to change the documentation is to edit a page on the
GitHub website using the GitHub UI.

To perform edits using the GitHub UI, click on the `[edit on GitHub]` link at
the top of the page that you want to edit. The link takes you to that topic's GitHub
page. In GitHub, click on the pencil icon and make your changes. You can preview
how they'll look right on the page ("Preview Changes" tab).

We also require contributors to include their [DCO signoff](https://github.com/chef/chef/blob/master/CONTRIBUTING.md#developer-certification-of-origin-dco)
in the comment section of every pull request, except for obvious fixes. You can
add your DCO signoff to the comments by including `Signed-off-by:`, followed by
your name and email address, like this:

`Signed-off-by: Julia Child <juliachild@chef.io>`

See our [blog post](https://blog.chef.io/introducing-developer-certificate-of-origin/)
for more information about the DCO and why we require it.

After you've added your DCO signoff, add a comment about your proposed change,
then click on the "Propose file change" button at the bottom of the page and
confirm your pull request. The CI system will do some checks and add a comment
to your PR with the results.

The Chef documentation team can normally merge pull requests within seven days.
We'll fix build errors before we merge, so you don't have to
worry about passing all the CI checks, but it might add an extra
few days. The important part is submitting your change.

## Local Development Environment

We use [Hugo](https://gohugo.io/), [Go](https://golang.org/), and[NPM](https://www.npmjs.com/)
to build the Chef Documentation website. You will need Hugo 0.61 or higher
installed and running to build and view our documentation properly.

To install Hugo, NPM, and Go on Windows and macOS:

- On macOS run: `brew install hugo node go`
- On Windows run: `choco install hugo nodejs golang -y`

To install Hugo on Linux, run:

- `apt install -y build-essential`
- `snap install node --classic --channel=12`
- `snap install hugo --channel=extended`

## Hugo Theme

We use a git submodule to grab the Hugo theme from the `chef/chef-web-docs` repository.

## Preview Workstation Documentation

There are three ways to preview the documentation in `chef-workstation`:

- submit a PR
- `make serve`
- `make serve_chef_web_docs`

### Submit a PR

When you submit a PR to `desktop-config`, Netlify will build the documentation
and add a notification to the GitHub pull request page. You can review your
documentation changes as they would appear on docs.chef.io.

### make serve

`make serve` will preview the documentation that only exists in `chef/desktop-config`.
This also shows a preview page that includes page metadata which can be useful
for changing where a page exists in the left navigation menu.

To build the docs and preview locally:

- Run `make serve`
- go to http://localhost:1313

The landing page shows navigation menu metadata and the left navigation menu
shows the menu weight for each page. You can use this information to add,
remove, or reorganize Workstation documentation in the menu. None of this will
appear on the [Chef Documentation](https://docs.chef.io) site when the workstation
content is updated.

While the Hugo server is running, any changes you make to content
in the `docs/content` directory will be automatically compiled and updated in the
browser.

**Clean Your Local Environment**

To clean your local development environment:

- Running `make clean` will delete the sass files, javascript, and fonts in
  `themes/docs-new`. These will be rebuilt the next time you run `make serve`.

- Running `make clean_all` will delete the node modules used to build this site
  in addition to the functions of `make clean` described above. Those node
  modules will be reinstalled the next time you run `make serve`.

- Running `make reset_chef_web_docs` will reset the chef-web-docs submodule to
  version that was cloned down by git. This will delete any new files and undo
  all changes to files in the chef-web-docs submodule.

### make serve_chef_web_docs

`make serve_chef_web_docs` will preview local changes to the content in
`chef/desktop-config/docs` as they would appear in docs.chef.io. It will run the
Hugo server from a `chef-web-docs` submodule which will pull the content from your
local copy of `desktop-config`.

## Creating New Pages

Please keep all your documentation in the `content/desktop` directory.
To add a new Markdown file, run the following command from the `docs` directory:

```
hugo new content/desktop/<filename>.md
```

This will create a draft page with enough front matter to get you going.

Hugo uses [Goldmark](https://github.com/yuin/goldmark) which is a
superset of Markdown that includes GitHub styled tables, task lists, and
definition lists.

See our [Style Guide](https://docs.chef.io/style_guide/) for more information
about formatting documentation using Markdown.

## Chef Desktop Page Menu

Adding pages to a menu or modifying a menu should be handled by the Docs Team.

If you add content, it will not automatically show up in the left navigation menu.
Build the site locally (`make serve`) and see the landing page (`http://localhost:1313`).
Any page followed by `Desktop Menu: False` has not been added to the left navigation menu.

Each page needs a page title, an identifier, and a parent.

**Title**
The title is the name of the page as it appears in the left navigation menu.

**Parent**
The parent is the path to that page in the left navigation menu. For example, the
`getting started` page is found by clicking on Chef Desktop so it's parent is
`chef_desktop`.

**Identifier**
Each menu identifier must be unique. We use the menu parent value, followed by
the file name, followed by the page title.

**Menu Weight**
The menu weight is optional. If it isn't included, Hugo assigns each page a weight of 0
and pages with the same weight are put in alphabetical order. Pages with a higher weight
are lower in the menu.

Below is an example of a page menu entry:

```
[menu]
  [menu.desktop]
    title = "Page Menu Title"
    identifier = "chef_desktop/<file_name>.md Page Title"
    parent = "chef_desktop"
    weight = 10
```

## Desktop Menu Config

The framework for the desktop menu is located in the `config.toml`
file. This defines the parent menu directories that each page can be added to.

In addition, you can add links to the Desktop menu that navigate to other pages on
the [Chef Documentation](https://docs.chef.io) site or to an external site. See
the example below.

```
[[menu.desktop]]
title = "Page Menu Title"
identifier = "desktop/file_name.md Page Title"
parent = "desktop"
url = "relative or absolute URL"
weight = 10
```

See the [Hugo menu documentation](https://gohugo.io/content-management/menus/)
for additional information about formatting a menu item.

## Shortcodes

Shortcodes are simple snippets of code that can be used to modify a Markdown
page by adding content or changing the appearance of content in a page. See
Hugo's [shortcode documentation](https://gohugo.io/content-management/shortcodes/)
for general information about shortcodes.

We primarily use shortcodes in two ways:

- adding reusable text
- highlighting blocks of text in notes or warnings to warn users or
provide additional important information

### Adding reusable text

There are often cases where we want to maintain blocks of text that are identical
from one page to the next. In those cases, we add that text, formatted in Markdown,
to a shortcode file located in `desktop-config/docs/layouts/shortcodes`.

Each shortcode in the Chef Desktop documentation must be prefixed with `dt_`.
For example, `dt_shortcode_name.md`.

To add that shortcode to a page in `desktop-config/docs/content`, add the file name,
minus the .md suffix, wrapped in double curly braces and percent symbols to
the location in the Markdown page where you want that text included. For example,
if you want to add the text in `dt_shortcode_file_name.md` to a page, add
`{{% dt_shortcode_file_name %}}` to the text of that page and it will appear when
Hugo rebuilds the documentation.

**Shortcodes in lists**

Hugo doesn't handle shortcodes that are indented in a list item properly. It interprets
the text of the shortcode as a code block. More complicated shortcodes with
code blocks, notes, additional list items, or other formatting look pretty
bad. We've created a simple shortcode for handling shortcodes in lists or definition
lists called `readFile_shortcode`.

To include a shortcode in a list or definition list, just add its file name
to the `file` parameter of `readFile_shortcode`.

For example, if you wanted to add `shortcode_file_name.md` to a list:
``` md
1.  Here is some text in a list item introducing the shortcode.

    {{< readFile_shortcode file="shortcode_file_name.md" >}}
```

### Highlighting blocks of text

We also use shortcodes to highlight text in notes, warnings or danger notices.
These should be used sparingly especially danger notices or warnings. Wrap text
that you want in a note using opening and closing shortcode notation. For example,

```
{{< note >}}

Note text that gives the user additional important information.

{{< /note >}}
```

To add a warning or danger, replace the word `note` with `warning` or `danger` in the
example above.

**Notes in lists**

Hugo doesn't handle shortcodes that are indented in lists very well, that includes the Note,
Warning, and Danger shortcodes. It interprets the indented text that's inside
the Note as a code block when it should be interpreted as Markdown.

To resolve this problem, there's a `spaces` parameter that can be added to the Note,
Warning, and Danger shortcodes. The value of spaces should be set to the number
of spaces that the note is indented.

For example:
```
This is a list:

-   List item.

    {{< note spaces=4 >}}

    Text that gives the user additional important information about that list item.

    {{< /note >}}
```

This parameter also works on Danger and Warning shortcodes.

## Aliases

Add an alias to the page metadata to redirect users from a page to the page you are
editing. They are only needed if a page has been deleted and you want to redirect
users from the deleted page to a new or existing page.

## Resource pages

The resource pages are generated using YAML data located in
`docs/content/desktop/resources`.
The YAML data is generated directly from the Desktop code.
Each resource page calls the `desktop_resource_yaml` shortcode.
This shortcode reads the name of the resource from the `desktop_resource` parameter
and then calls the resource YAML file from `docs/content/desktop/resources`.
For example, if we had a resource called "Example", the page would be located at
`docs/content/desktop/resources/example.md`, and the YAML data would be stored
in `docs/content/desktop/resources/example.yaml`.

An additional index page, `docs/content/desktop/resources/_index.md`, reads all
of the YAML files and returns one long page.

These pages use shortcodes (`desktop_resource_yaml` and `desktop_resource_yaml_all`) and layouts
(`desktop_resource_single_toc` and `desktop_resource_all_toc`) to
read the content of each YAML file and return HTML pages and tables of contents.

For general information about YAML see the official [YAML website](https://YAML.org/).

## Generating the YAML files

The YAML files are generated using a rake task.

`bundle exec rake docs_site:resources`

The rake task will dump the resource yaml files in the `auto_generated_docs` directory.

The rake task doesn't generate all of the content in the resource yaml files.
Currently the resource examples and action descriptions must be manually maintained.

## Generating Markdown pages for each YAML file

`make resource_files` will automatically generate a Markdown page in `docs/content/desktop/resources`
for each YAML file located `docs/data/desktop/resources`

### Page metadata

Each resource Markdown page has a header with page metadata. See the content above
for information about formatting the page metadata.

The only parameters in a resource page that isn't found in a regular page are the
**desktop_resource** and the **desktop_resource_list** parameters.

**desktop_resource**

This is the name of the resource. For example, `desktop_resource = "apt_package"`.

**desktop_resource_list**

This is only used for the `_index.md` page that displays all the resources.
Use `desktop_resource_list = true`

### Resource Markdown page shortcodes

There are two shortcodes used in the resource pages. Both shortcodes are located
in `layouts/shortcodes`.

**desktop_resource_yaml_all**

`desktop_resource_yaml_all` reads and displays content from all YAML files in `docs/data/desktop/resources`.

**desktop_resource_yaml**

`desktop_resource_yaml` will read and display content from the YAML file specified in the
`desktop_resource` page parameter.

## YAML file data

Each YAML data file contains data about the resource.

**resource_description_list**

This is a list of content that will build the introductory description section of each
resource page. Markdown, notes, warnings, and shortcodes can be added to the list.
Notes and warnings can include Markdown or shortcode content.

This content will display on the page in the same order that it appears in the list.

Example:

```
resource_description_list:
- markdown: 'This is markdown text. It will be added before the note below.'
- note:
    shortcode: shortcode_file_name.md
    markdown: This Markdown text will appear in a note but after the shortcode above.
```

**resource_new_in**

This will add **New in Chef Desktop X.Y** to the description of the
resource page. The text won't appear if value is blank.

Example:

```
resource_new_in: 14.0
```

**syntax_description**

A short introductory description in Markdown that explains the syntax of the resource and includes 
an example code block.

For example:

    syntax_description: "The build_essential resource has the following syntax:\n\n```\
      \ ruby\nbuild_essential 'name' do\n  compile_time      true, false # default value:\
      \ false\n  action            Symbol # defaults to :install if not specified\nend\n\
      ```"

or,

    syntax_description: "A **bash** resource block executes scripts using Bash:\n\n```\
      \ ruby\nbash 'extract_module' do\n  cwd ::File.dirname(src_filepath)\n  code <<-EOH\n\
      \    mkdir -p #{extract_path}\n    tar xzf #{src_filename} -C #{extract_path}\n\
      \    mv #{extract_path}/*/* #{extract_path}/\n    EOH\n  not_if { ::File.exist?(extract_path)\
      \ }\nend\n```"


**syntax_properties_list**

The properties of the code block in `syntax_code_block` in list format.

For example:

```
syntax_properties_list:
- '`apt_preference` is the resource.'
- '`name` is the name given to the resource block.'
- '`action` identifies which steps Chef Infra Client will take to bring the node into
  the desired state.'
- '`glob`, `package_name`, `pin`, and `pin_priority` are the properties available
  to this resource.'
```

**syntax_full_code_block**

A code block showing the full syntax of all of the properties available in a resource. This can be omitted and nothing will be displayed.

**syntax_full_properties_list**

A list of all of the properties in the code block in ``syntax_full_code_block``. This can be omitted and nothing will be displayed.

**syntax_shortcode**

Some resources use a shortcode to display their syntax section.

For example:

``syntax_shortcode: resource_log_syntax.md``

**actions_list**

This is a list of actions followed by Markdown or a shortcode that describes each action.

The example below will display the `install` action followed by a markdown description,
and then `nothing` action followed by a shortcode.

```
actions_list:
  :install:
    markdown: Markdown that describes the install action.
  :nothing:
    shortcode: resources_common_actions_nothing.md
```

**properties_shortcode**

The properties section of some resource pages is a shortcode. This will display
the shortcode specified in lieu of describing the properties using ``properties_list``.

**properties_list**

This is a list of each property in a resource.

- property

  The name of the property.

- ruby_type

  The ruby data type of the property.

- required

  `True` or `False`. Indicates if the property is required by the resource and
  adds ``REQUIRED`` to the description of the property.

- default_value

  The default value of the property.

- new_in

  The version of Chef Desktop that this property was introduced in.

- description_list

  A list of content used to describe the property. Valid keys are `markdown`,
  `note`, `warning`, and `shortcode`. Notes and warnings can have markdown or
  shortcode content.

  This content will display on the page in the same order that it appears in the list.

For example:

```
properties_list:
- property: property name
  ruby_type: String
  required: false
  default_value: null
  new_in: 14.0
  description_list:
  - markdown: Some text describing the property.
  - note:
    - shortcode: shortcode_file.md
  - warning:
    - markdown: Markdown text warning the user about the property.
```

**examples_list**

Each example starts with a heading, which is bolded on its resource page, followed by
blocks of text that describe and demonstrate how the resource works.

- example_heading

  The heading for each example which will be bolded on the resource page.

- text_blocks

  A list of text blocks that describe and demonstrate each example. Valid keys for
  the text blocks are `shortcode`, `note`, `code_block`, and `markdown`. Notes only
  accept markdown text.

  This content will display on the page in the same order that it appears in
  the `text_blocks` list.

For example:

```
examples_list:
- example_heading: Set an environment variable
  text_blocks:
  - code_block: "windows_env 'ComSpec' do\n  value \"C:\\\\Windows\\\\system32\\\\\
      cmd.exe\"\nend"
```

### Shortcodes

These values, if set to `true`, will display sections of text that include headings
followed by text from various shortcodes.

**properties_multiple_packages**

Used in the dnf package, package, and zypper package resource pages. Adds
the **Multiple Packages** section to the Properties section of the resource page.

**resource_directory_recursive_directories**

Used in the directory and remote directory resource pages. Adds the **Recursive Directories**
section to the Properties section of the resource page.

**resources_common_atomic_update**

Used in the cookbook file, file, remote file, and template resource pages. Adds
the **Atomic File Updates** section to the Properties section of the resource page.

**properties_resources_common_windows_security**

Used in the cookbook file, directory, file, remote file, and template resource
pages. Adds the **Windows File Security** section to the Properties section of the
resource page.

**resources_common_properties**

Used in several resource pages. Adds the **Common Properties** section to the
Common Resource Functionality section of the resource page.

**resources_common_notification**

Used in several resource pages. Adds the **Notifications** section to the
Common Resource Functionality section of the resource page.

**resources_common_guards**

Used in several resource pages. Adds the **Guards** section to the
Common Resource Functionality section of the resource page.

### Resource page tables of contents

The tables of contents templates for the resource pages are located in
`layouts/partials`.

The tables of contents for the resource reference page and the individual resource
pages are generated in the same way that the resource reference
page and the individual resources pages are created. Hugo crawls through the resource
YAML files and builds an unordered list listing each H1 through H3 heading. This
means that if a section of content is added or removed from the resource page
templates, then those headings also have to be added or removed to the respective
tables of contents templates.

Failure to update the resource page table of contents templates
may lead to links that don't link to the proper content, links that don't work properly,
or content that isn't linked to in the table of contents.

## Structure

### High Level
```
.
├── Makefile    # contains helpers to quickly start up the development environment
├── README.md
├── docs        # the hugo site directory used for local development
```

### Local Content
```
.
├── site
│   ├── content
│   │   ├── desktop                 # where to keep markdown file documentation
│   ├── data
│   │   ├── desktop            # where to keep structured data files used for data templates
│   ├── layouts
|   │   ├── shortcodes
|   │   │   ├── dt_<shortcode_name>.md  # how to name your desktop-specific shortcodes
|   ├── static
|   |   ├── images
|   |   |   ├── desktop-config        # where to keep any images you need to reference in your documentation
```

### What is happening behind the scenes

The [Chef Documentation](https://docs.chef.io) site uses [Hugo modules](https://gohugo.io/hugo-modules/)
to load content directly from the `docs` directory in the `chef/desktop-config`
repository. Every time `chef/desktop-config` is promoted to stable, Expeditor
instructs Hugo to update the version of the `chef/desktop-config` repository
that Hugo uses to build Chef Desktop documentation on the [Chef Documentation](https://docs.chef.io)
site. This is handled by the Expeditor subscriptions in the `chef/chef-web-docs` GitHub repository.

## Sending documentation feedback

We love getting feedback. You can use:

- Email --- Send an email to docs@chef.io for documentation bugs,
  ideas, thoughts, and suggestions. This email address is not a
  support email address, however. If you need support, contact Chef
  support.
- Pull request --- Submit a PR to this repo using either of the two
  methods described above.
- GitHub issues --- Use the https://github.com/chef/desktop-config/issues.
  This is a good place for "important" documentation bugs that may need
  visibility among a larger group, especially in situations where a doc bug
  may also surface a product bug. You can also use [chef-web-docs
  issues](https://github.com/chef/chef-web-docs/issues), especially for
  docs feature requests and minor docs bugs.
- https://discourse.chef.io/ --- This is a great place to interact with Chef and others.

## Questions

If you need tips for making contributions to our documentation, check out the
[instructions](https://docs.chef.io/style_guide.html).

If you see an error, open an [issue](https://github.com/chef/chef-web-docs/issues)
or submit a pull request.

If you have a question about the documentation, send an email to docs@chef.io.
