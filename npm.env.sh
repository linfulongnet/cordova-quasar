setConfig () {
    $1 config set registry http://registry.npm.taobao.org/
    $1 config set sass_binary_site https://npm.taobao.org/mirrors/node-sass/
    $1 config set disturl https://npm.taobao.org/mirrors/node/
    $1 config set sharp_dist_base_url https://npm.taobao.org/mirrors/sharp-libvips/v8.9.1/
    $1 config set electron_mirror https://npm.taobao.org/mirrors/electron/
    $1 config set puppeteer_download_host https://npm.taobao.org/mirrors/
    $1 config set phantomjs_cdnurl https://npm.taobao.org/mirrors/phantomjs/
    $1 config set sentrycli_cdnurl https://npm.taobao.org/mirrors/sentry-cli/
    $1 config set sqlite3_binary_site https://npm.taobao.org/mirrors/sqlite3/
    $1 config set python_mirror https://npm.taobao.org/mirrors/python/
}

setConfig npm

setConfig yarn

