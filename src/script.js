const ghUser = "lezsakdomi";
const ghRepo = "elte-mester-data";
const ghTag = "master";
const useCdn = true;
const useRawgitEverywhere = true;

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

let allFeladat = [];

class Feladat {
    constructor(tema, id, name, nehezseg) {
        this.tema = tema;
        this.id = id;
        this.name = name;
        this.nehezseg = nehezseg;

        this.fetchDescription = new Promise.Deferred((init, resolve, reject) => {
            readFile([this.tema.name, this.name, "feladat.txt"]).then(resolve, reject);
        }, false);
        this.description = undefined;
        this.fetchDescription.then(description => this.description = description);

        allFeladat.push(this);
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

let allTema = [];

class Tema {
    constructor(id, name, szint) {
        this.id = id;
        this.name = name;
        this.szint = szint;

        this.fetchDescription = new Promise.Deferred((init, resolve, reject) => {
            readFile([name, "leiras.txt"]).then(resolve, reject);
        }, false);
        this.description = undefined;
        this.fetchDescription.then(description => this.description = description);

        this.fetchFeladatList = new Promise.Deferred((init, resolve, reject) => {
            readFile([name, "flist.tsv"])
                .then(value => new TSV(value))
                .then(csv => {
                    // noinspection JSUnresolvedFunction
                    return csv.map(record => new Feladat(this, record.id, record.feladat, record.nehezseg));
                })
                .then(resolve, reject);
        }, false);

        allTema.push(this);
    }

    // noinspection JSUnusedGlobalSymbols
    get url() {
        return baseUrl + "/" + encodeURIComponent(this.name);
    }

    get rawUrl() {
        return rawBaseUrl + "/" + encodeURIComponent(this.name);
    }
}

class Szint {
    constructor(name, lazyTree) {
        this.name = name;
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