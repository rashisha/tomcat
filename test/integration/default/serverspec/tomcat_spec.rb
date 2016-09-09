require 'spec_helper'

describe file('/etc/init.d/tomcat7') do
  it { should be_file }
end

describe file('/var/lib//tomcat/conf/server.xml') do
  it { should exist }
end