# Copyright (C) 2001  Daiki Ueno <ueno@unixuser.org>
# This library is distributed under the terms of the Ruby license.

# This module is a backport of Ruby 1.9's HMAC, which is built into 1.9 to the gem version required by various libs.

# Source repository is at
#
#   http://github.com/zmalltalker/ruby-hmac/tree/master

module HMAC

  VERSION = '0.3.3'

  class Base
    def initialize(algorithm, block_size, output_length, key)
      @hmac = Digest::HMAC.new(key, algorithm)
      # @algorithm = algorithm
      # @block_size = block_size
      # @output_length = output_length
      # @initialized = false
      # @key_xor_ipad = ''
      # @key_xor_opad = ''
      # set_key(key) unless key.nil?
    end

    private
    def check_status
      # unless @initialized
      #   raise RuntimeError,
      #   "The underlying hash algorithm has not yet been initialized."
      # end
    end

    public
    def set_key(key)
      # If key is longer than the block size, apply hash function
      # to key and use the result as a real key.
      # key = @algorithm.digest(key) if key.size > @block_size
      # key_xor_ipad = "\x36" * @block_size
      # key_xor_opad = "\x5C" * @block_size
      # for i in 0 .. key.size - 1
      #   key_xor_ipad[i] ^= key[i]
      #   key_xor_opad[i] ^= key[i]
      # end
      # @key_xor_ipad = key_xor_ipad
      # @key_xor_opad = key_xor_opad
      # @md = @algorithm.new
      # @initialized = true
    end

    def reset_key
      @hmac.reset
      # @key_xor_ipad.gsub!(/./, '?')
      # @key_xor_opad.gsub!(/./, '?')
      # @key_xor_ipad[0..-1] = ''
      # @key_xor_opad[0..-1] = ''
      # @initialized = false
    end

    def update(text)
      @hmac.update(text)
      # check_status
      # # perform inner H
      # md = @algorithm.new
      # md.update(@key_xor_ipad)
      # md.update(text)
      # str = md.digest
      # # perform outer H
      # md = @algorithm.new
      # md.update(@key_xor_opad)
      # md.update(str)
      # @md = md
    end
    alias << update

    def digest
      @hmac.hexdigest
      # check_status
      # @md.digest
    end

    def hexdigest
      # check_status
      @hmac.hexdigest
    end
    alias to_s hexdigest

    # These two class methods below are safer than using above
    # instance methods combinatorially because an instance will have
    # held a key even if it's no longer in use.
    def Base.digest(key, text)
      begin
        hmac = self.new(key)
        hmac.update(text)
        hmac.digest
      ensure
        hmac.reset_key
      end
    end

    def Base.hexdigest(key, text)
      begin
        hmac = self.new(key)
        hmac.update(text)
        hmac.hexdigest
      ensure
        hmac.reset_key
      end
    end

    private_class_method :new, :digest, :hexdigest
  end
end
