if defined?(ChefSpec)
  {
    rbenv_system_install: [:install, :upgrade, :remove, :purge]
  }.each do |resource, actions|
    actions.each do |action|
      define_method("#{action}_#{resource}") do |name|
        ChefSpec::Matchers::ResourceMatcher.new(resource, action, name)
      end
    end
  end
end
