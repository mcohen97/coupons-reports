FROM ruby:2.6.4

RUN mkdir /application
WORKDIR /application
COPY Gemfile /application/Gemfile
COPY Gemfile.lock /application/Gemfile.lock
RUN gem install bundler && bundle install
COPY . /application


# Set Rails environment to production
ENV RAILS_ENV production

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000


# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]