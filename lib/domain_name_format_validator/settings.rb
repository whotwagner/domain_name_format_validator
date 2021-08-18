# frozen_string_literal: true

# Some constants and error-codes for DomainNameFormatValidator
# are defined here
module DomainNameFormatValidator
  MAX_DOMAIN_LENGTH = 253
  MAX_LABEL_LENGTH = 63
  MAX_LEVELS = 127
  MAX_TLD_LENGTH = 63
  MIN_LEVELS = 2
  MIN_TLD_LENGTH = 2

  ERRS = {
    bogus_tld: "Malformed TLD: Could not possibly match any valid TLD",
    illegal_chars: "Domain label contains an illegal character",
    illegal_start: "No domain name may start with a period",
    label_dash_begin: "No domain label may begin with a dash",
    label_dash_end: "No domain label may end with a dash",
    max_domain_size: "Maximum domain length of 253 exceeded",
    max_label_size: "Maximum domain label length of 63 exceeded",
    max_level_size: "Maximum domain level limit of 127 exceeded",
    min_level_size: "Minimum domain level limit of 2 not achieved",
    top_numerical: "The top-level domain (TLD) cannot be numerical",
    top_illegal_chars: "The top-level domain (TLD) must only contain a-z 0-9 and -",
    zero_size: "Zero-length domain name"
  }.freeze
end
