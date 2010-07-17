class AddressMigrationGenerator < Rails::Generator::NamedBase
  def manifest
    record do |m|
       m.migration_template 'migration.rb', 'db/migrate', :migration_file_name => "address_migration"
    end
  end
end
