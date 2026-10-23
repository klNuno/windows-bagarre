#Requires -Version 5.1
# tests/colle.ps1 : le texte de bagarre.ps1 colle dans une console au lieu de "irm | iex" (log d'un ami, 2026-10-23).
# Colle le debut du script dans un vrai PowerShell interactif (pseudo-console comme Windows Terminal, PSReadLine,
# aucune fenetre) et sur l'entree standard, et verifie que le garde-fou arrete tout. Verifie aussi que iex,
# scriptblock et -File passent sans le declencher.
# Le collage s'arrete avant $EstAdmin : coller la relance admin ouvrirait l'UAC sur l'ecran du mainteneur.
#   powershell -NoProfile -ExecutionPolicy Bypass -File tests\colle.ps1 [-Script ancien.ps1]
param([string]$Script)
$ErrorActionPreference = 'Stop'
if (-not $Script) { $Script = Join-Path (Split-Path -Parent $PSScriptRoot) 'bagarre.ps1' }
$Script = (Resolve-Path $Script).Path
$env:BAGARRE_TEST = '1'   # le garde-fou ne touche pas au presse-papiers

Add-Type -TypeDefinition @'
using System;
using System.ComponentModel;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using Microsoft.Win32.SafeHandles;

// Une pseudo-console (ConPTY) : ce que Windows Terminal donne a PowerShell. Ecrire dans Entree = taper ou coller.
public class PseudoConsole : IDisposable {
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    struct STARTUPINFO {
        public int cb; public string lpReserved; public string lpDesktop; public string lpTitle;
        public int dwX; public int dwY; public int dwXSize; public int dwYSize; public int dwXCountChars; public int dwYCountChars;
        public int dwFillAttribute; public int dwFlags; public short wShowWindow; public short cbReserved2;
        public IntPtr lpReserved2; public IntPtr hStdInput; public IntPtr hStdOutput; public IntPtr hStdError;
    }
    [StructLayout(LayoutKind.Sequential)] struct STARTUPINFOEX { public STARTUPINFO StartupInfo; public IntPtr lpAttributeList; }
    [StructLayout(LayoutKind.Sequential)] struct PROCESS_INFORMATION { public IntPtr hProcess; public IntPtr hThread; public int dwProcessId; public int dwThreadId; }

