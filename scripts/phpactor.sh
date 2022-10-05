# composer
cd /usr/local/bin \
    && wget -O composer-setup.php https://getcomposer.org/installer \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Phpactor
mkdir /usr/local/src/phpactor \
    && chown $USERNAME:$USERNAME /usr/local/src/phpactor \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" git clone --depth 1 https://github.com/phpactor/phpactor /usr/local/src/phpactor \
    && cd /usr/local/src/phpactor \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" composer update \
    && sudo -E -u $USERNAME -s "PATH=$PATH" "HOME=/home/$USERNAME" composer install
