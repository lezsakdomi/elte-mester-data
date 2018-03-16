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
        'src/**',
        'images/**',
        'index.html',
        'polyfills.js',
    ],
    runtimeCaching: [
        {
            urlPattern: /^\/bower_components\/webcomponentsjs\/.*\.js$/,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'webcomponentsjs-polyfills-cache',
                },
            },
        },
        {
            urlPattern: /^\/(index\.html)?$/,
            handler: 'networkFirst',
            options: {
                cache: {
                    name: 'index-cache',
                },
            },
        },
        {
            urlPattern: /^\/src\/my-app\.html$/,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'appshell-cache',
                },
            },
        },
        {
            urlPattern: /^\/bower_components\//,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'bowercomponents-cache',
                },
            },
        },
        {
            urlPattern: /^\/src\//,
            handler: 'fastest',
            options: {
                cache: {
                    name: 'src-cache',
                },
            },
        },
        {
            urlPattern: /^\//,
            handler: 'networkFirst',
            options: {
                cache: {
                    name: 'local-fallback-cache',
                },
            },
        },
        {
            urlPattern: /\/temak\.tsv$/,
            handler: 'networkFirst',
            options: {
                origin: /^https?:\/\/((cdn\.)?rawgit\.com|raw\.githubusercontent\.com)$/,
                cache: {
                    name: 'temaktsv-cache',
                },
            },
        },
        {
            urlPattern: /\.tsv$|\/\w+SUMS$/,
            handler: 'networkFirst',
            options: {
                origin: /^https?:\/\/((cdn\.)?rawgit\.com|raw\.githubusercontent\.com)$/,
                cache: {
                    name: 'metadata-cache',
                },
            },
        },
        {
            urlPattern: /\.(txt|pas|cpp)$/,
            handler: 'networkOnly',
            options: {
                origin: /^https?:\/\/((cdn\.)?rawgit\.com|raw\.githubusercontent\.com)$/,
                cache: {
                    name: 'textdata-cache',
                    maxAgeSeconds: 60 * 60 * 24 * 30,
                },
            },
        },
        {
            urlPattern: /.*/,
            handler: 'networkOnly',
            options: {
                origin: /https?:\/\/((cdn\.)?rawgit\.com|raw\.githubusercontent\.com)/,
                cache: {
                    name: 'fallback-gh-cache',
                },
            },
        },
        {
            urlPattern: /.*/,
            handler: 'networkOnly',
            options: {
                origin: /.*/,
                cache: {
                    name: 'fallback-cache',
                },
            },
        },
    ],
};
