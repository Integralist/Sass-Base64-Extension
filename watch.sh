#!/bin/sh

#sass --style expanded --watch styles.scss:styles.css --debug-info -r ./sass/url64.rb
#sass --style compressed --watch styles.scss:styles.css -r ./sass/url64.rb

sass --style expanded --watch styles.scss:styles.css --debug-info -r ./sass/url64.rb

exit 0