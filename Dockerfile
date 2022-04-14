FROM thevlang/vlang:alpine

COPY . /build/

RUN v install --git 'https://github.com/jdonnerstag/vlang-yaml'
RUN v install --git 'https://github.com/BenStigsen/prettyprint'

RUN v -prod /build -o /openapi2cli

ENTRYPOINT [ "/openapi2cli" ]