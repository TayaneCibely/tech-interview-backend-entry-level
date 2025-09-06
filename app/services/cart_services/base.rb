module CartServices
  class Base
    attr_reader :success, :errors, :error, :status

    def initialize
      @success = false
      @errors = []
      @error = nil
      @status = :unprocessable_entity
    end

    def self.call(*args)
      new.call(*args)
    end

    def success?
      @success
    end

    private

    def success!
      @success = true
    end

    def add_error(message, status = :unprocessable_entity)
      @errors << message
      @error = message
      @status = status
    end
  end
end