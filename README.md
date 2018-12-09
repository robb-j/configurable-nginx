# Configurable Nginx in Docker

This image is for single page apps (SPAs) so that you can pass environment variables from [docker](https://www.docker.com/) into your JavaScript

## Usage

This image requires a new variable `CONFIG_KEYS` to be set on your container, which should be a csv of the different environment variables you want passed in. It then inserts those variables into your JavaScript scope on `window.CONFIG.your_variable_here`.

### Key Notes

* Your `index.html` should be at `/usr/share/nginx/html/index.html`
* Your `index.html` should be minified
* In your `index.html`, it should have a `<head>` **directly** followed by a `<meta charset="utf-8">`
  * The script uses the `<meta>` tag to work out where to place your config
* This image is set up for an SPA using html history mode, nginx 404s are directed to your `index.html`

## An example

In your `docker-compose.yml` file:

```yml
environment:
  CONFIG_KEYS: HAS_HAT,NUMBER_OF_CARROTS
  HAS_HAT: 1
  NUMBER_OF_CARROTS: 42
```

Your `index.html` file:

```html
<html lang="en" dir="ltr">
  <head><meta charset="utf-8"></head>
  <body><script src="/index.js"></script></body>
</html>
```

In your client-side JavaScript, e.g. a `index.js` file:

```js
// Outputs: "1"
console.log(window.CONFIG.NUMBER_OF_CARROTS)
```

## How it works

This image works by injecting a tiny script tag at the top of your `index.html` file which sets `window.CONFIG` to the value of your injected variables.

Every time your container restarts this new script tag is replaced by a new version of itself, so the latest variables are always reflected.

## Current Limitations

* You must have `<head><meta charset` in your `index.html` which is used to position the new script tag
* There cannot be any return characters between the `<head>` and `<meta>` tags
* All variables passed through as string values
