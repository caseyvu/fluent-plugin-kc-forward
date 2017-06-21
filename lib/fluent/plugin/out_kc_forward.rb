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
        if @security.shared_key_file.nil?
          raise Fluent::ConfigError, "both shared_key and shared_key_file are null"
        end

        # Reading shared_key from file
        content = File.open(@security.shared_key_file, 'r') { |f| f.read.strip }
        temp = Fluent::Config::Section.new(params={shared_key: content})
        @security = @security + temp

        # Need to fix the shared_key of @nodes
        node_names = @nodes.map {|n| n.name }
        new_nodes = []
        @servers.each do |server|
          failure = FailureDetector.new(@heartbeat_interval, @hard_timeout, Time.now.to_i.to_f)
          name = server.name || "#{server.host}:#{server.port}"
          if node_names.include? name
            if @heartbeat_type == :none
              new_nodes << NoneHeartbeatNode.new(self, server, failure: failure)
            else
              new_nodes << Node.new(self, server, failure: failure)
            end
          end
        end
        @nodes = new_nodes

      end
    end
  end

  def write(chunk)
    super
  end

  def start
    super
  end
end
