ActiveRecord::Base.send( :include,
      MegaSimpleAuthorization::Extensions::RoleExtensions,
      MegaSimpleAuthorization::Extensions::UserExtensions
    )