// noinspection JSUnusedGlobalSymbols
// noinspection JSCheckFunctionSignatures
const preferences = new Proxy({
    ghUser: "lezsakdomi",
    ghRepo: "elte-mester-data",
    ghTag: "master",
    useCdn: true,
    useRawgitEverywhere: true,
    preferredCodeLang: "cpp",
    searchLimit: 50
}, {
    prefix: 'preferences.',
    storage: window.localStorage,
    observers: {},
    get: function (target, p, receiver) {
        // noinspection JSUnusedGlobalSymbols
        const propMethods = {
            default: p => {
                return target[p];
            },
            get: p => {
                if (this.storage) {
                    const item = this.storage.getItem(this.prefix + p);
                    if (item) {
                        return JSON.parse(item);
                    }
                }
                return receiver.default(p);
            },
            set: (p, value) => {
                if (this.storage) {
                    this.storage.setItem(this.prefix + p, JSON.stringify(value));
                    this.changed(p, value, receiver);
                }
                return receiver.get(p);
            },
            reset: p => {
                if (this.storage) {
                    this.storage.removeItem(this.prefix + p);
                    this.changed(p, receiver.default(p), receiver);
                }
                return receiver.get(p);
            },
            observe: (p, callback) => {
                if (!(p in this.observers)) this.observers[p] = [];
                return this.observers[p].push(callback);
            },
            clearObserver: (p, id) => {
                const result = this.observers[p];
                this.observers[p][id] = null;
                return result;
            },
            clearObservers: p => {
                const result = this.observers[p];
                this.observers[p] = undefined;
                return result;
            }
        };

        if (p === '_handlers') return this;

        if (p in propMethods) {
            return propMethods[p].bind(this);
        }

        if (typeof p === "string") {
            if (p.startsWith('default')) {
                const prop = p[7].toLowerCase() + p.slice(8);
                return target[prop];
            }

            for (let methodName in propMethods) {
                if (typeof methodName !== "string") continue;

                if (p.startsWith(methodName)) {
                    const prop = p[methodName.length].toLowerCase() +
                        p.slice(methodName.length + 1);
                    return (...args) => propMethods[methodName].call(this, prop, ...args);
                }
            }
        }

        {
            if (!(p in target)) {
                throw new Error("Preference " + p + " does not exists. Please use get(" + p +
                    ") to discard this error silently.");
            }
            return receiver.get(p);
        }
    },
    set: function (target, p, value, receiver) {
        return receiver.set(p, value);
    },
    changed: function (p, newValue, receiver) {
        if (this.observers[p] !== undefined) {
            this.observers[p].forEach(observer => {
                if (observer != null) {
                    observer.call(receiver, newValue, p);
                }
            });
        }
    }
});
window.addEventListener('storage', event => {
    // noinspection JSUnresolvedVariable
    if (event.key.startsWith(preferences._handlers.prefix)) {
        // noinspection JSUnresolvedVariable
        const key = event.key.slice(preferences._handlers.prefix.length);
        // noinspection JSUnresolvedVariable
        preferences._handlers.changed(key,
            event.newValue !== null ? JSON.parse(event.newValue) : preferences.default(key),
            preferences);
    }
});

class TSV extends CSV {
    constructor(string) {
        super(string, {
            cellDelimiter: "\t",
            lineDelimiter: "\n",
            header: true
        });
    }
}

const fetchTemaCSV = new Promise.Deferred((init, resolve, reject) => {
    readFile("temak.tsv")
        .then(value => new TSV(value))
        .then(resolve, reject);
}, false);

const generateLazyTree = fetchTemaCSV.then(csv => {
    let result = {};
    csv.forEach(record => {
        if (result[record.szint] === undefined) result[record.szint] = {};
        result[record.szint][record.tema] = record.id;
    });
    return result;
});

