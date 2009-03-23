require File.dirname(__FILE__) + '/extensions/role'
require File.dirname(__FILE__) + '/extensions/user'

# Main module for authentication.  
# Include this in ApplicationController to activate SimpleAuthorization
#
# See RoleSecurityClassMethods for some methods it provides.
module MegaSimpleAuthorization

  def self.included(klass)
    klass.send :class_inheritable_accessor, :authorization_access_information
    klass.send :include, RoleSecurityInstanceMethods
    klass.send :extend, RoleSecurityClassMethods
    klass.send :helper_method, :has_role? 
    klass.send :authorization_access_information=, {}
  end

  module RoleSecurityClassMethods
  
    # authorization_access_information - hash of actions and roles
    # {
    #   :index => [:admin, :moderator],
    #   :edit => [:admin]
    # }
    def define_access(authorization_access_information)
      self.authorization_access_information = authorization_access_information
      before_filter :check_authorization_access
    end
    
  end

  module RoleSecurityInstanceMethods
    
    def has_role?(role_name, current_user = current_user )
      if current_user
        current_user.has_role?(role_name)
      else
        false
      end
    end
    
    # For future some notes
    #respond_to do |format|
    #  format.html do
    #    store_location
    #    redirect_to new_user_session_path
    #  end
      # format.any doesn't work in rails version < http://dev.rubyonrails.org/changeset/8987
      # Add any other API formats here.  Some browsers send Accept: */* and 
      # trigger the 'format.any' block incorrectly.
    #  format.any(:json, :xml) do
    #    request_http_basic_authentication 'Web Password'
    #  end
    #end    
  
    # stub, see application controller
    def access_denied_due_to_role
      if current_user
        render :text => "Insufficient rights!"
        return false
      else
        super
      end
    end
    
    def check_authorization_access
      return true unless authorization_access_information[params[:action]]
      return access_denied_due_to_role unless current_user
      user_roles = current_user.roles.collect{ |role| role.name }
      return access_denied_due_to_role unless authorization_access_information[params[:action]].any? { |action_role| user_roles.include?(action_role) }
      true
    end
  
  end


end