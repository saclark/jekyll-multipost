require 'cgi'

module Jekyll
  class MultiPostGenerator < Generator
    safe true

    def generate(site)
      generate_views(site, :posts)
      generate_views(site, :pages)
    end

    private

    def generate_views(site, resource_type)
      klass = resource_klass(resource_type)

      site.send(resource_type).map! do |resource|
        resource.data["layout"].is_a?(Array) ? generate_layouts(resource, klass) : resource
      end.flatten!
    end

    def resource_klass(resource_type)
      klasses = {
        :posts => Post,
        :pages => Page
      }

      klasses[resource_type]
    end

    def generate_layouts(resource, klass)
      resource.data["layout"].map do |layout|
        view = klass.new(resource.site, resource.site.source, resource_dir(resource), resource.name)
        view.data["layout"] = layout
        view.data["permalink"] = view_permalink(resource, layout)
        view
      end
    end

    def resource_dir(resource)
      resource.instance_variable_get(:@dir)
    end

    def view_permalink(resource, layout)
      layout_path = CGI.escape(layout)
      url = resource.url
      ext = File.extname(url)

      if url.include?(':layout')
        return url.gsub(/:layout/, layout_path)
      end

      if ext.empty?
        "#{url}/#{layout_path}/"
      else
        url.gsub(/\/$|#{ext}$/) { |url_end| "/#{layout_path}#{url_end}" }
      end
    end
  end
end
