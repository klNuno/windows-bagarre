// bagarre.mtsu.dev : miroir du dépôt GitHub, sans rien d'autre.
// "/" rend bagarre.ps1, tout autre chemin (outils/, images/) rend le fichier du dépôt.
// Déploiement : wrangler deploy, depuis ce dossier.

const DEPOT = 'https://raw.githubusercontent.com/klNuno/windows-bagarre/main';

export default {
    async fetch(requete) {
        const url = new URL(requete.url);
        const chemin = url.pathname === '/' ? '/bagarre.ps1' : url.pathname;
        const reponse = await fetch(DEPOT + chemin, { cf: { cacheTtl: 60, cacheEverything: true } });
        if (reponse.status === 404) return new Response('Pas de fichier ' + chemin + ' dans le pack.', { status: 404 });
        const entetes = new Headers(reponse.headers);
        if (chemin.endsWith('.ps1') || chemin.endsWith('.txt')) entetes.set('content-type', 'text/plain; charset=utf-8');
        entetes.set('cache-control', 'no-store');
        return new Response(reponse.body, { status: reponse.status, headers: entetes });
    }
};
