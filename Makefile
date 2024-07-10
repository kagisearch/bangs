.PHONY: install
install:
	bundle install

.PHONY: test
test: install
	bundle exec rspec
