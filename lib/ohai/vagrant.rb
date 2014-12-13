Ohai.plugin(:VboxIpaddress) do

  provides 'ipaddress'

  depends 'ipaddress'
  depends 'network/interfaces'
  depends 'virtualization/system'
  depends 'etc/passwd'

  # Ohai hint
  unless File.exist?('/etc/chef/ohai_plugins/vagrant.json')
    Chef::Log.fail('Ohai has not set :ipaddress (Missing vagrant.json)')
    return
  end
  vagrant = JSON.parse(IO.read('/etc/chef/ohai_plugins/vagrant.json'))

  # requested nit
  nic = vagrant['primary_nic']
  if nic.nil?
    Chef::Log.debug('nic not set for vagrant-ohai plugin. Skipping')
    return
  end

  collect_data(:default) do
    if etc['passwd'].any? { |k, _v| k == 'vagrant' }
      if network['interfaces'][nic] && virtualization['system'] == 'vbox'
        network['interfaces'][nic]['addresses'].each do |ip, params|
          if params['family'] == ('inet')
            ipaddress ip
            Chef::Log.info("Ohai override :ipaddress to #{ip} from #{nic}")
          end
        end
      end
    end
  end
end
