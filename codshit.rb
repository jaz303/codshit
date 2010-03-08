module Codshit
  
  module Chooseable
    def |(other)
      Codshit::Choice.new(*(self.choices + other.choices))
    end

    def choices
      [self]
    end
  end
  
  class Choice
    attr_reader :choices
    
    def initialize(*choices)
      @choices = choices
    end
    
    def |(right)
      self.class.new(*(choices + right.choices))
    end
    
    def to_text
      @choices[rand(@choices.length)].to_text
    end
    
    def <<(c)
      @choices << c
    end
  end
  
  class Generator
    
    @@active_generator = nil
    def self.active_generator
      @@active_generator
    end
    
    def initialize(&block)
      @rules = {}
      instance_eval(&block)
    end
    
    def [](rule)
      @rules[rule]
    end
    
    def method_missing(method, *args, &block)
      @rules[method] ||= Rule.new
    end
    
    def generate
      @@active_generator = self
      @rules[:main].to_text
    end
  end
  
  class Rule
    def initialize
      @is = Choice.new
    end
    
    def is(*stuff)
      if block_given?
        @is << Choice.new(yield)
      else
        @is << stuff
      end
    end
    
    def define(&block)
      instance_eval(&block)
    end
    
    def to_text
      @is.to_text
    end
  end
  
end

class String
  include Codshit::Chooseable

  def to_text
    self
  end
end

class Symbol
  include Codshit::Chooseable
  
  def to_text
    Codshit::Generator.active_generator[self].to_text
  end
end

class Array
  def |(other)
    ::Codshit::Choice.new(*(choices + other.choices))
  end
  
  def choices
    [dup]
  end
  
  def to_text
    map { |p| p.to_text }.join('')
  end
end
