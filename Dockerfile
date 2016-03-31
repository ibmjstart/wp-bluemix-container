FROM wordpress:latest

# Given the limitation of being unable to change ownership of the files on a mounted volume
# 1. overwrite the entrypoint script with a fork that comments out some chmod statements that would fail
COPY bluemix-entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh
# 2. add the www-data to the root group (and grant the group write privilege via the entrypoint)
RUN usermod -a -G root www-data
# 3. add group write so that the www-data user can write to the wordpress dirs owned by root
# also, use setguid so that new files will inherit the same rights
RUN chmod g+ws /var/www/html
# See https://github.com/docker/docker/issues/2259, https://github.com/docker/docker/issues/7198
# Also https://github.com/docker-library/wordpress/issues/97, https://github.com/docker-library/wordpress/issues/132

# Script to the WORDPRESS environment variables from the credentials passed by Bluemix
# This needs to execute when the container starts instead of when you build the image
# because the VCAP_SERVICES variables are set by the Bluemix platform
COPY setenv.sh /setenv.sh
RUN chmod u+x /setenv.sh

# Tell WordPress that updates should be installed via the "direct" method
# despite that the can_write_to check will fail because files are created under root on the volume
# See http://stackoverflow.com/questions/640409/can-i-install-update-wordpress-plugins-without-providing-ftp-access#answer-5650020
ENV FS_METHOD direct

# Set the environment before calling the normal entrypoint
ENTRYPOINT ["setenv.sh",";","/entrypoint.sh"]
# Keep the same CMD as the original (repeated since ENTRYPOINT can reset this)
CMD ["apache2-foreground"]
