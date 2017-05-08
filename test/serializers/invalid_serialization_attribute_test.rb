module ActiveModel
  class Serializer
    class InvalidSerializationAttributeTest < ActiveSupport::TestCase
      class Author < ActiveModelSerializers::Model
        attributes :id, :name
      end

      test 'exception is raised when attribute is an explicitly defined method requiring arguments' do
        serialized_class = Class.new(ActiveModel::Serializer) do
          attributes :id, :name, :method_with_args

          def method_with_args(args)
            "method"
          end
        end

        exception = assert_raises(RuntimeError) do
          serialized_class.new(Author.new(id: 1, name: "Author")).as_json
        end

        assert_equal('Invalid attribute name: method_with_args', exception.message)
      end

      test 'exception is raised when attribute is a method requiring arguments defined in a superclass' do
        serialized_class = Class.new(ActiveModel::Serializer) do
          attributes :id, :name, :method
        end

        exception = assert_raises(RuntimeError) do
          serialized_class.new(Author.new(id: 1, name: "Author")).as_json
        end

        assert_equal('Invalid attribute name: method', exception.message)
      end
    end
  end
end
