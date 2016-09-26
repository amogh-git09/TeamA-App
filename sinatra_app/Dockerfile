FROM ruby:2.3.1-alpine

RUN mkdir /app
ADD . /app
WORKDIR /app
RUN apk add --no-cache --virtual build-dependencies make gcc g++ mariadb-dev libxml2-dev libxslt-dev ruby-dev
RUN gem install bundler io-console
RUN bundle install -j4 --path vendor/bundle
EXPOSE 3000
CMD ["bundle", "exec", "ruby", "app.rb", "--port", "3000", "-E", "production"]
