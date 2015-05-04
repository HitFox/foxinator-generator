module Routify
  extend ActiveSupport::Concern

 included do
   helper_method :current_namespace, :current_parent
   
   def namespaces
     self.class.namespaces
   end
 end

 private
 
 def current_parent
   parent if respond_to?(:parent, true)
 end
 
 def current_namespace
   namespaces.first
 end
  
 module ClassMethods
   def current_namespace
     namespaces.first
   end

   def namespaces
     name.split('::').slice(0...-1).map(&:underscore).map(&:to_s)
   end
 end
end
