# MultiPost
MultiPost is a [Jekyll](https://github.com/mojombo/jekyll) plugin that allows you to specify multiple layouts in which to render a given post, page, or collection document.

## Installation
Simply clone/download/copy+paste the appropriate `multipost.rb` file to a `_plugins` directory in your jekyll site source root (see option #1 from the [jekyll documentation](http://jekyllrb.com/docs/plugins/#installing-a-plugin)).

**Jekyll version >= 3**
- Use the `mutlipost.rb` file from the `jekyll_v3` directory.

**Jekyll version < 3**
- Use the `mutlipost.rb` file from the `jekyll_v1-2` directory.

## Usage
This plugin gives you the option to list more than one layout in the YAML front matter of your posts and pages (entires with a single layout -- e.g. `layout: layout_a` will still behave as usual).

```yaml
---
layout: [layout_a, layout_b]
title:  "My Awesome Post"
---
```

The post will then be rendered in each of the given layouts.

To ensure unique urls, each rendering of the post will have the name of the layout appended to it by default. For example:

- `/my-awesome-post/` becomes `/my-awesome-post/layout_a/`, or
- `/my-awesome-post.html` becomes `/my-awesome-post/layout_a.html`


However, you can customize this behavior by using a `:layout` variable in your permalink templates.

```yaml
---
layout: [layout_a, layout_b]
permalink: ":layout/:title/"
title:  "My Awesome Post"
---
```

## Why Would I Want This?
This is useful for any situation where you have a single content base that you wish to display in different views (e.g. prototyping designs, A/B testing, tailoring content presentation for different audiences).
