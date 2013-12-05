ruby_block "trigger-delayed-restarts" do
  block { }
  notifies :restart, "service[riak]", :immediately
  notifies :restart, "service[stanchion]", :immediately
  notifies :restart, "service[riak-cs]", :immediately

  if node.recipe?("riak-cs::control")
    notifies :restart, "service[riak-cs-control]", :immediately
  end
end

ruby_block "create-admin-user" do
  block do
    admin_key, admin_secret = RiakCS.create_admin_user(
      node["riak_cs_create_admin_user"]["name"],
      node["riak_cs_create_admin_user"]["email"],
      node["riak_cs"]["config"]["riak_cs"]["cs_ip"].gsub(/__string_/, ""),
      node["riak_cs"]["config"]["riak_cs"]["cs_port"]
    )

    Chef::Log.info "Riak CS Key: #{admin_key}"
    Chef::Log.info "Riak CS Secret: #{admin_secret}"

    node.run_state["riak_cs_admin_key"] = admin_key
    node.run_state["riak_cs_admin_secret"] = admin_secret

    riak_cs_config = node["riak_cs"]["config"].to_hash
    riak_cs_config = riak_cs_config.merge(
      "riak_cs" => riak_cs_config["riak_cs"].merge(
        "admin_key" => admin_key.to_erl_string,
        "admin_secret" => admin_secret.to_erl_string,
        "anonymous_user_creation" => false
      )
    )
    riak_cs_file = resources(:file => "#{node['riak_cs']['package']['config_dir']}/app.config")
    riak_cs_file.content Eth::Config.new(riak_cs_config).pp

    stanchion_config = node["stanchion"]["config"].to_hash
    stanchion_config = stanchion_config.merge(
      "stanchion" => stanchion_config["stanchion"].merge(
        "admin_key" => admin_key.to_erl_string,
        "admin_secret" => admin_secret.to_erl_string
      )
    )
    stanchion_file = resources(:file => "#{node['stanchion']['package']['config_dir']}/app.config")
    stanchion_file.content Eth::Config.new(stanchion_config).pp

    if node.recipe?("riak-cs::control")
      riak_cs_control_config = node["riak_cs_control"]["config"].to_hash
      riak_cs_control_config = riak_cs_control_config.merge(
        "riak_cs_control" => riak_cs_control_config["riak_cs_control"].merge(
          "cs_admin_key" => admin_key.to_erl_string,
          "cs_admin_secret" => admin_secret.to_erl_string
          )
        )
      riak_cs_control_file = resources(:file => "#{node['riak_cs_control']['package']['config_dir']}/app.config")
      riak_cs_control_file.content Eth::Config.new(riak_cs_control_config).pp
    end

    node.set["riak_cs"]["config"]["riak_cs"]["anonymous_user_creation"] = false
  end

  retries 5
  retry_delay 3
  notifies :create, "file[#{node['stanchion']['package']['config_dir']}/app.config]", :immediately
  notifies :create, "file[#{node['riak_cs']['package']['config_dir']}/app.config]", :immediately

  if node.recipe?("riak-cs::control")
    notifies :create, "file[#{node['riak_cs_control']['package']['config_dir']}/app.config]", :immediately
  end

  only_if { node["riak_cs"]["config"]["riak_cs"]["anonymous_user_creation"] }
end
