require 'cgi'

# TODO: This is a very bad hacky-but-working first iteration. Refactoring needed:
#   * Break stuff out into separate classes/modules wherever it makes sense
#   * D.R.Y. up the code
#   * Don't access private members

module Jekyll
  class MultiPostGenerator < Generator
    safe true

    def generate(site)
      generate_page_layouts(site)
      generate_collection_item_layouts(site)
    end

    private

    #  PAGES
    # ==================================================================

    def generate_page_layouts(site)
      site.pages.map! do |page|
        if page.data["layout"].is_a?(Array)
          create_page_layout_views(page)
        else
          page
        end
      end.flatten!
    end

    def create_page_layout_views(page)
      page.data["layout"].map do |layout|
        # TODO: dir is the string path between jekyll site repo root and page source file
        # Figure out a way to get dir without accessing the page's private `@dir` getter. That's just bad.
        dir = get_page_dir(page)
        new_page = Page.new(page.site, page.site.source, dir, page.name)
        new_page.data["layout"] = layout
        new_page.data["permalink"] = get_adjusted_permalink(page, layout)
        new_page
      end
    end

    #  Collections
    # ==================================================================

    def generate_collection_item_layouts(site)
      site.collections.each do |_, collection|
        collection.docs.map! do |document|
          if document.data["layout"].is_a?(Array)
            create_document_layout_views(site, collection, document)
          else
            document
          end
        end.flatten!
      end
    end

    def create_document_layout_views(site, collection, document)
      document.data["layout"].map do |layout|
        doc = Document.new(document.path, {
          :site => site,
          :collection => collection
        })
        doc.data["layout"] = layout
        doc.data["permalink"] = get_adjusted_permalink(document, layout)
        doc
      end
    end

    #  Helpers
    # ==================================================================

    def get_adjusted_permalink(resource, layout)
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

    def get_page_dir(page)
      # Don't do this. This is awful. Don't ever do this. Why am I doing this?
      page.instance_variable_get(:@dir)
    end
  end
end
