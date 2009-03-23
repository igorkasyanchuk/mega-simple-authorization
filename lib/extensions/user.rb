module MegaSimpleAuthorization
  module Extensions

    module UserExtensions
      def self.included( recipient )
        recipient.extend( ClassMethods )
        recipient.send :include, MegaSimpleAuthorization::Extensions::UserExtensions::InstanceMethods 
      end

      module ClassMethods
        def acts_as_simply_authorized_user
          has_and_belongs_to_many :roles
        end
      end

      module InstanceMethods
        def has_role?( role_names )       
          prepare_role_names(role_names).each do |role_name| 
            role = get_role( role_name )
            if role
              return true if self.roles.exists?( role.id ) 
            end
          end
          return false
        end
        
        # This (user) has this (role)
        # Assign a role to user
        # @user.has_role :admin
        def has_role( role_name )
          role_name = role_name.to_s
          role = get_role( role_name )          
          role = Role.create( :name => role_name ) if role.nil?
          self.roles << role if role and not self.roles.exists?( role.id )
        end

        # This (user) does not have this (role)
        # @user.has_no_role :admin
        def has_no_role( role_name )
          role_name = role_name.to_s
          role = get_role( role_name )
          delete_role( role )
        end
        
        private
        # convert role names to array and names within to strings if not already
        def prepare_role_names(role_names)
          Array(role_names).collect! {|role_name| role_name.to_s }   
        end
        
        def get_role( role_name )
          Role.find_by_name role_name
        end

        def delete_role( role ) 
          if role
            self.roles.delete( role )
            role.destroy if role.users.empty?
          end
        end

      end
    end

  end
end

