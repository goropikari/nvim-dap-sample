# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.0
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y build-essential

# Rails app lives here
WORKDIR /rails

# Copy application code
COPY . .

RUN bundle install

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000 12345
CMD rdbg -n -O --port 12345 -c -- bundle exec rails server -p 3000 -b 0.0.0.0
