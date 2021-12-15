FROM ruby:2.7-alpine

RUN apk update \
    && apk add --virtual=build-deps --no-cache build-base icu-dev openssl-dev cmake \
    && apk add --virtual=runtime-deps --no-cache openssh icu-libs git git-lfs

WORKDIR /tmp

COPY Gemfile .
COPY gollum.gemspec .
RUN bundle install \
    && gem install commonmarker creole
RUN apk del build-deps

WORKDIR /opt/gollum

COPY . .
RUN bundle exec rake install

WORKDIR /var/lib/gollum

ENV PATH="/opt/gollum/bin:$PATH"
ENTRYPOINT ["gollum"]
