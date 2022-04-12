FROM thevlang/vlang:alpine

COPY . /build/

RUN v install --git 'https://github.com/jdonnerstag/vlang-yaml'

RUN v -prod /build -o /openapi2cli

CMD [ "/openapi2cli" ]