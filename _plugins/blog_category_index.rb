module Jekyll
    #  +site+         is the Jekyll Site instance.
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
  class BlogCategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'blog_category_index.html')
      self.data['type'] = category
      

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"

    end
  end

  class BlogCategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'blog_category_index'
        dir = site.config['category_dir'] || ''
        site.categories.each_key do |blog_category|
          if (blog_category.split("/")[0] == 'blog')
            #puts blog_category
            site.pages << BlogCategoryPage.new(site, site.source, File.join(dir, blog_category), blog_category)
          end
        end

      end
    end
  end

end