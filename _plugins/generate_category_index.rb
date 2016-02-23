module Jekyll
    #  +site+         is the Jekyll Site instance.
    #  +base+         is the String path to the <source>.
    #  +category_dir+ is the String path between <source> and the category folder.
    #  +category+     is the category currently being processed.
  class GenerateCategoryPage < Page
    def initialize(site, base, dir, category, layout_name)
      @site = site
      @base = base
      @dir = dir
      @name = 'index.html'
      
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), layout_name)
      #puts layout_name
      self.data['category_name'] = category
      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
      self.data['title'] = "#{category_title_prefix}#{category}"
    end

  end

  class SupportCategoryPageGenerator < Generator
    safe true

    def generate(site)

      dir = site.config['category_dir'] || ''    

      # for creating all the category index of support page
      site.data['support-category-types'].each do |support_category|
        site.pages << GenerateCategoryPage.new(site, site.source, File.join(dir, support_category["category_name"]), support_category["category_name"],'support_category_index.html')
      end

       # for creating all the category index of blog page
      site.data['blog-types'].each do |blog_category|
        site.pages << GenerateCategoryPage.new(site, site.source, File.join(dir, blog_category["type"]), blog_category["type"],'blog_category_index.html')
      end


    end
  end

end