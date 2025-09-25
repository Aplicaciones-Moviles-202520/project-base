# syntax=docker/dockerfile:1
# check=error=true

# ----------- Base stage -----------
ARG RUBY_VERSION=3.4.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

WORKDIR /rails

# Paquetes mínimos de runtime
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"

# ----------- Build stage -----------
FROM base AS build

# Paquetes para compilar gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libyaml-dev pkg-config nodejs npm && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Instala gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copia código Rails
COPY . .

# Precompila bootsnap (sin assets, porque es API)
RUN bundle exec bootsnap precompile app/ lib/

# ----------- Vite stage (frontend build) -----------
FROM node:22-bookworm AS vite
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm ci --omit=dev
COPY frontend ./
RUN npm run build   # genera dist/

# ----------- Final stage -----------
FROM base

# Copia gems y app
COPY --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
COPY --from=build /rails /rails

# Copia el build de Vite al public/ de Rails
COPY --from=vite /frontend/dist /rails/public

# Crear usuario no-root y asignar permisos
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp public
USER 1000:1000

# Entrypoint Rails
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Puerto documentado (default 3000, pero configurable vía $PORT)
EXPOSE 3000

# Arranque del servidor: se respeta $PORT en runtime
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "${PORT:-3000}"]
