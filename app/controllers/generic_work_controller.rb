class GenericWorkController < ApplicationController
  include ValkyrieControllerBehaviors

  def resource_class
    GenericWork
  end

end