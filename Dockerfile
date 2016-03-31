FROM wordpress:latest

# Given the limitation of being unable to change ownership of the files on a mounted volume

# Overwrite the entrypoint script with a fork that works around the volume mount permissions by
# 1. commenting out some chmod statements that would fail
# 2. updating the tar command to disable same-owner setting
# 3. adding chmod command to grant root group write access to wordpress files
COPY bluemix-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
# Note: I also folded in env var initialization from VCAP_SERVICES as well

# Add the www-data to the root group to work with wordpress files on volume
RUN usermod -a -G root www-data
# See https://github.com/docker/docker/issues/2259, https://github.com/docker/docker/issues/7198
# Also https://github.com/docker-library/wordpress/issues/97, https://github.com/docker-library/wordpress/issues/132

# Same entrypoint and cmd but docker/ibm containers seems to want us to repeat
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
