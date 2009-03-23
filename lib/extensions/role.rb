module MegaSimpleAuthorization
  module Extensions
    
    module RoleExtensions
      def self.included( recipient )
        recipient.extend( ClassMethods )
        include MegaSimpleAuthorization::Extensions::RoleExtensions::InstanceMethods
      end
      
      module ClassMethods
        
        def acts_as_simple_role
          has_and_belongs_to_many :users
        end
        
      end
      
      module InstanceMethods              
      end
      
    end

  end
end

