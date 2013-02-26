Sass-Base64-Extension
=====================

Created an extension to Sass that adds a function to let the user convert a URL into an inline data uri

This script works around IE8's 32kb restriction on data uri's.

To ensure the extension is added to Sass you'll need to pass through the name of the script to Sass when running the watch command, like so… 

```sh
sass --style expanded --watch styles.scss:styles.css -r ./sass/url64.rb
```