    [DllImport("kernel32.dll", SetLastError = true)] static extern bool CreatePipe(out SafeFileHandle r, out SafeFileHandle w, IntPtr sa, int size);
    [DllImport("kernel32.dll")] static extern int CreatePseudoConsole(int size, SafeFileHandle input, SafeFileHandle output, uint flags, out IntPtr hpc);
    [DllImport("kernel32.dll")] static extern void ClosePseudoConsole(IntPtr hpc);
    [DllImport("kernel32.dll", SetLastError = true)] static extern bool InitializeProcThreadAttributeList(IntPtr list, int count, int flags, ref IntPtr size);
    [DllImport("kernel32.dll", SetLastError = true)] static extern bool UpdateProcThreadAttribute(IntPtr list, uint flags, IntPtr attr, IntPtr value, IntPtr size, IntPtr prev, IntPtr ret);
    [DllImport("kernel32.dll")] static extern void DeleteProcThreadAttributeList(IntPtr list);
    [DllImport("kernel32.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    static extern bool CreateProcessW(string app, StringBuilder cmd, IntPtr pa, IntPtr ta, bool inherit, uint flags, IntPtr env, string dir, ref STARTUPINFOEX si, out PROCESS_INFORMATION pi);
    [DllImport("kernel32.dll")] static extern bool TerminateProcess(IntPtr h, uint code);
    [DllImport("kernel32.dll")] static extern bool CloseHandle(IntPtr h);

    IntPtr hpc, attrs, processus;
    FileStream entree, sortieFlux;
    readonly StringBuilder sortie = new StringBuilder();

    public PseudoConsole(string ligneDeCommande, short largeur, short hauteur) {
        SafeFileHandle entreeLecture, entreeEcriture, sortieLecture, sortieEcriture;
        if (!CreatePipe(out entreeLecture, out entreeEcriture, IntPtr.Zero, 0)) throw new Win32Exception();
        if (!CreatePipe(out sortieLecture, out sortieEcriture, IntPtr.Zero, 0)) throw new Win32Exception();
        int hr = CreatePseudoConsole((hauteur << 16) | (ushort)largeur, entreeLecture, sortieEcriture, 0, out hpc);
        if (hr != 0) throw new Exception("CreatePseudoConsole " + hr);
        entreeLecture.Dispose(); sortieEcriture.Dispose();
        IntPtr taille = IntPtr.Zero;
        InitializeProcThreadAttributeList(IntPtr.Zero, 1, 0, ref taille);
        attrs = Marshal.AllocHGlobal(taille);
        if (!InitializeProcThreadAttributeList(attrs, 1, 0, ref taille)) throw new Win32Exception();
        if (!UpdateProcThreadAttribute(attrs, 0, (IntPtr)0x00020016, hpc, (IntPtr)IntPtr.Size, IntPtr.Zero, IntPtr.Zero)) throw new Win32Exception();
        STARTUPINFOEX si = new STARTUPINFOEX();
        si.StartupInfo.cb = Marshal.SizeOf(typeof(STARTUPINFOEX));
        si.StartupInfo.dwFlags = 0x100;   // STARTF_USESTDHANDLES, poignees nulles : sinon l'enfant prend les tubes du parent
        si.lpAttributeList = attrs;
        PROCESS_INFORMATION pi;
        if (!CreateProcessW(null, new StringBuilder(ligneDeCommande), IntPtr.Zero, IntPtr.Zero, false, 0x00080000, IntPtr.Zero, null, ref si, out pi)) throw new Win32Exception();
        processus = pi.hProcess; CloseHandle(pi.hThread);
        entree = new FileStream(entreeEcriture, FileAccess.Write);
        sortieFlux = new FileStream(sortieLecture, FileAccess.Read);
        Thread lecteur = new Thread(Lire); lecteur.IsBackground = true; lecteur.Start();
    }
    void Lire() {
        Decoder dec = Encoding.UTF8.GetDecoder();
        byte[] octets = new byte[16384]; char[] car = new char[16384];
        try {
            int n;
            while ((n = sortieFlux.Read(octets, 0, octets.Length)) > 0) {
                int c = dec.GetChars(octets, 0, n, car, 0);
                lock (sortie) sortie.Append(car, 0, c);
            }
        } catch { }
    }
    public void Ecrire(string texte) { byte[] b = Encoding.UTF8.GetBytes(texte); entree.Write(b, 0, b.Length); entree.Flush(); }
    public string Sortie { get { lock (sortie) return sortie.ToString(); } }
    public int Longueur { get { lock (sortie) return sortie.Length; } }
    public void Dispose() {
        TerminateProcess(processus, 0); CloseHandle(processus);
        ClosePseudoConsole(hpc);
        DeleteProcThreadAttributeList(attrs); Marshal.FreeHGlobal(attrs);
        try { entree.Dispose(); } catch { }
    }
}
'@

# Texte lisible : sans les sequences VT (couleurs, curseur) que la pseudo-console emet.
function Nettoyer([string]$texte) {
    $texte = [regex]::Replace($texte, '\x1b\][^\x07\x1b]*(\x07|\x1b\\)', '')
    $texte = [regex]::Replace($texte, '\x1b\[[0-9;?]*[ -/]*[@-~]', '')
    [regex]::Replace($texte, '\x1b.', '')
}
function Attendre-Calme($pty, [int]$calmeMs, [int]$maxS) {
    $fin = (Get-Date).AddSeconds($maxS); $avant = -1; $depuis = Get-Date
    while ((Get-Date) -lt $fin) {
        Start-Sleep -Milliseconds 200
        $n = $pty.Longueur
        if ($n -ne $avant) { $avant = $n; $depuis = Get-Date } elseif (((Get-Date) - $depuis).TotalMilliseconds -ge $calmeMs) { return }
    }
}

$lignes = [IO.File]::ReadAllLines($Script, [Text.Encoding]::UTF8)
$admin = [Array]::FindIndex($lignes, [Predicate[string]] { param($x) $x -like '$EstAdmin = *' })
$langue = [Array]::FindIndex($lignes, [Predicate[string]] { param($x) $x -like '$Bagarre.Langue = if *' })
if ($admin -lt 1 -or $langue -lt 0) { throw 'Repere $EstAdmin ou $Bagarre.Langue introuvable dans le script' }
# Le collage : tout jusqu'a la relance admin exclue, puis les deux lignes du choix de langue (le elseif qui cassait).
$tete = @($lignes[0..($admin - 1)])
$collage = $tete + @($lignes[$langue..($langue + 1)])
$sonde = '"SONDE " + [bool](Get-Variable Textes -ErrorAction SilentlyContinue)'
$dossier = Join-Path $env:TEMP 'bagarre-test-colle'
New-Item -ItemType Directory -Force $dossier | Out-Null
$teteFichier = Join-Path $dossier 'tete.ps1'
[IO.File]::WriteAllText($teteFichier, ($tete -join "`r`n"), (New-Object Text.UTF8Encoding $false))
$messageGarde = '(?m)^\s*irm https://\S+ \| iex'   # la ligne affichee par le garde-fou, pas son source ($ligne = '...')

$Bilan = @{ Echecs = 0 }
function Verifier([string]$nom, [bool]$ok, [string]$detail) {
    if ($ok) { Write-Host "  OK     $nom" -ForegroundColor Green }
    else { Write-Host "  ECHEC  $nom : $detail" -ForegroundColor Red; $Bilan.Echecs++ }
}
function Console-Interactive([string]$texte) {
    $pty = New-Object PseudoConsole 'powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass', 200, 50
    try {
        Attendre-Calme $pty 1500 30
        $pty.Ecrire(($texte -replace "`r?`n", "`r") + "`r")   # un collage dans Windows Terminal : CR entre les lignes
        Attendre-Calme $pty 4000 300                           # le garde-fou attend 1,5 s sans touche avant de parler
        $pty.Ecrire("$sonde`r")
        Attendre-Calme $pty 1500 30
        Nettoyer $pty.Sortie
    } finally { $pty.Dispose() }
}

$ErrorActionPreference = 'Continue'   # la sortie d'erreur des PowerShell enfants est lue, pas levee
Write-Host "Script : $Script ($($collage.Count) lignes collees)"

# 1. Collage dans un Terminal : le cas de l'ami.
$sortie = Console-Interactive ($collage -join "`n")
[IO.File]::WriteAllText((Join-Path $dossier 'console-collage.txt'), $sortie)
Verifier 'collage console : garde-fou affiche' ($sortie -match $messageGarde) 'pas de ligne "irm ... | iex" affichee'
Verifier 'collage console : rien apres le garde-fou' ($sortie -match 'SONDE False') ("sonde : " + [regex]::Match($sortie, 'SONDE \w+').Value)
Verifier 'collage console : pas de elseif orphelin' ($sortie -notmatch 'CommandNotFoundException') 'CommandNotFoundException dans la sortie'

# 2. Script envoye sur l'entree standard (irm | powershell).
$sortie = (($collage + $sonde) | powershell -NoProfile -Command - 2>&1 | Out-String)
Verifier 'entree standard : garde-fou affiche' ($sortie -match $messageGarde) 'pas de ligne "irm ... | iex" affichee'
Verifier 'entree standard : arret net' (($sortie -notmatch 'SONDE True') -and ($sortie -notmatch 'CommandNotFoundException')) 'des lignes ont tourne apres le garde-fou'

# 3. irm | iex dans un Terminal : le vrai lancement ne doit pas declencher le garde-fou.
$sortie = Console-Interactive "iex ([IO.File]::ReadAllText('$teteFichier', [Text.Encoding]::UTF8))"
[IO.File]::WriteAllText((Join-Path $dossier 'console-iex.txt'), $sortie)
Verifier 'iex console : passe' (($sortie -match 'SONDE True') -and ($sortie -notmatch $messageGarde)) ("sonde : " + [regex]::Match($sortie, 'SONDE \w+').Value)

# 4. Scriptblock -Liste (lancement local) et -File -Liste sur une copie avec BOM (la relance admin).
$sortie = powershell -NoProfile -Command "& ([scriptblock]::Create([IO.File]::ReadAllText('$Script', [Text.Encoding]::UTF8))) -Liste" 2>&1 | Out-String
Verifier 'scriptblock -Liste : passe' (($sortie -notmatch $messageGarde) -and ($sortie -split "`n").Count -gt 50) "$(($sortie -split "`n").Count) lignes"
$copie = Join-Path $dossier 'bagarre-bom.ps1'
[IO.File]::WriteAllText($copie, [IO.File]::ReadAllText($Script, [Text.Encoding]::UTF8), (New-Object Text.UTF8Encoding $true))
$sortie = powershell -NoProfile -ExecutionPolicy Bypass -File $copie -Liste 2>&1 | Out-String
Verifier '-File -Liste : passe' (($sortie -notmatch $messageGarde) -and ($sortie -split "`n").Count -gt 50) "$(($sortie -split "`n").Count) lignes"

Remove-Item $copie, $teteFichier -Force
if ($Bilan.Echecs) { Write-Host "$($Bilan.Echecs) echec(s). Sorties console dans $dossier" -ForegroundColor Red; exit 1 }
Write-Host 'Tout passe.' -ForegroundColor Green
