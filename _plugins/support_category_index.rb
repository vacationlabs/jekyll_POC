module Jekyll
    #  +site+         is the Jekyll Site instance.
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
  class SupportCategoryPage < Page
    def initialize(site, base, dir, category)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'support_category_index.html')
      self.data['category'] = category
      

      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"

    end
  end

  class SupportCategoryPageGenerator < Generator
    safe true

    def generate(site)
      if site.layouts.key? 'support_category_index'
        dir = site.config['category_dir'] || ''
        site.categories.each_key do |support_category|
          if (support_category.split("/")[0] == 'support')
            #puts support_category
            site.pages << SupportCategoryPage.new(site, site.source, File.join(dir, support_category), support_category)
          end
        end

      end
    end
  end

end