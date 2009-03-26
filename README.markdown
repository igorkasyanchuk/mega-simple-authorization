- Introduction
- Installation
- Available Methods

Mega Simple Authorization Plugin
============================

###*Simple role authorization plugin*

Simple Authorization allows easy role authorization functionality.

#### User (add "acts\_as\_simply\_authorized\_user" to the User model)

    @user.has_role?[:manager, :editor, :admin]
    @user.has_role :admin
    @user.has_no_role :admin

The User gets these "has" methods by adding `acts_as_simply_authorized_user` to the User model.

Why another Authorization plugin?
---------------------------------

Because I need simple authorization that works with Authlogic.

Installation
==========================

Installation of this plugin takes about 2 minutes.

    1. Install the plugin into vendor/plugins
    2. run "script/generate mega_simple_authorization" to create the Role model, migrations and views
    3. run "rake db:migrate" to create the roles and roles_users tables
    4. Add "include MegaSimpleAuthorization" to your application.rb file
    5. Add "acts_as_simply_authorized_user" to your User model
    
You're all set!

### Dependencies

It needs a `current_user` method that holds a user object.
It also needs an `access_denied_due_to_role` method, so that it knows where to send/show a user should they be denied access to a page.

The `current_user` method are provided by default in restful-authentication/Authlogic.
The `access_denied_due_to_role` method defined in plugin and can be overriden in ApplicationController.

####Sample of access_denied_due_to_role`:
	  def access_denied_due_to_role
		respond_to do |format|
		   format.html do
			 render :template => 'app/views/mega_simple_authorization/access_denied.html.erb'
		   end
		   format.js do
			 render :template => 'app/views/mega_simple_authorization/access_denied.js.rjs'
		   end
		end
	  end

Available Methods
==================================

Sample of usage in your controller
-----------------------------------
    class UsersController < ApplicationController
      define_access({
        "index" => ["admin"],
        "new" => ["superadmin"]
      })
      
      def index
        ...
      end
      
      def new
        ...
      end
      
      # other actions
      ....
    end
#### Method define_access recieve hash of actions as keys and array with roles as values. By default all actios are enabled for users.

User Extensions
-----------------------------------

#### These methods become available when `acts_as_simply_authorized_user` is added to the User model.

### Associations

    roles

This will scope the roles down to those owned by the User.

    Examples:
    @user.roles

---

### Instance Methods

**Check for existence of a role or roles on an object:**

    has_role?( role_names )

**Create a role on an object:**

    has_role( role_name )

---
    
**Remove a single role that a user has on an object:**

    has_no_role( role_name )

---