const ghUser = "lezsakdomi";
const ghRepo = "elte-mester-data";
const ghTag = "master";
const useCdn = true;
const useRawgitEverywhere = true;
const preferredCodeLang = "cpp";
const searchLimit = 50;

// with trailing slash
const ghFetchBase = "https://" + (useCdn ? "cdn.rawgit.com" : "rawgit.com") + "/" + ghUser + "/" + ghRepo +
    "/" + ghTag + "/";

async function fetchFile(path) {
    if (path instanceof Array) {
        path = path
            .map(component => encodeURIComponent(component).replace('%2F', '/'))
            .join('/');
    }
    const url = ghFetchBase + path.replace(/^\//, "");
    const response = await fetch(url);
    if (response.ok) {
        return response;
    } else {
        throw new Error("Fetch for " + url + " failed: Returned " + response.status + " ("
            + response.statusText +
            ")");
    }
}

async function readFile(path) {
    const response = await fetchFile(path);
    return await response.text();
}

class TSV extends CSV {
    constructor(string) {
        super(string, {
            cellDelimiter: "\t",
            lineDelimiter: "\n",
            header: true
        });
    }
}

const baseUrl = "https://github.com/lezsakdomi/elte-mester-data/tree/master";
const rawBaseUrl = useRawgitEverywhere
    ? ghFetchBase
    : "https://raw.githubusercontent.com/lezsakdomi/elte-mester-data/master";

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
            readFile(this._descriptionPath).then(resolve, reject)
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
        return this[preferredCodeLang + "Url"];
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
                    return csv.map(record => new Feladat(this, record.id, record.feladat, record.nehezseg));
                })
                .then(resolve, reject);
        }, false);

        this.mintafeladat = new MintaFeladat(this);

        allTema.push(this);
    }

    // noinspection JSUnusedGlobalSymbols
    get url() {
        return baseUrl + "/" + encodeURIComponent(this.name);
    }

    get rawUrl() {
        return rawBaseUrl + "/" + encodeURIComponent(this.name);
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
    tree => new Set([...tree].reduce((accumulator, value) => accumulator.concat([...value.temaSet]), []))
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
                new Set(feladatListList.reduce((accumulator, value) => accumulator.concat(value), []))
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