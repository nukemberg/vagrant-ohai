Ohai.plugin(:VboxIpaddress) do

  def read_json(filename)
    if defined? FFI_Yajl::Parser
      FFI_Yajl::Parser.new.parse(IO.read(filename))
    else
      require 'json'
      JSON.parse(IO.read(filename))
    end
  end

  def lookup_address_by_nic(network, nic)
    if network['interfaces'][nic]
      network['interfaces'][nic]['addresses'].each do |ip, params|
        if params['family'] == ('inet')
          return [nic, ip]
        end
      end
    end
    return [nil, nil]
  end

  def lookup_address_by_ipaddress(network, ip)
    nic = network['interfaces'].find do |nic, nic_info|
      nic_info['addresses'].select {|addr, addr_info| addr_info['family'] == 'inet'}.keys.include?(ip)
    end
    if nic
      return [nic, ip]
    end
    return [nil, nil]
  end

  provides 'ipaddress'

  depends 'ipaddress'
  depends 'network'
  depends 'network/interfaces'
  depends 'virtualization/system'
  depends 'etc/passwd'

  collect_data(:default) do
  # Ohai hint
    unless File.exist?('/etc/chef/ohai_plugins/vagrant.json')
      Ohai::Log.fail('Ohai has not set :ipaddress (Missing vagrant.json)')
    else
      vagrant = read_json('/etc/chef/ohai_plugins/vagrant.json')

      # requested nit
      nic = vagrant['primary_nic']
      if etc['passwd'].keys.include?('vagrant') && virtualization['system'] == 'vbox'
        if nic
          nic, addr = lookup_address_by_nic(network, nic)
        elsif vagrant['private_ipv4']
          nic, addr = lookup_address_by_ipaddress(network, vagrant['private_ipv4'])
        else
          nic, addr = nil, nil
          Ohai::Log.info("Neither nic nor private_ipv4 are set, skipping")
        end
        if addr
          Ohai::Log.info("Ohai override :ipaddress to #{addr} from #{nic}")
          ipaddress addr
        end
      end
    end
  end
end
