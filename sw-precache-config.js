/**
 * @license
 * Copyright (c) 2016 The Polymer Project Authors. All rights reserved.
 * This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
 * The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
 * The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
 * Code distributed by Google as part of the polymer project is also
 * subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
 */

/* eslint-env node */

module.exports = {
    staticFileGlobs: [
        'bower_components/webcomponentsjs/webcomponents-loader.js',
        'manifest.json',
        'bower_components/**',
        'src/*',
    ],
    runtimeCaching: [
        {
            urlPattern: /\/(\w+\/)?bower_components\/webcomponentsjs\/.*.js/,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'webcomponentsjs-polyfills-cache',
                },
            },
        },
        {
            urlPattern: /\/(\w+\/)?index\.html/,
            handler: 'networkFirst',
            options: {
                cache: {
                    name: 'index-cache',
                },
            },
        },
        {
            urlPattern: /\/(\w+\/)?src\/my-app\.html/,
            handler: 'networkFirst',
            options: {
                cache: {
                    name: 'appshell-cache',
                },
            },
        },
        {
            urlPattern: /\/(\w+\/)?bower_components\/.*/,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'bowercomponents-cache',
                },
            },
        },
        {
            urlPattern: /\/(\w+\/)?src\/.*/,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'src-cache',
                },
            },
        },
        {
            urlPattern: /\/.*/,
            handler: 'networkFirst',
            options: {
                cache: {
                    name: 'local-fallback-cache',
                },
            },
        },
        {
            urlPattern: /https?:\/\/((cdn\.)?rawgit\.com|raw\.githubusercontent\.com\/[\w-]+\/[\w-]+\/[\w-]+)\/temak\.tsv/,
            handler: 'networkFirst',
            options: {
                cache: {
                    name: 'temaktsv-cache',
                },
            },
        },
        {
            urlPattern: /https?:\/\/((cdn\.)?rawgit\.com|raw\.githubusercontent\.com\/[\w-]+\/[\w-]+\/[\w-]+)\/(.*\.tsv|.*SUMS)/,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'metadata-cache',
                },
            },
        },
        {
            urlPattern: /https?:\/\/((cdn\.)?rawgit\.com|raw\.githubusercontent\.com\/[\w-]+\/[\w-]+\/[\w-]+)\/.*\.(txt|pas|cpp)/,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'textdata-cache',
                    maxAgeSeconds: 60 * 60 * 24 * 30,
                },
            },
        },
        {
            urlPattern: /https?:\/\/((cdn\.)?rawgit\.com|raw\.githubusercontent\.com\/[\w-]+\/[\w-]+\/[\w-]+)\/.*/,
            handler: 'networkOnly',
            options: {
                cache: {
                    name: 'fallback-gh-cache',
                },
            },
        },
        {
            urlPattern: /.*/,
            handler: 'networkOnly',
            options: {
                cache: {
                    name: 'fallback-cache',
                },
            },
        },
    ],
};
