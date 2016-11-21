require 'yaml'

module Bot
  class Config
    def initialize(file)
      @config = YAML.load_file file
      @config.keys.each do |key|
        self.class.send(:define_method, key) do
          @config[key]
        end
      end
    end
  end
end