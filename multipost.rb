require 'cgi'

module Jekyll
  class MultiPostGenerator < Generator
    safe true

    def generate(site)
      site.posts.map! do |post|
        post.data["layout"].is_a?(Array) ? generate_post_layouts(post) : post
      end.flatten!
    end

    private

    def generate_post_layouts(post)
      post.data["layout"].map do |layout|
        layout_post = Post.new(post.site, post.site.source, post_dir(post), post.name)
        layout_post.data["layout"] = layout
        layout_post.data["permalink"] = layout_permalink(post, layout)
        layout_post
      end
    end

    def post_dir(post)
      post.instance_variable_get(:@dir)
    end

    def layout_permalink(post, layout)
      layout_path = CGI.escape(layout)
      url = post.url

      if url.include?(':layout')
        url.gsub(/:layout/, layout_path)
      else
        "#{url}/#{layout_path}"
      end
    end
  end
end
