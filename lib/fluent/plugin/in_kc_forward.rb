require 'fluent/plugin/in_forward'

class Fluent::KCForwardInput < Fluent::Plugin::ForwardInput
  Fluent::Plugin.register_input('kc_forward', self)

  config_section :security, required: false, multi: false do
    desc 'Shared key for authentication'
    config_param :shared_key, :string, default: nil, secret: true
    desc 'File contains shared key for authentication'
    config_param :shared_key_file, :string, default: nil
  end

  def configure(conf)
    super

    if @security
      if @security.shared_key.nil?
        if @security.shared_key_file.nil?
          raise Fluent::ConfigError, "both shared_key and shared_key_file are null"
        end

        # Reading shared_key from file
        content = File.open(@security.shared_key_file, 'r') { |f| f.read.strip }
        temp = Fluent::Config::Section.new(params={shared_key: content})
        @security = @security + temp

        # Fixing the shared_key in @nodes
        @nodes.each do |node|
          if node.shared_key.nil?
            node[:shared_key] = content
          end
        end
      end
    end
  end

  def start
    super
  end
end
