class Theme < ActiveRecord::Base
  attr_accessor :type
  attr_accessor :url
  attr_accessor :name

  def self.installed
    Dir.entries(Rails.public_path / 'themes').map do |theme|
      next if theme =~ /^\.+(DS_Store)?$/ || File.file?(theme)
      Theme.new :name => File.basename(theme)
    end.compact
  end

  def self.find(theme)
    new :name => theme
  end
  
  def self.columns(*args)
    []
  end
  
  def to_s
    name
  end
  
  def name
    @name ||= File.basename(url.to_s, '.git')
  end
  
  def templates
    Dir.chdir(Rails.public_path / 'themes' / name) do
      Dir.glob('*.html.erb').map do |template|
        # Skip partials
        next if template.starts_with?('_')
        File.basename(template) if File.file?(template)
      end.compact
    end
  end
  
  def install
    `git clone #{url} #{Rails.public_path / 'themes' / name}`
  end
  
  def update
    `cd "#{Rails.public_path / 'themes' / name}" && git pull origin master`
  end
  
  def destroy
    FileUtils.remove_dir(Rails.public_path / 'themes' / name, true)
  end
end