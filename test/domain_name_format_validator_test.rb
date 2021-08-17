require "minitest/autorun"
require_relative 'test_helper'

# 
# Domain Name Syntax (https://en.wikipedia.org/wiki/Domain_Name_System)
#
# The definitive descriptions of the rules for forming domain names appear in RFC 1035, RFC 1123, RFC 2181, and RFC 5892. A domain name consists of one or more parts, technically called labels, that are conventionally concatenated, and delimited by dots, such as example.com.
#
# The right-most label conveys the top-level domain; for example, the domain name www.example.com belongs to the top-level domain com.
#
# The hierarchy of domains descends from right to left; each label to the left specifies a subdivision, or subdomain of the domain to the right. For example, the label example specifies a subdomain of the com domain, and www is a subdomain of example.com. This tree of subdivisions may have up to 127 levels.[26]
#
# A label may contain zero to 63 characters. The null label, of length zero, is reserved for the root zone. The full domain name may not exceed the length of 253 characters in its textual representation.[1] In the internal binary representation of the DNS the maximum length requires 255 octets of storage, as it also stores the length of the name.[3]
#
# Although no technical limitation exists to prevent domain name labels using any character which is representable by an octet, hostnames use a preferred format and character set. The characters allowed in labels are a subset of the ASCII character set, consisting of characters a through z, A through Z, digits 0 through 9, and hyphen. This rule is known as the LDH rule (letters, digits, hyphen). Domain names are interpreted in case-independent manner.[27] Labels may not start or end with a hyphen.[28] An additional rule requires that top-level domain names should not be all-numeric.[28]
#
# The limited set of ASCII characters permitted in the DNS prevented the representation of names and words of many languages in their native alphabets or scripts. To make this possible, ICANN approved the Internationalizing Domain Names in Applications (IDNA) system, by which user applications, such as web browsers, map Unicode strings into the valid DNS character set using Punycode. In 2009 ICANN approved the installation of internationalized domain name country code top-level domains (ccTLDs). In addition, many registries of the existing top-level domain names (TLDs) have adopted the IDNA system, guided by RFC 5890, RFC 5891, RFC 5892, RFC 5893.
#
# EOF WIKIPEDIA
#
# it seems to be okay to have a tld of 63 characters: https://tools.ietf.org/html/rfc1034
#

class DomainNameFormatValidatorTest < Minitest::Test
  def setup
    @debug = false
  end

 def is_valid_domain?(domain)
   puts domain if @debug
   DomainNameFormatValidator.valid?(domain)
 end


  def test_if_label_bigger_as_63_chars_allowed
    # exactly 65 characters in total
    domain = 'a'*62 + ".com"
    assert is_valid_domain?(domain)
    # exactly 63 characters in hostname
    domain = 'a'*63 + '.' + 'b'*63 + '.' + 'c'*63
    assert is_valid_domain?(domain)
    # 64 characters in hostname
    domain = 'a'*64 + ".com"
    refute is_valid_domain?(domain)
    # 64 characters inbetween
    domain = 'abc.' + 'b'*64 + ".com"
    refute is_valid_domain?(domain)
  end

  def test_if_label_is_zero
    domain = "www.example..com"
    refute is_valid_domain?(domain)
  end

  def test_nil_is_not_allowed
    refute is_valid_domain?(nil)
  end

  def test_empty_string_is_not_allowed
    refute is_valid_domain?("")
  end

  def test_all_numeric_tld_is_not_allowed
    assert is_valid_domain?("example.xn--zfr164b")
    refute is_valid_domain?("example.123")
  end

  def test_tld_is_too_short
    refute is_valid_domain?("example.a")
  end

  def test_period_at_the_beginning_is_not_allowed
    refute is_valid_domain?(".example.com")
  end

  def test_fail_when_max_number_of_levels_is_exceeded
    domain = "a."*127 + "com"
    refute is_valid_domain?(domain)
  end

  def test_if_label_does_not_start_or_end_with_hiphen
    # hyphens in beween are allowed
    domain = "my-example.com"
    assert is_valid_domain?(domain)
    # hyphens at the beginning are not allowed
    domain = "-example.com"
    refute is_valid_domain?(domain)
    # hyphens at the end are not allowed
    domain = "example-.com"
    refute is_valid_domain?(domain)
    # hyphens at the beginning of tld are not allowed
    domain = "example.-com"
    refute is_valid_domain?(domain)
    # hyphens at the end of tld are not allowed
    domain = "example.com-"
    refute is_valid_domain?(domain)
  end

  def test_if_entire_hostname_is_not_bigger_than_253
    domain = 'a'*63 + '.' + 'b'*63 + '.' + 'c'*63 + '.' + 'd'*58 + '.com'
    refute is_valid_domain?(domain)
  end

  def test_if_underscore_allowed
    assert is_valid_domain?('_jabber.example.com')
    assert is_valid_domain?('_jabber.example_.com')
    assert is_valid_domain?('_jabber_._exa-mple_.com')
    refute is_valid_domain?('_jabber_.example_._com')
    refute is_valid_domain?('_jabber_.example_.com_')
    assert is_valid_domain?('_jabber_.example_.co-m')
  end

  def test_opendnsrandomlist
    File.foreach("test/opendns-random-domains.txt") {
      |each_line| 
      assert is_valid_domain?(each_line.chomp) 
    }
  end

  def test_top_level_domains
    File.foreach("test/tlds-alpha-by-domain.txt") {
      |each_line| 
      unless each_line =~ /^.*#/
          assert is_valid_domain?( "example." + each_line.chomp.downcase) 
      end
    }
  end

  def test_invalid_characters
    # 45 is '-' and 46 is '.'
    for i in 0..44
      domain = "www.exa" + i.chr + "ample.com"
      refute is_valid_domain?(domain)
    end

    # 48 is '0'
    i = 47
    domain = "www.exa" + i.chr + "ample.com"
    refute is_valid_domain?(domain)

    # 65-90 is A-Z
    for i in 58..64
      domain = "www.exa" + i.chr + "ample.com"
      refute is_valid_domain?(domain)
    end  

    # 95 is '_'
    for i in 91..94
      domain = "www.exa" + i.chr + "ample.com"
      refute is_valid_domain?(domain)
    end

    # 97 is 'a'
    i = 96
    domain = "www.exa" + i.chr + "ample.com"
    refute is_valid_domain?(domain)

    for i in 123..127
      domain = "www.exa" + i.chr + "ample.com"
      refute is_valid_domain?(domain)
    end
  end

  def test_umlauts_domains
    domains = [
      "xn--dmin-moa0i.example.com",
      "xn--aaa-pla.example.com",
      "xn--aaa-qla.example.com",
      "xn--aaa-rla.example.com",
      "xn--aaa-sla.example.com",
      "xn--dj-kia8a.vu.example.com",
      "xn--efran-2sa.example.com",
      "xn--and-6ma2c.example.com",
      "foo.xn--bcdf-9na9b.example.com",
      "xn--4gbrim.xn----ymcbaaajlc6dj7bxne2c.xn--wgbh1c",
      "xn--n3h.example.com",
      "xn--fuball-cta.example.com"
    ]

    domains.each do |d|
      assert is_valid_domain?(d)
    end
  end


  def test_regex_bypass
    domain = "www.example.com\n; <script>alert('xss')</script>"
    refute is_valid_domain?(domain)
  end
end
