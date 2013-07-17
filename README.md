# MultiPost
MultiPost is a [Jekyll](https://github.com/mojombo/jekyll) plugin that enables the generation of multiple posts, each utilizing a different layout, from a single post entry.

This is useful for any situation where you have a single content base that you wish to display in various manners (such as: tailoring content presentation for different audiences, A/B testing, comparing different designs). You may want to modify or extend the plugin to better suit your specific needs (i.e. adjust the permalink structure in `MultiPost`'s `initialize` method.


## Usage
Drop the `multipost.rb` file in your `_plugins` directory and then, for any given post, you may declare each layout you wish to use within an array for the `layout` variable in the YAML front matter. The plugin will generate one post with each layout listed in the array.


### Example
```yaml
layout: [layout_A, layout_B]
```

or

```yaml
layout:
- layout_A
- layout_B
```