require 'puppet-strings/tasks'
require 'puppetlabs_spec_helper/rake_tasks'
require 'rspec/core/rake_task'

# DISABLED LINT CHECKS
# http://puppet-lint.com/checks/

# Arrow alingment leads to larger changesets if you add a parameter which is longer than the others
PuppetLint.configuration.send('disable_arrow_alignment')

# Useless, i see no advantage
PuppetLint.configuration.send('disable_trailing_whitespace')

task :default => [:spec, :lint]
