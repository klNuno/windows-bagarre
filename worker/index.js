// bagarre.mtsu.dev : miroir du dépôt GitHub.
// "/" rend bagarre.ps1 à irm, et à un navigateur une page avec la seule ligne à coller.
// Tout autre chemin (bagarre.ps1, images/) rend le fichier du dépôt tel quel.
// Déploiement : wrangler deploy, depuis ce dossier.

const DEPOT = 'https://raw.githubusercontent.com/klNuno/windows-bagarre/main';
const SITE = 'https://bagarre.mtsu.dev';
const COMMANDE = `irm ${SITE} | iex`;

// Un ami a ouvert le lien dans son navigateur, y a vu le script entier, l'a copié et collé dans la console : chaque
// ligne est partie seule et la fenêtre s'est ouverte cassée (2026-10-23). irm et iwr n'envoient pas d'en-tête Accept,
// un navigateur demande text/html. Les robots d'aperçu reçoivent la page aussi, pour l'embed Discord.
function estNavigateur(requete) {
    const accept = requete.headers.get('accept') || '';
    const agent = requete.headers.get('user-agent') || '';
    return accept.includes('text/html') || /discordbot|twitterbot|facebookexternalhit|slackbot|whatsapp|telegrambot/i.test(agent);
}

const TEXTES = {
    fr: {
        intro: 'Une fenêtre qui allège et règle un Windows 11 fraîchement installé pour jouer.',
        etape: 'Ouvre un Terminal (clic droit sur Démarrer > Terminal), colle cette ligne et accepte la demande administrateur.',
        copier: 'Copier', copie: 'Copié',
        garde: 'Seulement cette ligne. Le script lui-même, collé dans la console, part ligne par ligne et casse.',
        capture: "L'accueil de la fenêtre",
        code: 'Le code est sur GitHub',
    },
    en: {
        intro: 'A window that debloats and tunes a freshly installed Windows 11 for gaming.',
        etape: 'Open a Terminal (right-click Start > Terminal), paste this line and accept the administrator prompt.',
        copier: 'Copy', copie: 'Copied',
        garde: 'Only this line. The script itself, pasted into the console, runs line by line and breaks.',
        capture: 'The home page of the window',
        code: 'The code is on GitHub',
    },
};

function page(requete) {
    const langue = /^fr\b/i.test(requete.headers.get('accept-language') || '') ? 'fr' : 'en';
    const t = TEXTES[langue];
    return `<!doctype html>
<html lang="${langue}">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>windows bagarre edition</title>
<meta name="description" content="${t.intro}">
<meta property="og:title" content="windows bagarre edition">
<meta property="og:description" content="${t.etape} ${COMMANDE}">
<meta property="og:image" content="${SITE}/images/home.png">
<meta name="theme-color" content="#B794F6">
<link rel="icon" href="data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect width='32' height='32' rx='8' fill='%232C2340'/%3E%3Ctext x='16' y='23' font-family='Segoe UI,sans-serif' font-size='20' font-weight='700' text-anchor='middle' fill='%23B794F6'%3EB%3C/text%3E%3C/svg%3E">
<style>
:root { color-scheme: dark; }
* { box-sizing: border-box; }
body {
    margin: 0; min-height: 100vh; display: grid; place-items: center; padding: 48px 20px;
    background: radial-gradient(900px 500px at 50% -10%, #2C2340 0%, #15121C 60%) #15121C;
    color: #ECE8F4; font: 16px/1.55 "Segoe UI Variable Text", "Segoe UI", system-ui, sans-serif;
}
main { width: min(860px, 100%); }
h1 { margin: 0 0 6px; font-size: clamp(30px, 6vw, 46px); font-weight: 600; letter-spacing: -0.02em; }
h1 b { color: #B794F6; font-weight: 800; letter-spacing: 0.02em; text-shadow: 0 0 28px rgba(183, 148, 246, 0.45); }
.intro { margin: 0 0 32px; color: #9B93AD; }
.etape { margin: 0 0 12px; color: #D6D0E2; }
.commande {
    display: flex; align-items: center; gap: 12px; padding: 10px 10px 10px 20px;
    background: #1E1A28; border: 1px solid #463E5C; border-radius: 12px;
    box-shadow: 0 0 0 4px rgba(183, 148, 246, 0.08), 0 18px 50px -20px rgba(183, 148, 246, 0.5);
}
code { flex: 1; overflow-x: auto; white-space: nowrap; font: 600 19px/1.4 "Cascadia Mono", Consolas, monospace; color: #D4BFFF; }
button {
    flex: none; min-width: 96px; padding: 10px 18px; border: 0; border-radius: 8px; cursor: pointer;
    background: #B794F6; color: #1A1026; font: 600 15px "Segoe UI Variable Text", "Segoe UI", system-ui, sans-serif;
    transition: transform 0.12s ease, background 0.2s ease;
}
button:hover { background: #D4BFFF; }
button:active { transform: scale(0.96); }
button.ok { background: #8FD3A0; }
.garde { margin: 14px 0 40px; padding: 10px 14px; border-radius: 8px; background: #2E2620; color: #F6C177; font-size: 14px; }
img { display: block; width: 100%; height: auto; border: 1px solid #2E2840; border-radius: 12px; box-shadow: 0 30px 80px -30px #000; }
.pied { margin: 18px 0 0; font-size: 14px; }
a { color: #9B93AD; }
a:hover { color: #D4BFFF; }
</style>
</head>
<body>
<main>
<h1>windows <b>BAGARRE</b> edition</h1>
<p class="intro">${t.intro}</p>
<p class="etape">${t.etape}</p>
<div class="commande"><code id="commande">${COMMANDE}</code><button id="copier" type="button">${t.copier}</button></div>
<p class="garde">${t.garde}</p>
<img src="/images/home.png" alt="${t.capture}" width="1320" height="860">
<p class="pied"><a href="https://github.com/klNuno/windows-bagarre">${t.code}</a></p>
</main>
<script>
const bouton = document.getElementById('copier');
bouton.addEventListener('click', async () => {
    await navigator.clipboard.writeText(document.getElementById('commande').textContent);
    bouton.textContent = ${JSON.stringify(t.copie)}; bouton.classList.add('ok');
    setTimeout(() => { bouton.textContent = ${JSON.stringify(t.copier)}; bouton.classList.remove('ok'); }, 1600);
});
</script>
</body>
</html>`;
}

export default {
    async fetch(requete) {
        const url = new URL(requete.url);
        if (url.pathname === '/' && estNavigateur(requete)) {
            return new Response(page(requete), {
                headers: { 'content-type': 'text/html; charset=utf-8', 'cache-control': 'no-store', 'vary': 'Accept, Accept-Language, User-Agent' },
            });
        }
        const chemin = url.pathname === '/' ? '/bagarre.ps1' : url.pathname;
        const reponse = await fetch(DEPOT + chemin, { cf: { cacheTtl: 60, cacheEverything: true } });
        if (reponse.status === 404) return new Response('Pas de fichier ' + chemin + ' dans le pack.', { status: 404 });
        const entetes = new Headers(reponse.headers);
        if (chemin.endsWith('.ps1') || chemin.endsWith('.txt')) entetes.set('content-type', 'text/plain; charset=utf-8');
        entetes.set('cache-control', 'no-store');
        if (url.pathname === '/') entetes.set('vary', 'Accept, Accept-Language, User-Agent');
        return new Response(reponse.body, { status: reponse.status, headers: entetes });
    }
};
