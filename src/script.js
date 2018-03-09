const ghUser = "lezsakdomi";
const ghRepo = "elte-mester-data";
const ghTag = "master";
const useCdn = true;

// with trailing slash
const ghFetchBase = "https://"+(useCdn?"cdn.rawgit.com":"rawgit.com")+"/"+ghUser+"/"+ghRepo+"/"+ghTag+"/";

async function fetchFile(path) {
    const url = ghFetchBase + path.replace(/^\//, "");
    const response = await fetch(url);
    if (response.ok) return response;
    else throw new Error("Fetch for "+url+" failed: Returned "+response.status+" ("+response.statusText+")");
}

async function readBinaryFile(path) {
    const response = await fetchFile(path);
    const blob = response.blob();
    return blob;
}

async function readFile(path) {
    const response = await fetchFile(path);
    const text = await response.text();
    return text;
}

async function readJson(path) {
    const response = await fetchFile(path);
    const json = await response.json();
    return json;
}

async function getCookies() {
    return document.cookie
        .split('; ')
        .map(value => value.split('='))
        .reduce((accumulator, [key, value]) => {
            accumulator[key]=value;
            return accumulator;
        }, {})
}

const getInitialCookies = getCookies();

const tsvOptions = {
    cellDelimiter: "\t",
    lineDelimiter: "\n",
    header: true
};
function newTSV(string) {
    return new CSV(string, tsvOptions)
}

const baseUrl = "https://github.com/lezsakdomi/elte-mester-data/tree/master";
//const rawBaseUrl = "https://raw.githubusercontent.com/lezsakdomi/elte-mester-data/master";
const rawBaseUrl = ghFetchBase;

const fetchTemaCSV = new Promise.Deferred((init, resolve, reject) => {
    readFile("temak.tsv")
        .then(newTSV)
        .then(resolve, reject);
}, false);

const generateLazyTree = fetchTemaCSV.then(csv => {
    let result = {};
    csv.forEach(record => {
        if (result[record.szint]===undefined) result[record.szint] = {};
        result[record.szint][record.tema] = record.id
    });
    return result
});

let allFeladat = [];
function Feladat(tema, id, name, nehezseg) {
    this.tema = tema;
    this.id = id;
    this.name = name;
    this.nehezseg = nehezseg;

    this.url = this.tema.url + "/"+encodeURIComponent(this.name);
    this.rawUrl = this.tema.rawUrl + "/"+encodeURIComponent(this.name);
    // noinspection JSUnusedGlobalSymbols
    this.pdfUrl = this.rawUrl + "/feladat.pdf";
    // noinspection JSUnusedGlobalSymbols
    this.mintaUrl = this.rawUrl + "/minta.zip";

    this.fetchDescription = new Promise.Deferred((init, resolve, reject) => {
        readFile(this.tema.name+"/"+this.name+"/feladat.txt").then(resolve, reject);
    }, false);
    this.description = undefined; this.fetchDescription.then(description => this.description = description);

    allFeladat.push(this)
}

let allTema = [];
function Tema(id, name, szint) {
    this.id = id;
    this.name = name;
    this.szint = szint;

    this.url = baseUrl + "/"+encodeURIComponent(this.name);
    this.rawUrl = rawBaseUrl + "/"+encodeURIComponent(this.name);

    this.fetchDescription = new Promise.Deferred((init, resolve, reject) => {
        readFile(name+"/leiras.txt").then(resolve, reject)
    }, false);
    this.description = undefined; this.fetchDescription.then(description => this.description = description);

    this.fetchFeladatList = new Promise.Deferred((init, resolve, reject) => {
        readFile(name+"/flist.tsv")
            .then(newTSV)
            .then(csv => csv.map(record => new Feladat(this, record.id, record.feladat, record.nehezseg)))
            .then(resolve, reject);
    }, false);
    // noinspection JSUnusedGlobalSymbols
    this.feladatList = undefined;
    // noinspection JSUnusedGlobalSymbols
    this.fetchFeladatList.then(feladatList => this.feladatList = feladatList);

    allTema.push(this)
}

function Szint(name, lazyTree) {
    this.name = name;
    // noinspection JSUnusedGlobalSymbols //TODO sure?
    this.lazyTree = lazyTree;
    this.temaList = Object.entries(lazyTree).map(([name, id]) => new Tema(id, name, this));
    this.temaSet = new Set(this.temaList)
}

const generateRealTree = generateLazyTree.then(
    tree => new Set( Object.keys(tree).map(szint => new Szint(szint, tree[szint])) )
);
let realTree; generateRealTree.then(value => realTree = value);

const generateTemaSet = generateRealTree.then(
    tree => new Set( [...tree].reduce((accumulator, value) => accumulator.concat([...value.temaSet]), []) )
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
                new Set( feladatListList.reduce((accumulator, value) => accumulator.concat(value), []) )
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