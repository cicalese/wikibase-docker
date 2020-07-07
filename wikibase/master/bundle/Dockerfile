FROM ubuntu:xenial as fetcher

RUN apt-get update && \
    apt-get install --yes --no-install-recommends git unzip=6.* jq=1.* curl=7.* ca-certificates=201* && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY download-extension.sh .
ADD https://github.com/wikidata/WikibaseImport/archive/master.tar.gz /WikibaseImport.tar.gz
RUN tar xzf WikibaseImport.tar.gz && rm WikibaseImport.tar.gz
RUN bash download-extension.sh OAuth;\
bash download-extension.sh Elastica;\
bash download-extension.sh CirrusSearch;\
bash download-extension.sh WikibaseCirrusSearch;\
bash download-extension.sh UniversalLanguageSelector;\
bash download-extension.sh cldr;\
bash download-extension.sh EntitySchema;\
bash download-extension.sh WikibaseMediaInfo

FROM wikibase:master as collector
COPY --from=fetcher /WikibaseImport-master /var/www/html/extensions/WikibaseImport
COPY --from=fetcher /Elastica /var/www/html/extensions/Elastica
COPY --from=fetcher /OAuth /var/www/html/extensions/OAuth
COPY --from=fetcher /CirrusSearch /var/www/html/extensions/CirrusSearch
COPY --from=fetcher /WikibaseCirrusSearch /var/www/html/extensions/WikibaseCirrusSearch
COPY --from=fetcher /UniversalLanguageSelector /var/www/html/extensions/UniversalLanguageSelector
COPY --from=fetcher /cldr /var/www/html/extensions/cldr
COPY --from=fetcher /EntitySchema /var/www/html/extensions/EntitySchema
COPY --from=fetcher /WikibaseMediaInfo /var/www/html/extensions/WikibaseMediaInfo

FROM composer as composer
COPY --from=collector /var/www/html /var/www/html
WORKDIR /var/www/html/
RUN rm /var/www/html/composer.lock
RUN composer install --no-dev

FROM wikibase:master

RUN apt-get update && \
    apt-get install --yes --no-install-recommends jq=1.* && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=composer /var/www/html /var/www/html
COPY LocalSettings.php.wikibase-bundle.template /LocalSettings.php.wikibase-bundle.template
COPY extra-install.sh /
COPY extra-entrypoint-run-first.sh /
RUN cat /LocalSettings.php.wikibase-bundle.template >> /LocalSettings.php.template && rm /LocalSettings.php.wikibase-bundle.template
COPY oauth.ini /templates/oauth.ini
