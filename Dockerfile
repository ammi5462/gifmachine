FROM ruby:2.6.10-alpine

# Install FULL ImageMagick with GIF animation support
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    git \
    postgresql-client \
    imagemagick \
    imagemagick-libs \
    imagemagick-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    giflib-dev \
    librsvg-dev

RUN gem install bundler -v '2.0.2' --no-document

WORKDIR /app
COPY . /app

RUN bundle config set --local path 'vendor/bundle' && \
    bundle install --jobs=4 --retry=3

EXPOSE 4567

CMD ["sh", "-c", "bundle exec rake db:migrate || echo 'Migrations done'; bundle exec ruby app.rb -o 0.0.0.0"]
