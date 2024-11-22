FROM ruby:3.1.6

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs curl

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler --no-document
RUN bundle install

ENV PATH /app/vendor/bundle/ruby/3.1.0/bin:$PATH

COPY . .

EXPOSE 3000

CMD ["sh", "-c", "rm -f tmp/pids/server.pid && bundle exec rails server -b 0.0.0.0"]
