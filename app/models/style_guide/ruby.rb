# Determine Ruby style guide violations per-line.
module StyleGuide
  class Ruby < Base
    BASE_CONFIG_FILE = "config/style_guides/ruby.yml"
    CUSTOM_CONFIG_FILE = ".ruby-style.yml"

    def violations_in_file(file)
      if config.file_to_exclude?(file.filename)
        []
      else
        team.inspect_file(parsed_source(file)).map do |violation|
          line = file.line_at(violation.line)

          Violation.new(
            filename: file.filename,
            patch_position: line.patch_position,
            line: line,
            line_number: violation.line,
            messages: [violation.message]
          )
        end
      end
    end

    private

    def team
      RuboCop::Cop::Team.new(RuboCop::Cop::Cop.all, config)
    end

    def parsed_source(file)
      RuboCop::ProcessedSource.new(file.content, file.filename)
    end

    def config
      @config ||= RuboCopConfig.new(merged_config, "")
    end

    def merged_config
      RuboCop::ConfigLoader.merge(base_config, custom_config)
    rescue TypeError
      base_config
    end

    def base_config
      RuboCop::ConfigLoader.load_file(BASE_CONFIG_FILE)
    end

    def custom_config
      if File.file?(CUSTOM_CONFIG_FILE)
        RuboCop::ConfigLoader.load_file(CUSTOM_CONFIG_FILE)
      else
        RuboCop::Config.new
      end
    end
  end
end
