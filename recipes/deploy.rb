deploy '/var/lib/tomcat/webapps' do
  # Use a local repo if you prefer
  repo '/tmp/ServletDBLog4jExample.war'
  action :deploy
  restart_command '/etc/init.d/tomcat restart'
  #create_dirs_before_symlink  %w{tmp public config deploy}

  # You can use this to customize if your app has extra configuration files
  # such as amqp.yml or app_config.yml
  #symlink_before_migrate  'config/database.yml' => 'config/database.yml'

  # If your app has extra files in the shared folder, specify them here
  
end