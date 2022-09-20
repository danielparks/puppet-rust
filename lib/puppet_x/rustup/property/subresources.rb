# frozen_string_literal: true

require_relative 'set'

# Property classes for rustup
module PuppetX::Rustup::Property
  # A list of subresources
  #
  # This is a list of hashes that correspond to sub-resources. It expects each
  # hash to have, at the least, a 'title' entry that identifies it uniquely
  # within this list of resources, and an 'ensure' entry that contains either
  # 'absent' or something else that will be interpreted as not-absent.
  class Subresources < Set
    # Get the identity of the entry.
    #
    # This is akin to the title of a resource. It should uniquely identify this
    # entry within in the set. If two entries have the same identity, then it
    # is an error.
    def entry_identity(entry)
      entry.reject { |k| k == 'absent' }.hash
    end

    # Does this entry in `should` have the equivalent of `ensure => absent`?
    #
    # This is used to determine if there is a change. If this returns `true` and
    # there is no corresponding entry in `is`, then it will _not_ be considered
    # a change.
    def should_entry_absent?(entry)
      entry['ensure'] == 'absent'
    end

    # Do any normalization required for an entry in `should`.
    #
    # Return the normalized entry or `nil` to skip it.
    #
    # This clones entry and passes it to `normalize_should_entry!`. Unless you
    # need to return `nil`, you should override that function.
    def normalize_should_entry(entry)
      cloned = entry.clone
      normalize_should_entry!(cloned)
      cloned
    end

    # Do any normalization required for an entry in `is`.
    #
    # Return the normalized entry or `nil` to skip it. If an entry has the
    # equivalent of `ensure => absent`, this should return `nil`.
    #
    # This clones entry and passes it to `normalize_is_entry!`. Unless you need
    # to return `nil`, you should override that function.
    def normalize_is_entry(entry)
      cloned = entry.clone
      normalize_is_entry!(cloned)
      cloned
    end

    # Do any normalization required for an entry in `should`.
    #
    # This should modify the parameter.
    def normalize_should_entry!(_entry); end

    # Do any normalization required for an entry in `is`.
    #
    # This should modify the parameter.
    def normalize_is_entry!(_entry); end
  end
end