name              "riak-cs-create-admin-user"
maintainer        "Hector Castro"
maintainer_email  "hectcastro@gmail.com"
license           "Apache 2.0"
description       "Creates and configures an administrator for Riak CS."
version           "0.3.1"
recipe            "riak-cs-create-admin-user", "Configures an administrator for Riak CS"

%w{riak riak-cs}.each do |d|
  depends d
end

%w{ubuntu centos}.each do |os|
  supports os
end
