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

let tokenStatus = new Observable({
    saved: false
});
getInitialCookies.then(value => tokenStatus.saved = value);
async function saveToken(token) {
    document.cookie = "ghToken=" + token;
    tokenStatus.saved = true;
}
async function deleteToken() {
    document.cookie='ghToken=;expires='+(new Date).toUTCString();
    tokenStatus.saved = false;
}

const gatherToken = new Promise.Deferred(() => getInitialCookies.then(cookies => {
    let token;
    // noinspection JSUnresolvedVariable
    if ('ghToken' in cookies) {
        tokenStatus.saved = true;
        // noinspection JSUnresolvedVariable
        return cookies.ghToken;
    } else {
        token = prompt(
            "Authentication required\n" +
            "\n" +
            "Authentication required to fetch data from GitHub. GitHub needs this to ensure nobody is trying to " +
            "spam their service. Authenticated users can do 5000 requests per hour, but for unauthenticated " +
            "requests the maximum is 60/hr. See https://developer.github.com/v3/#rate-limiting for more " +
            "information.\n" +
            "\n" +
            "Please paste a valid GitHub personal access token below\n" +
            "To obtain such, please visit https://github.com/settings/tokens to generate a new one. Make sure " +
            "not to tick any special permission, because this token would be stored in an unencrypted cooke.\n" +
            "\n" +
            "Leave this field empty to continue anonymously\n"
        );
        if (token === null) throw new Error("Token is too secret for us");
        saveToken(token);
        return token
    }
}));

const initOcto = gatherToken.then(token => {
    if (token) {
        return new Octokat({
            token: token
        })
    } else {
        return new Octokat;
    }
});

const tsvOptions = {
    cellDelimiter: "\t",
    lineDelimiter: "\n",
    header: true
};
function newTSV(string) {
    return new CSV(string, tsvOptions)
}

const gatherRepo = initOcto.then(octo => octo.repos("lezsakdomi", "elte-mester-data"));

const baseUrl = "https://cdn.rawgit.com/lezsakdomi/elte-mester-data/master";

// const fetchTemaCSV = new Promise.Deferred((value) =>
//     gatherRepo.run(value).then(repo => repo.contents("temak.tsv").read().then(newTSV))
// );
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

    this.url = this.tema.url + "/"+this.name;
    // noinspection JSUnusedGlobalSymbols
    this.pdfUrl = this.url + "/feladat.pdf";
    // noinspection JSUnusedGlobalSymbols
    this.mintaUrl = this.url + "/minta.zip";

    allFeladat.push(this)
}

let allTema = [];
function Tema(id, name, szint) {
    this.id = id;
    this.name = name;
    this.szint = szint;

    this.url = baseUrl + "/"+this.name;

    this.fetchDescription = new Promise.Deferred((init, resolve, reject) => {
        //gatherRepo.run().then(repo => repo.contents(name+"/leiras.txt").read())
        readFile(name + "/leiras.txt").then(resolve, reject)
    }, false);
    this.description = undefined; this.fetchDescription.then(description => this.description = description);

    // this.fetchFeladatList = new Promise.Deferred(() => gatherRepo.run().then(repo => repo
    //     .contents(name+"/flist.tsv")
    //     .read()
    //     .then(newTSV)
    //     .then(csv => csv.map(record => new Feladat(this, record.id, record.feladat, record.nehezseg)))
    // ));
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