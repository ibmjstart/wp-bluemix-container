FROM wordpress:latest

# JSON Parsing utility (shell)
ADD https://raw.githubusercontent.com/dominictarr/JSON.sh/master/JSON.sh /usr/local/bin/JSON.sh
RUN chmod u+x /usr/local/bin/JSON.sh

# Uses JSON.sh to parse and return VCAP_SERVICES
COPY vcap_parse.sh /vcap_parse.sh
RUN chmod u+x /vcap_parse.sh

# Uses vcap_parse.sh to export db credentials
COPY vcap_export.sh /vcap_export.sh
RUN chmod u+x /vcap_export.sh

# Override the Wordpress:latest Entrypoint
ENTRYPOINT ["/vcap_export.sh"] 