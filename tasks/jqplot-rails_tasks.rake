namespace :jqplot do
  desc "Install jQuery and jqPlot along with all plugins."
  task :install => :environment do
    create_directories

    ["jquery-1.3.2.min.js", "excanvas.min.js", ["jqplot", "jquery.jqplot.min.js"], ["jqplot", "plugins"]].each do |f|
      copy_file(f, "javascripts") 
    end

    [["jqplot", "jquery.jqplot.min.css"]].each do |f|
      copy_file(f, "stylesheets")
    end
  end

  def create_directories
    ["javascripts", "stylesheets"].each do |dir|
      full_dir = Rails.root.join("public", dir, "jqplot")
      FileUtils.mkdir(full_dir) unless File.exists?(full_dir)
    end
  end

  def copy_file(source, target)
    full_source = Rails.root.join("vendor", "plugins", "jqplot-rails", "assets", *Array(source))
    full_target = Rails.root.join("public", target, *Array(source))

    if File.exists?(full_target)
      puts "File #{full_target} exists. Skipping."
      return
    end

    FileUtils.cp_r(full_source, full_target)
  end
end
