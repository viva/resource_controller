require File.dirname(__FILE__)+'/test_helper'
require 'resource_controller/block_accessor'
require 'attributes'

class BlockAccessorTest < Test::Unit::TestCase
  def setup
    PostsController.class_eval do
      extend ResourceController::BlockAccessor
    end
  end
  
  context "scoping reader" do
    setup do
      PostsController.class_eval do
        class_scoping_reader :create, ResourceController::ActionOptions.new
      end
    end
  
    should "access create as usual" do
      PostsController.class_eval do
        create.flash "asdf"
      end
    
      assert_equal "asdf", PostsController.create.flash
    end
  
    should "scope to create object in a block" do
      PostsController.class_eval do
        create do
          flash "asdf"
        end
      end

      assert_equal "asdf", PostsController.create.flash 
    end
  end
  
  context "reader/writer method" do
    setup do
      PostsController.class_eval do
        reader_writer :flash
      end
      
      @controller = PostsController.new
    end

    should "set and get var" do
      @controller.flash "something"
      assert_equal "something", @controller.flash
    end
  end
  
end