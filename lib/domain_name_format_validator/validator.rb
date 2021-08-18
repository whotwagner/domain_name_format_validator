# frozen_string_literal: true

# The purpose of this class is to provide a simple capability for validating
# domain names represented in ASCII, a feature that seems to be missing or
# obscured in other more wide-ranging domain-related gems.
module DomainNameFormatValidator
  # Validates the proper formatting of a normalized domain name, i.e. - a
  # domain that is represented in ASCII. Thus, international domain names are
  # supported and validated, if they have undergone the required IDN
  # conversion to ASCII. The validation rules are:
  #
  # 1. The maximum length of a domain name is 253 characters.
  # 2. A domain name is divided into "labels" separated by periods. The maximum
  #    number of labels (including the top-level domain as a label) is 127.
  # 3. The maximum length of any label within a domain name is 63 characters.
  # 4. No label, including top-level domains, can begin or end with a dash.
  # 5. Top-level names cannot be all numeric.
  # 6. A domain name cannot begin with a period.

  # this internal function validates a single label
  # and is used by validate_parts?
  def self.validate_part?(part, errs = [])
    errs << ERRS[:max_label_size] if part.size > MAX_LABEL_LENGTH
    errs << ERRS[:label_dash_begin] if part[0] == "-"
    errs << ERRS[:label_dash_end] if part[-1] == "-"
    errs << ERRS[:illegal_chars] unless part.match(/\A[a-z0-9\-\_]+\Z/)
  end

  # This internal function validates the labels of a domain name
  def self.validate_parts?(parts, errs = [])
    errs << ERRS[:max_level_size] if parts.size > MAX_LEVELS
    errs << ERRS[:min_level_size] if parts.size < MIN_LEVELS
    errs << ERRS[:illegal_start] if parts.first[0] == "."
    parts.each do |part|
      validate_part?(part, errs)
    end
    errs
  end

  # this internal function validates the top level domain
  # if its nummerical only, if illegal characters occur
  # or if the length of the tld is not valid
  def self.validate_tld?(tld, errs = [])
    errs << ERRS[:top_numerical] if tld.match(/\A[0-9]+\Z/)
    errs << ERRS[:top_illegal_chars] unless tld.match(/\A[a-z0-9\-]+\Z/)
    errs << ERRS[:bogus_tld] if tld.size < MIN_TLD_LENGTH || tld.size > MAX_TLD_LENGTH
    errs
  end

  # This internal function validates the domain if its nil or zero
  def self.validate_args?(domain, errs = [])
    if domain.nil?
      errs << ERRS[:zero_size]
    else
      domain = domain.strip
      errs << ERRS[:zero_size] if domain.size.zero?
    end
    errs
  end

  # This function validates domain names and returns an array
  # with errors or an empty array if no error occurred.
  # see: https://github.com/dkeener/domain_name_validator/issues/6
  def self.errors(domain)
    errs = []
    errs = validate_args?(domain, errs)
    if errs.size.zero?
      errs << ERRS[:max_domain_size] if domain.size > MAX_DOMAIN_LENGTH
      parts = domain.downcase.split(".")
      errs = validate_parts?(parts, errs)
      errs = validate_tld?(parts.last, errs)
    end
    errs
  end

  # This function validates domain names and returns true or false
  def self.valid?(domain)
    errs = errors(domain)
    errs.size.zero?   # TRUE if valid, FALSE otherwise
  end
end
