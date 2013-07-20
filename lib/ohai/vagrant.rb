hints = hint?("vagrant")

provides "vagrant"
provides "cloud"

vagrant Mash.new 
cloud Mash.new

if hints
  vagrant.merge!(hints)
  require_plugin "cloud"
  if vagrant.has_key? :private_ipv4
    cloud[:local_ipv4] = vagrant[:private_ipv4]
    ipaddress vagrant[:private_ipv4]
  end
  cloud[:provider] = "vagrant"
end
