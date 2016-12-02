application "" do
  path "/usr/local/helloworld"
  owner node["tomcat"]["user"]
  group node["tomcat"]["group"]
  repository "http://web-actions.googlecode.com/files/helloworld.war"
  revision "does this mater"
  java_webapp do
    context_template "hello-context.xml.erb"
  end
  tomcat
end

application "gitblit" do
  path "/tmp/webapps/gitblit"
  owner "tomcat6"
  group "tomcat6"

#  repository "git://github.com/gitblit/gitblit.git"
#  revision "master"

  repository "http://gitblit.googlecode.com/files/gitblit-1.0.0.war"
  revision "be46d9bad598e658b5e48135ba1b19674d70447c511ff878286d388577618ba3"

  java_webapp
  
  tomcat
end