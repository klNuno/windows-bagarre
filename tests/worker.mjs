// tests/worker.mjs : "/" rend la page à un navigateur et le script à irm (un ami copiait le script affiché, 2026-10-23).
//   node tests/worker.mjs [chemin/vers/index.js]
import assert from 'node:assert/strict';
import { pathToFileURL } from 'node:url';
import { resolve } from 'node:path';

const cible = process.argv[2] ? pathToFileURL(resolve(process.argv[2])).href : new URL('../worker/index.js', import.meta.url).href;
const worker = (await import(cible)).default;
const demandes = [];
globalThis.fetch = async (url) => { demandes.push(url); return new Response('#Requires -Version 5.1', { status: 200 }); };
const appel = (chemin, entetes) => worker.fetch(new Request('https://bagarre.mtsu.dev' + chemin, { headers: entetes }));

const PS51 = { 'user-agent': 'Mozilla/5.0 (Windows NT; Windows NT 10.0; fr-FR) WindowsPowerShell/5.1.26100.9711' };
const PS7 = { 'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Microsoft Windows 10.0.26200; fr-FR) PowerShell/7.6.7' };
const CHROME = {
    'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0 Safari/537.36',
    'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'accept-language': 'fr-FR,fr;q=0.9,en;q=0.8',
};
const resultats = [];
async function cas(nom, f) {
    try { await f(); resultats.push(['OK   ', nom]); } catch (e) { resultats.push(['ECHEC', nom + ' : ' + e.message.split('\n')[0]]); }
}

await cas('irm PowerShell 5.1 sur / : le script', async () => {
    const r = await appel('/', PS51);
    assert.equal(await r.text(), '#Requires -Version 5.1');
    assert.match(r.headers.get('content-type'), /^text\/plain/);
    assert.ok(demandes.at(-1).endsWith('/bagarre.ps1'));
});
await cas('irm PowerShell 7 sur / : le script', async () => {
    assert.equal(await (await appel('/', PS7)).text(), '#Requires -Version 5.1');
});
await cas('navigateur sur / : la page, pas le script', async () => {
    const r = await appel('/', CHROME);
    const html = await r.text();
    assert.match(r.headers.get('content-type'), /^text\/html/);
    assert.ok(html.includes('irm https://bagarre.mtsu.dev | iex'), 'la ligne à coller manque');
    assert.ok(!html.includes('#Requires'), 'le script est dans la page');
    assert.match(html, /<html lang="fr">/);
});
await cas('navigateur anglais : page en anglais', async () => {
    const html = await (await appel('/', { ...CHROME, 'accept-language': 'en-US,en;q=0.9' })).text();
    assert.match(html, /<html lang="en">/);
});
await cas('aperçu Discord sur / : la page', async () => {
    const r = await appel('/', { 'user-agent': 'Mozilla/5.0 (compatible; Discordbot/2.0; +https://discordapp.com)' });
    assert.match(r.headers.get('content-type'), /^text\/html/);
});
await cas('navigateur sur /bagarre.ps1 : le script brut (relance admin, lecture)', async () => {
    assert.equal(await (await appel('/bagarre.ps1', CHROME)).text(), '#Requires -Version 5.1');
});

for (const [etat, nom] of resultats) console.log(`  ${etat}  ${nom}`);
const echecs = resultats.filter(([etat]) => etat === 'ECHEC').length;
console.log(echecs ? `${echecs} échec(s).` : 'Tout passe.');
process.exit(echecs ? 1 : 0);
