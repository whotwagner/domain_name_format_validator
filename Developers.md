For Developers Only
===================

Building and testing the domain_name_validator gem is pretty easy. 

Gemspec
-------

The gemspec file for the gem, domain_name_validator.gemspec, is an active
file containing Ruby code. In other words, the gemspec file itself has code
to figure out what files should be included in the gem, etc. Each time a
release is done, the only thing that needs to be edited is the "gem.date"
property.

Version
-------

The version number is defined in the version.rb file, located in the lib
directory tree. The version number should be bumped up in some fashion with
each release. Version numbers often have 3 digits, e.g. - 1.2.3. The left-most
number is a release, followed by a sub-release and a patch. All versions
within a release should generally be backwards compatible. A sub-release 
generally include significant new features, whilea patch is generally a minor
update (often a bug fix).

The gemspec file automatically picks up the version number from the version.rb
file, so make sure you keep it updated properly.

Testing the Code
----------------

Testing the code is simple. Run the following command from the top level
of the gem's directory tree:

      $ rake test

Lists for testing domains and top-level-domains
-----------------------------------------------

The following lists were downloaded in order to perform tests with existing
domains and top level domains:

* https://raw.githubusercontent.com/opendns/public-domain-lists/master/opendns-random-domains.txt

* https://data.iana.org/TLD/tlds-alpha-by-domain.txt 

Testing for styling issues
--------------------------

This gem was setup with rubocop. Run the following command from the top level
of the gem's directory tree:

     $ rake rubocop

Creating the Gem
----------------

To create the gem file for this gem, run the following command from the top
level of the gem's directory tree:

      $ gem build domain_name_validator.gemspec

Pushing to RubyGems
-------------------

Obviously, you can only do this step if you've got the appropriate privileges
at RubyGems.org and everything is properly configured.

      $ gem push domain_name_validator.gem

