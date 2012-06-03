#
# Cookbook Name:: users
# Recipe:: sysadmins
#
# Copyright 2011, Eric G. Wolfe
# Copyright 2009-2011, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# ruby-shadow is needed to manage passwords.  This is a pain because:
#  1. It's a native module, so we need a toolchain if we can't install from
#     a package.
#  2. When using the Omnibus installer, we can't (cleanly) add this with a
#     package.
#
# This recipe assumes that I'm only using 0.10.8 from packages on ubuntu,
# and that anything else is an omnibus installer on a node with a toolchain
# already installed.

if node['chef_packages']['chef']['version'] == "0.10.8"
  package "libshadow-ruby1.8" do
    action :nothing
  end.run_action :install

  # Pick up the newly installed package
  Gem.clear_paths
else
  chef_gem "ruby-shadow" do
    action :install
  end
end

# Searches data bag "users" for groups attribute "sysadmin".
# Places returned users in Unix group "sysadmin" with GID 2300.
users_manage "sysadmin" do
  group_id 2300
  action [ :remove, :create ]
end

users_manage "sudo" do
  group_id 27
  action [ :remove, :create ]
end
