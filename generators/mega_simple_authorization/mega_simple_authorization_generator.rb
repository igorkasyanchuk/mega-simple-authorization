class MegaSimpleAuthorizationGenerator < Rails::Generator::Base
  def manifest
    record do |m|
      # model
      m.template 'app/models/role.rb', 'app/models/role.rb'
      
      m.directory 'app/views/mega_simple_authorization'
      m.file "app/views/mega_simple_authorization/access_denied.html.erb", "app/views/mega_simple_authorization/access_denied.html.erb"
      m.file "app/views/mega_simple_authorization/access_denied.js.rjs", "app/views/mega_simple_authorization/access_denied.js.rjs"
      
      # migration
      m.migration_template 'db/migrate/migration.rb', 'db/migrate', :migration_file_name => "create_mega_simple_authorization_roles"
    end
  end
end
