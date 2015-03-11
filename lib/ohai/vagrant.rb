Ohai.plugin(:VagrantIp) do

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
  depends 'network/interfaces'
  depends 'virtualization/system'
  depends 'etc/passwd'

  collect_data(:default) do
    vagrant = hint?('vagrant')
    unless vagrant
      Ohai::Log.fail('Ohai has not set :ipaddress (Missing vagrant.json)')
    else
      nic = vagrant['primary_nic']
      if etc['passwd'].keys.include?('vagrant')
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