class NotImplementedError extends Error {
    constructor(method, superObject = undefined) {
        // noinspection JSCheckFunctionSignatures
        super("You should implement " + method +
            (superObject ? " when extending " + superObject.constructor : ""));
    }
}

let allThings = [];

class Thing {
    constructor(name) {
        this.name = name;

        allThings.push(this);
    }

    static get _baseUrl() {
        return "https://github.com/lezsakdomi/elte-mester-data/tree/master";
    }

    static get _ghFetchBase() {
        return "https://" + (preferences.useCdn ? "rawcdn.githack.com" : "raw.githack.com") + "/" +
            preferences.ghUser + "/" + preferences.ghRepo + "/" + preferences.ghTag + "/";
    }

    static get _rawBaseUrl() {
        return preferences.useRawgitEverywhere
            ? Thing._ghFetchBase
            : "https://raw.githubusercontent.com/lezsakdomi/elte-mester-data/master";
    }

    static async fetchFile(path) {
        if (path instanceof Array) {
            path = path
                .map(component => encodeURIComponent(component).replace('%2F', '/'))
                .join('/');
        }
        const url = Thing._ghFetchBase + path.replace(/^\//, "");
        const response = await fetch(url);
        if (response.ok) {
            return response;
        } else {
            throw new Error("Fetch for " + url + " failed: Returned " + response.status + " ("
                + response.statusText + ")");
        }
    }
}

async function readFile(path) {
    const response = await Thing.fetchFile(path);
    return await response.text();
}

let allEntries = [];

class Entry extends Thing {
    constructor(name) {
        super(name);

        this.fetchDescription = this._createFetchDescriptionDeferred();
        this.description = undefined;
        this.fetchDescription.then(description => this.description = description);

        allEntries.push(this);
    }

    get _descriptionPath() {
        throw NotImplementedError('get _descriptionPath', this);
    }

    // noinspection JSUnusedGlobalSymbols
    get url() {
        throw NotImplementedError('get url', this);
    }

    // noinspection JSUnusedGlobalSymbols
    get rawUrl() {
        throw NotImplementedError('get rawUrl', this);
    }

    _createFetchDescriptionDeferred() {
        return new Promise.Deferred((init, resolve, reject) => {
            readFile(this._descriptionPath).then(resolve, reject);
        }, false);
    }
}

let allFeladat = [];

class Feladat extends Entry {
    constructor(tema, id, name, nehezseg) {
        super(name);
        this.tema = tema;
        this.id = id;
        this.nehezseg = nehezseg;

        allFeladat.push(this);
    }

    get _descriptionPath() {
        return [this.tema.name, this.name, "feladat.txt"];
    }

    // noinspection JSUnusedGlobalSymbols
    get url() {
        return this.tema.url + "/" + encodeURIComponent(this.name);
    }

    get rawUrl() {
        return this.tema.rawUrl + "/" + encodeURIComponent(this.name);
    }

    // noinspection JSUnusedGlobalSymbols
    get pdfUrl() {
        return this.rawUrl + "/feladat.pdf";
    }

    // noinspection JSUnusedGlobalSymbols
    get mintaUrl() {
        return this.rawUrl + "/minta.zip";
    }
}

class MintaFeladat extends Feladat {
    constructor(tema) {
        super(tema, 0, tema.name + " mintafeladat", "kidolgozott");
    }

    get _descriptionPath() {
        return [this.tema.name, "mintafeladat.txt"];
    }

    get url() {
        return this.pdfUrl;
    }

    get rawUrl() {
        return undefined;
    }

    get mintaUrl() {
        return undefined;
    }

    // noinspection JSUnusedGlobalSymbols
    get pdfUrl() {
        return this.tema.rawUrl + "/mintafeladat.pdf";
    }

    // noinspection JSUnusedGlobalSymbols
    get cppUrl() {
        return this.tema.url + "/feladat.cpp";
    }

    // noinspection JSUnusedGlobalSymbols
    get pasUrl() {
        return this.tema.url + "/feladat.pas";
    }

