require 'fluent/plugin/out_forward'

class Fluent::KCForwardOutput < Fluent::Plugin::ForwardOutput

  Fluent::Plugin.register_output('kc_forward', self)

  config_section :security, required: false, multi: false do
    desc 'Shared key for authentication'
    config_param :shared_key, :string, default: nil, secret: true
    desc 'Shared key file for authentication'
    config_param :shared_key_file, :string, default: nil
  end

  def configure(conf)
    super
    if @security
      if @security.shared_key.nil?
        unless @security.shared_key_file.nil?
          # Reading shared_key from file
          content = File.open(@security.shared_key_file, 'r') { |f| f.read.strip }
          temp = Fluent::Config::Section.new(params={shared_key: content})
          @security = @security + temp
        end
      end
    end
  end
end
