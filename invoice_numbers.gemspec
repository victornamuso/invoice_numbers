Gem::Specification.new do |s|
  s.name             = 'invoice_numbers'
  s.version          = '0.1.3'

  s.authors          = [ 'Rob Scheepmaker' ]
  s.email            = 'rob@rscheepmaker.nl'
  s.date             = '2012-02-07'
  s.description      = 'Create sequences of uninterrupted invoice numbers'
  s.summary          = 'Create sequences of uninterrupted invoice numbers'
  s.extra_rdoc_files = [ 'README.rdoc' ]

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  s.rdoc_options     = ['--main', 'README.rdoc']
  s.require_paths    = ['lib']
  s.test_files       = FileList['test/*.rb'].to_a
  s.add_development_dependency 'activerecord', ['>= 0']
  s.add_development_dependency 'mongoid', ['>= 0']
  s.add_development_dependency 'database_cleaner', ['>= 0']
end