    // noinspection JSUnusedGlobalSymbols
    get codeUrl() {
        return this[preferences.preferredCodeLang + "Url"];
    }
}

let allTema = [];

class Tema extends Entry {
    constructor(id, name, szint) {
        super(name);
        this.id = id;
        this.szint = szint;

        this.fetchFeladatList = new Promise.Deferred((init, resolve, reject) => {
            readFile([name, "flist.tsv"])
                .then(value => new TSV(value))
                .then(csv => {
                    // noinspection JSUnresolvedFunction
                    return csv.map(
                        record => new Feladat(this, record.id, record.feladat, record.nehezseg));
                })
                .then(resolve, reject);
        }, false);

        this.mintafeladat = new MintaFeladat(this);

        allTema.push(this);
    }

    // noinspection JSUnusedGlobalSymbols
    get url() {
        return Thing._baseUrl + "/" + encodeURIComponent(this.name);
    }

    get rawUrl() {
        return Thing._rawBaseUrl + "/" + encodeURIComponent(this.name);
    }

    get _descriptionPath() {
        return [this.name, "leiras.txt"];
    }
}

class Szint extends Thing {
    constructor(name, lazyTree) {
        super(name);
        this.lazyTree = lazyTree;
    }

    get temaList() {
        return Object.entries(this.lazyTree).map(([name, id]) => new Tema(id, name, this));
    }

    get temaSet() {
        return new Set(this.temaList);
    }
}

const generateRealTree = generateLazyTree.then(
    tree => new Set(Object.keys(tree).map(szint => new Szint(szint, tree[szint])))
);
let realTree;
generateRealTree.then(value => realTree = value);

const generateTemaSet = generateRealTree.then(
    tree => new Set(
        [...tree].reduce((accumulator, value) => accumulator.concat([...value.temaSet]), []))
);

const fetchAllTemaDescription = new Promise.Deferred((init, resolve, reject) => {
    generateTemaSet.run(init).then(temaSet => {
        let temaList = [...temaSet];
        Promise.all(temaList.map(tema => tema.fetchDescription.run()))
            .then(fetchedDescriptions => {
                resolve(fetchedDescriptions.map((fetchedDescription, index) =>
                    [fetchedDescription, temaList[index]]
                ));
            }, reject);
    }, reject);
}, false);

const fetchAllMintafeladatDescription = new Promise.Deferred((init, resolve, reject) => {
    generateTemaSet.run(init).then(temaSet => {
        let feladatList = [...temaSet].map(tema => tema.mintafeladat);
        Promise.all(feladatList.map(feladat => feladat.fetchDescription.run().catch(reason => {
            console.error(new Error(reason));
        }))).then(fetchedDescriptions => {
            resolve(fetchedDescriptions.map((fetchedDescription, index) =>
                [fetchedDescription, feladatList[index]]
            ));
        }, reject);
    }, reject);
}, false);

const generateFeladatSet = new Promise.Deferred((init, resolve, reject) => {
    generateTemaSet.run(init).then(
        temaSet => Promise.all([...temaSet].map(tema => tema.fetchFeladatList.run()))
            .then(feladatListList =>
                new Set(
                    feladatListList.reduce((accumulator, value) => accumulator.concat(value), []))
            ).then(resolve, reject),
        reject);
}, false);

const fetchAllFeladatDescription = new Promise.Deferred((init, resolve, reject) => {
    generateFeladatSet.run(init).then(feladatSet => {
        let feladatList = [...feladatSet];
        Promise.all(feladatList.map(feladat => feladat.fetchDescription.run().catch(reason => {
            console.error(new Error(reason));
        }))).then(fetchedDescriptions => {
            resolve(fetchedDescriptions.map((fetchedDescription, index) =>
                [fetchedDescription, feladatList[index]]
            ));
        }, reject);
    }, reject);
}, false);