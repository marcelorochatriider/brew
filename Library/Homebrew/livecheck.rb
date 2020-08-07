# frozen_string_literal: true

# Livecheck can be used to check for newer versions of the software.
# The livecheck DSL specified in the formula is evaluated the methods
# of this class, which set the instance variables accordingly. The
# information is used by brew livecheck when checking for newer versions
# of the software.
class Livecheck
  # The reason for skipping livecheck for the formula.
  # e.g. `Not maintained`
  attr_reader :skip_msg

  def initialize(formula)
    @formula = formula
    @regex = nil
    @skip = false
    @skip_msg = nil
    @strategy = nil
    @url = nil
  end

  # Sets the regex instance variable to the argument given, returns the
  # regex instance variable when no argument is given.
  def regex(pattern = nil)
    case pattern
    when nil
      @regex
    when Regexp
      @regex = pattern
    else
      raise TypeError, "Livecheck#regex expects a Regexp"
    end
  end

  # Sets the skip instance variable to true, indicating that livecheck
  # must be skipped for the formula. If an argument is given and present,
  # its value is assigned to the skip_msg instance variable, else nil is
  # assigned.
  def skip(skip_msg = nil)
    if skip_msg.is_a?(String)
      @skip_msg = skip_msg
    elsif skip_msg.present?
      raise TypeError, "Livecheck#skip expects a String"
    end

    @skip = true
  end

  # Should livecheck be skipped for the formula?
  def skip?
    @skip
  end

  # Sets the strategy instance variable to the provided symbol or returns the
  # strategy instance variable when no argument is provided. The strategy
  # symbols use snake case (e.g., `:page_match`) and correspond to the strategy
  # file name.
  # @param symbol [Symbol] symbol for the desired strategy
  def strategy(symbol = nil)
    case symbol
    when nil
      @strategy
    when Symbol
      @strategy = symbol
    else
      raise TypeError, "Livecheck#strategy expects a Symbol"
    end
  end

  # Sets the url instance variable to the argument given, returns the url
  # instance variable when no argument is given.
  def url(val = nil)
    @url = case val
    when nil
      return @url
    when :head, :stable, :devel
      @formula.send(val).url
    when :homepage
      @formula.homepage
    when String
      val
    else
      raise TypeError, "Livecheck#url expects a String or valid Symbol"
    end
  end

  # Returns a Hash of all instance variable values.
  def to_hash
    {
      "regex"    => @regex,
      "skip"     => @skip,
      "skip_msg" => @skip_msg,
      "strategy" => @strategy,
      "url"      => @url,
    }
  end
end
