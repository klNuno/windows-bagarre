# ---------------------------------------------------------------------------
# Mode -Liste : le catalogue en texte, sans rien appliquer (test)
# ---------------------------------------------------------------------------
if ($Liste) {
    Write-Host "Machine : $Machine"
    $Items | ForEach-Object { '{0,-24} {1} {2}' -f $_.Id, $(if ($_.Coche) { '[x]' } else { '[ ]' }), $_.Titre }
    return
}

# ---------------------------------------------------------------------------
# La fenêtre : un volet d'onglets à gauche, une page par étape du pack, le journal en bas.
# Tout tourne sur le thread de la fenêtre, Log appelle Rafraichir pour qu'elle reste vivante.
# ---------------------------------------------------------------------------
Add-Type -AssemblyName PresentationFramework, PresentationCore, WindowsBase

$Xaml = @'
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="windows bagarre edition" Width="1200" Height="780" MinWidth="960" MinHeight="620"
        WindowStartupLocation="CenterScreen" Background="#1B1B1F" Foreground="#E8E8E8" FontFamily="Segoe UI" FontSize="13">
  <Window.Resources>
    <Style TargetType="Button">
      <Setter Property="Background" Value="#2A2A31"/>
      <Setter Property="Foreground" Value="#F0F0F0"/>
      <Setter Property="BorderBrush" Value="#3C3C46"/>
      <Setter Property="BorderThickness" Value="1"/>
      <Setter Property="Padding" Value="12,6"/>
      <Setter Property="Margin" Value="0,0,8,8"/>
      <Setter Property="Cursor" Value="Hand"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="Button">
            <Border Name="Fond" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="4" Padding="{TemplateBinding Padding}">
              <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsMouseOver" Value="True"><Setter TargetName="Fond" Property="BorderBrush" Value="#F2C14E"/></Trigger>
              <Trigger Property="IsEnabled" Value="False"><Setter Property="Opacity" Value="0.4"/></Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Principal" TargetType="Button" BasedOn="{StaticResource {x:Type Button}}">
      <Setter Property="Background" Value="#F2C14E"/>
      <Setter Property="Foreground" Value="#1B1B1F"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
    </Style>
    <Style TargetType="CheckBox">
      <Setter Property="Foreground" Value="#E8E8E8"/>
      <Setter Property="Margin" Value="0,3,0,3"/>
    </Style>
    <Style TargetType="TextBox">
      <Setter Property="Background" Value="#141416"/>
      <Setter Property="Foreground" Value="#DADADA"/>
      <Setter Property="BorderBrush" Value="#2E2E36"/>
      <Setter Property="FontFamily" Value="Consolas"/>
      <Setter Property="FontSize" Value="13"/>
      <Setter Property="Padding" Value="10"/>
      <Setter Property="IsReadOnly" Value="True"/>
      <Setter Property="TextWrapping" Value="Wrap"/>
      <Setter Property="AcceptsReturn" Value="True"/>
      <Setter Property="VerticalScrollBarVisibility" Value="Auto"/>
    </Style>
    <Style TargetType="ListBoxItem">
      <Setter Property="Foreground" Value="#C8C8C8"/>
      <Setter Property="Padding" Value="14,9"/>
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="Template">
        <Setter.Value>
          <ControlTemplate TargetType="ListBoxItem">
            <Border Name="Fond" Background="Transparent" Padding="{TemplateBinding Padding}">
              <ContentPresenter/>
            </Border>
            <ControlTemplate.Triggers>
              <Trigger Property="IsSelected" Value="True">
                <Setter TargetName="Fond" Property="Background" Value="#2A2A31"/>
                <Setter Property="Foreground" Value="#F2C14E"/>
              </Trigger>
              <Trigger Property="IsMouseOver" Value="True">
                <Setter TargetName="Fond" Property="Background" Value="#232329"/>
              </Trigger>
            </ControlTemplate.Triggers>
          </ControlTemplate>
        </Setter.Value>
      </Setter>
    </Style>
    <Style x:Key="Titre" TargetType="TextBlock">
      <Setter Property="FontSize" Value="20"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Margin" Value="0,0,0,10"/>
      <Setter Property="TextWrapping" Value="Wrap"/>
    </Style>
    <Style x:Key="Intro" TargetType="TextBlock">
      <Setter Property="Foreground" Value="#B0B0B8"/>
      <Setter Property="Margin" Value="0,0,0,10"/>
      <Setter Property="TextWrapping" Value="Wrap"/>
    </Style>
    <Style x:Key="Groupe" TargetType="TextBlock">
      <Setter Property="FontSize" Value="14"/>
      <Setter Property="FontWeight" Value="SemiBold"/>
      <Setter Property="Foreground" Value="#F2C14E"/>
      <Setter Property="Margin" Value="0,14,0,6"/>
    </Style>
    <Style x:Key="Etiquette" TargetType="TextBlock">
      <Setter Property="Foreground" Value="#F2C14E"/>
      <Setter Property="Margin" Value="0,12,0,2"/>
    </Style>
  </Window.Resources>
  <Grid Background="#1B1B1F">
    <Grid.ColumnDefinitions>
      <ColumnDefinition Width="230"/>
      <ColumnDefinition Width="*"/>
    </Grid.ColumnDefinitions>
    <Grid.RowDefinitions>
      <RowDefinition Height="*"/>
      <RowDefinition Height="150"/>
    </Grid.RowDefinitions>

    <DockPanel Grid.Column="0" Grid.RowSpan="2" Background="#141416">
      <StackPanel DockPanel.Dock="Top" Margin="16,18,16,10">
        <TextBlock Text="BAGARRE" FontSize="24" FontWeight="Bold" Foreground="#F2C14E"/>
        <TextBlock Text="windows bagarre edition" Foreground="#8A8A95"/>
      </StackPanel>
      <TextBlock DockPanel.Dock="Bottom" Name="NavMachine" Margin="16,8,16,14" Foreground="#8A8A95" TextWrapping="Wrap" FontSize="11"/>
      <ListBox Name="Nav" Background="Transparent" BorderThickness="0" SelectedIndex="0">
        <ListBoxItem Content="Accueil"/>
        <ListBoxItem Content="1. Installation"/>
        <ListBoxItem Content="2. Facile"/>
        <ListBoxItem Content="3. Le script à cocher"/>
        <ListBoxItem Content="4. NVIDIA"/>
        <ListBoxItem Content="5. Dur"/>
        <ListBoxItem Content="6. Maintenance"/>
        <ListBoxItem Content="7. DNS"/>
        <ListBoxItem Content="8. Audit IA"/>
      </ListBox>
    </DockPanel>

    <Grid Grid.Column="1" Grid.Row="0" Name="Pages" Margin="20,16,20,8">

      <DockPanel Name="PageAccueil">
        <TextBlock DockPanel.Dock="Top" Text="Tu viens de réinstaller Windows 11" Style="{StaticResource Titre}"/>
        <TextBox Name="TexteAccueil"/>
      </DockPanel>

      <DockPanel Name="PageInstallation" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="1. Installation (30 min) : Windows propre, mises à jour, pilotes" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnFsutil" Content="fsutil 8dot3name set 1"/>
          <Button Name="BtnWindowsUpdate" Content="Ouvrir Windows Update"/>
          <Button Name="BtnSnappy" Content="Snappy Driver Installer Origin (winget)"/>
        </WrapPanel>
        <TextBox Name="TexteInstallation"/>
      </DockPanel>

      <DockPanel Name="PageFacile" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="2. Facile (15 min) : débloat en deux clics, DirectX, Visual C++, tes applis" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnDebloat" Content="Win11Debloat" Style="{StaticResource Principal}"/>
          <Button Name="BtnWinUtil" Content="WinUtil (Chris Titus)" Style="{StaticResource Principal}"/>
          <Button Name="BtnDirectX" Content="DirectX (winget)"/>
          <Button Name="BtnVcredist" Content="Visual C++ 2005 à 2022 (winget)"/>
        </WrapPanel>
        <Border DockPanel.Dock="Top" Background="#141416" CornerRadius="4" Padding="12" Margin="0,0,0,10">
          <StackPanel>
            <TextBlock Text="Tes applis, installées d'un coup par winget (coche, puis le bouton) :" Margin="0,0,0,6"/>
            <WrapPanel Name="ListeApplis"/>
            <Button Name="BtnApplis" Content="Installer les applis cochées" Margin="0,8,0,0" HorizontalAlignment="Left"/>
          </StackPanel>
        </Border>
        <TextBox Name="TexteFacile"/>
      </DockPanel>

      <DockPanel Name="PageOptis" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="3. Le script à cocher (10 min)" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Style="{StaticResource Intro}" Text="Les cases cochées par défaut sont sûres pour tout PC. Passe la souris sur une ligne : le Pourquoi et ce que tu perds s'affichent à droite. Tu ne comprends pas une ligne, tu ne la coches pas. Avant d'appliquer, l'état de chaque clé, service et réglage est sauvé : Tout remettre restaure. Redémarre après."/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnAppliquer" Content="Appliquer les cases cochées" Style="{StaticResource Principal}"/>
          <Button Name="BtnRestaurer" Content="Tout remettre comme avant"/>
          <Button Name="BtnDefaut" Content="Revenir aux cases par défaut"/>
          <Button Name="BtnReseau" Content="Carte réseau à la main (tuto)"/>
          <Button Name="BtnImgProtocoles" Content="Capture : protocoles"/>
          <Button Name="BtnImgAvance" Content="Capture : onglet Avancé"/>
          <Button Name="BtnJournal" Content="Ouvrir bagarre.log"/>
        </WrapPanel>
        <Grid>
          <Grid.ColumnDefinitions>
            <ColumnDefinition Width="*"/>
            <ColumnDefinition Width="370"/>
          </Grid.ColumnDefinitions>
          <ScrollViewer Grid.Column="0" VerticalScrollBarVisibility="Auto">
            <StackPanel Name="ListeOptis" Margin="0,0,12,0"/>
          </ScrollViewer>
          <Border Grid.Column="1" Background="#141416" CornerRadius="4" Padding="14">
            <ScrollViewer VerticalScrollBarVisibility="Auto">
              <StackPanel>
                <TextBlock Name="OptiTitre" FontWeight="SemiBold" FontSize="14" TextWrapping="Wrap" Text="Passe la souris sur une case."/>
                <TextBlock Name="OptiEtiquette1" Text="Pourquoi" Style="{StaticResource Etiquette}"/>
                <TextBlock Name="OptiPourquoi" TextWrapping="Wrap" Foreground="#DADADA"/>
                <TextBlock Name="OptiEtiquette2" Text="Ce que tu perds" Style="{StaticResource Etiquette}"/>
                <TextBlock Name="OptiAttention" TextWrapping="Wrap" Foreground="#DADADA"/>
              </StackPanel>
            </ScrollViewer>
          </Border>
        </Grid>
      </DockPanel>

      <DockPanel Name="PageNvidia" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="4. NVIDIA (15 min) : le pilote nu, puis l'ancien Panneau de configuration" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnNvclean" Content="NVCleanstall (winget)" Style="{StaticResource Principal}"/>
          <Button Name="BtnPanneau" Content="Panneau de configuration NVIDIA (Store)"/>
          <Button Name="BtnAfterburner" Content="MSI Afterburner + RivaTuner (winget)"/>
          <Button Name="BtnInspector" Content="NVIDIA Profile Inspector (winget)"/>
          <Button Name="BtnImgNvclean" Content="Capture : NVCleanstall"/>
          <Button Name="BtnImgPanneau" Content="Capture : Panneau NVIDIA"/>
        </WrapPanel>
        <TextBox Name="TexteNvidia"/>
      </DockPanel>

      <DockPanel Name="PageDur" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="5. Dur (20 min) : lis tout avant de toucher" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnIslc" Content="ISLC (winget)"/>
          <Button Name="BtnCompact" Content="CompactGUI (winget)"/>
          <Button Name="BtnAutoGpu" Content="AutoGpuAffinity (dépôt)"/>
          <Button Name="BtnTimerDepot" Content="TimerResolution (dépôt)"/>
        </WrapPanel>
        <TextBox Name="TexteDur"/>
      </DockPanel>

      <DockPanel Name="PageMaintenance" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="6. Maintenance : quand le PC a vécu" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnMeasure" Content="MeasureSleep (vérifier le timer)" Style="{StaticResource Principal}"/>
          <Button Name="BtnCleanmgr" Content="Nettoyage de disque (cleanmgr)"/>
          <Button Name="BtnDismAnalyse" Content="DISM : analyser WinSxS"/>
          <Button Name="BtnDismNettoyer" Content="DISM : nettoyer WinSxS"/>
          <Button Name="BtnTrim" Content="TRIM du disque système"/>
          <Button Name="BtnAutoruns" Content="Autoruns (winget)"/>
          <Button Name="BtnGeek" Content="Geek Uninstaller (winget)"/>
          <Button Name="BtnRapr" Content="DriverStore Explorer (winget)"/>
          <Button Name="BtnBleach" Content="BleachBit (winget)"/>
          <Button Name="BtnCrystal" Content="CrystalDiskInfo (winget)"/>
          <Button Name="BtnFan" Content="FanControl (winget)"/>
          <Button Name="BtnRgb" Content="OpenRGB (winget)"/>
          <Button Name="BtnDdu" Content="DDU (winget)"/>
          <Button Name="BtnCapframe" Content="CapFrameX + PresentMon (winget)"/>
        </WrapPanel>
        <TextBox Name="TexteMaintenance"/>
      </DockPanel>

      <DockPanel Name="PageDns" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="7. DNS : qui répond le plus vite depuis chez toi ?" Style="{StaticResource Titre}"/>
        <TextBlock DockPanel.Dock="Top" Style="{StaticResource Intro}" Text="Le DNS transforme un nom (youtube.com) en adresse IP. Un DNS lent ajoute quelques dizaines de ms à CHAQUE nouveau site ou serveur de jeu contacté. Le test résout 6 noms courants sur chaque serveur, 3 fois, et garde la médiane. Une trentaine de secondes, la fenêtre ne répond pas pendant ce temps."/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnDnsTester" Content="Tester les DNS" Style="{StaticResource Principal}"/>
          <Button Name="BtnDnsAppliquer" Content="Utiliser le DNS sélectionné" IsEnabled="False"/>
        </WrapPanel>
        <TextBlock DockPanel.Dock="Top" Name="DnsCarte" Foreground="#B0B0B8" Margin="0,0,0,8" TextWrapping="Wrap"/>
        <ListBox DockPanel.Dock="Top" Name="DnsListe" Background="#141416" BorderThickness="0" Height="150" FontFamily="Consolas"/>
        <TextBox Name="TexteDns" Margin="0,10,0,0"/>
      </DockPanel>

      <DockPanel Name="PageAudit" Visibility="Collapsed">
        <TextBlock DockPanel.Dock="Top" Text="8. Audit IA (10 min) : une IA vérifie ton PC et trouve ce qui manque" Style="{StaticResource Titre}"/>
        <WrapPanel DockPanel.Dock="Top">
          <Button Name="BtnCollecter" Content="1. Collecter le rapport (30 s, ne modifie rien)" Style="{StaticResource Principal}"/>
          <Button Name="BtnPrompt" Content="2. Copier le prompt d'audit"/>
          <Button Name="BtnDossierAudit" Content="Ouvrir le dossier du rapport"/>
        </WrapPanel>
        <TextBox Name="TexteAudit"/>
      </DockPanel>
    </Grid>

    <DockPanel Grid.Column="1" Grid.Row="1" Margin="20,0,20,14">
      <TextBlock DockPanel.Dock="Top" Text="Journal" Foreground="#8A8A95" Margin="0,0,0,4"/>
      <TextBox Name="Journal" FontSize="12"/>
    </DockPanel>
  </Grid>
</Window>
'@

try {
    $script:Fenetre = [Windows.Markup.XamlReader]::Parse($Xaml)
} catch {
    Add-Content -Path $LogFichier -Value "ÉCHEC fenêtre : $_"
    [Windows.MessageBox]::Show("La fenêtre n'a pas pu s'ouvrir :`n$_`n`nDétail dans $LogFichier", 'bagarre') | Out-Null
    return
}

# Tous les contrôles nommés dans $C, le journal à portée de Log
$script:C = @{}
foreach ($m in [regex]::Matches($Xaml, '(?<![:\w])Name="(\w+)"')) { $n = $m.Groups[1].Value; $C[$n] = $Fenetre.FindName($n) }
$script:Journal = $C.Journal

# ---------------------------------------------------------------------------
# Textes des onglets et navigation
# ---------------------------------------------------------------------------
$C.TexteAccueil.Text = $Textes['accueil']
$C.TexteInstallation.Text = $Textes['installation']
$C.TexteFacile.Text = $Textes['facile']
$C.TexteNvidia.Text = $Textes['nvidia']
$C.TexteDur.Text = $Textes['dur']
$C.TexteMaintenance.Text = $Textes['maintenance']
$C.TexteDns.Text = $Textes['dns']
$C.TexteAudit.Text = $Textes['audit']
$C.NavMachine.Text = "$Machine`nbagarre $Version"

$script:PagesNoms = 'Accueil', 'Installation', 'Facile', 'Optis', 'Nvidia', 'Dur', 'Maintenance', 'Dns', 'Audit'
$C.Nav.Add_SelectionChanged({
    $i = $script:C.Nav.SelectedIndex
    for ($k = 0; $k -lt $script:PagesNoms.Count; $k++) {
        $script:C["Page$($script:PagesNoms[$k])"].Visibility = if ($k -eq $i) { 'Visible' } else { 'Collapsed' }
    }
})

# ---------------------------------------------------------------------------
# Onglet 3 : une case par item du catalogue, l'explication au survol
# ---------------------------------------------------------------------------
function Opti-Montrer($titre, $pourquoi, $attention) {
    $script:C.OptiTitre.Text = $titre
    $script:C.OptiPourquoi.Text = $pourquoi
    $script:C.OptiAttention.Text = if ($attention) { $attention } else { 'Rien de notable.' }
    $script:C.OptiEtiquette2.Visibility = if ($null -eq $attention) { 'Collapsed' } else { 'Visible' }
}

$script:Cases = @{}
$script:Defauts = @{}
$groupe = ''
foreach ($it in $Items) {
    if ($it.Groupe -ne $groupe) {
        $groupe = $it.Groupe
        $tb = New-Object Windows.Controls.TextBlock
        $tb.Text = $groupe
        $tb.Style = $Fenetre.FindResource('Groupe')
        [void]$C.ListeOptis.Children.Add($tb)
    }
    $cb = New-Object Windows.Controls.CheckBox
    $cb.Content = $it.Titre
    $cb.IsChecked = [bool]$it.Coche
    $cb.Tag = $it
    $cb.Add_MouseEnter({ param($s, $e) Opti-Montrer $s.Tag.Titre $s.Tag.Pourquoi $s.Tag.Attention })
    $cb.Add_Checked({ param($s, $e) $s.Tag.Coche = $true })
    $cb.Add_Unchecked({ param($s, $e) $s.Tag.Coche = $false })
    [void]$C.ListeOptis.Children.Add($cb)
    $Cases[$it.Id] = $cb
    $Defauts[$it.Id] = [bool]$it.Coche
}

$C.BtnAppliquer.Add_Click({
    $coches = @($script:Items | Where-Object { $_.Coche })
    if ($coches.Count -eq 0) { Log 'Rien de coché.'; return }
    $q = [Windows.MessageBox]::Show("Appliquer $($coches.Count) réglages ?`n`nL'état d'avant est sauvé dans $EtatFichier, le bouton Tout remettre le restaure.", 'bagarre', 'YesNo', 'Question')
    if ($q -ne 'Yes') { return }
    Appliquer-Items $coches
    [Windows.MessageBox]::Show('Terminé. Redémarre le PC pour que tout prenne effet.', 'bagarre') | Out-Null
})
$C.BtnRestaurer.Add_Click({
    if ($script:Avant.Count -eq 0) { Log 'Rien à restaurer : aucun réglage appliqué sur ce PC.'; return }
    $q = [Windows.MessageBox]::Show("Remettre les $($script:Avant.Count) réglages comme avant ?", 'bagarre', 'YesNo', 'Question')
    if ($q -ne 'Yes') { return }
    Tout-Restaurer
    [Windows.MessageBox]::Show('Restauré. Redémarre le PC.', 'bagarre') | Out-Null
})
$C.BtnDefaut.Add_Click({ foreach ($id in $script:Cases.Keys) { $script:Cases[$id].IsChecked = $script:Defauts[$id] } })
$C.BtnReseau.Add_Click({ Opti-Montrer 'Carte réseau à la main' $Textes['reseau'] $null })
$C.BtnImgProtocoles.Add_Click({ Image-Ouvrir 'reseau-protocoles.png' })
$C.BtnImgAvance.Add_Click({ Image-Ouvrir 'reseau-avance.png' })
$C.BtnJournal.Add_Click({ if (Test-Path $LogFichier) { Start-Process notepad $LogFichier } else { Log 'Pas encore de journal.' } })

# ---------------------------------------------------------------------------
# Onglets 1, 2, 4, 5, 6 : des boutons qui lancent, installent ou ouvrent
# ---------------------------------------------------------------------------
$C.BtnFsutil.Add_Click({ Console-Lancer 'fsutil 8dot3name set 1' 'fsutil 8dot3name set 1; fsutil 8dot3name query' })
$C.BtnWindowsUpdate.Add_Click({ Ouvrir 'ms-settings:windowsupdate' })
$C.BtnSnappy.Add_Click({ Winget-Installer 'Snappy Driver Installer Origin' 'GlennDelahoy.SnappyDriverInstallerOrigin' })

$C.BtnDebloat.Add_Click({ Console-Lancer 'Win11Debloat' '& ([scriptblock]::Create((irm "https://debloat.raphi.re/")))' })
$C.BtnWinUtil.Add_Click({ Console-Lancer 'WinUtil (Chris Titus)' 'irm https://christitus.com/win | iex' })
$C.BtnDirectX.Add_Click({ Winget-Installer 'DirectX' 'Microsoft.DirectX' })
$C.BtnVcredist.Add_Click({
    $ids = foreach ($an in '2005', '2008', '2010', '2012', '2013', '2015+') { "Microsoft.VCRedist.$an.x86"; "Microsoft.VCRedist.$an.x64" }
    Winget-Installer 'Visual C++ 2005 à 2022' $ids
})

$script:Applis = @(
    @{ Nom = 'Steam'; Id = 'Valve.Steam'; Coche = $true }
    @{ Nom = 'Discord'; Id = 'Discord.Discord'; Coche = $true }
    @{ Nom = '7-Zip'; Id = '7zip.7zip'; Coche = $true }
    @{ Nom = 'VLC'; Id = 'VideoLAN.VLC'; Coche = $true }
    @{ Nom = 'Firefox'; Id = 'Mozilla.Firefox'; Coche = $false }
    @{ Nom = 'Brave'; Id = 'Brave.Brave'; Coche = $false }
    @{ Nom = 'Chrome'; Id = 'Google.Chrome'; Coche = $false }
    @{ Nom = 'Everything (recherche de fichiers)'; Id = 'voidtools.Everything'; Coche = $false }
    @{ Nom = 'PowerToys'; Id = 'Microsoft.PowerToys'; Coche = $false }
)
foreach ($a in $Applis) {
    $cb = New-Object Windows.Controls.CheckBox
    $cb.Content = $a.Nom
    $cb.IsChecked = $a.Coche
    $cb.Tag = $a.Id
    $cb.Margin = '0,3,18,3'
    [void]$C.ListeApplis.Children.Add($cb)
}
$C.BtnApplis.Add_Click({
    $ids = @($script:C.ListeApplis.Children | Where-Object { $_.IsChecked } | ForEach-Object { $_.Tag })
    if ($ids.Count -eq 0) { Log 'Aucune appli cochée.'; return }
    Winget-Installer "$($ids.Count) applis" $ids
})

$C.BtnNvclean.Add_Click({ Winget-Installer 'NVCleanstall' 'TechPowerUp.NVCleanstall' })
$C.BtnPanneau.Add_Click({ Console-Lancer 'Panneau de configuration NVIDIA' 'winget install --id 9NF8H0H7WMLT --source msstore --accept-package-agreements --accept-source-agreements' })
$C.BtnAfterburner.Add_Click({ Winget-Installer 'MSI Afterburner et RivaTuner' 'Guru3D.Afterburner', 'Guru3D.RTSS' })
$C.BtnInspector.Add_Click({ Winget-Installer 'NVIDIA Profile Inspector' 'Orbmu2k.nvidiaProfileInspector' })
$C.BtnImgNvclean.Add_Click({ Image-Ouvrir 'nvcleanstall.png' })
$C.BtnImgPanneau.Add_Click({ Image-Ouvrir 'panneau-nvidia.png' })

$C.BtnIslc.Add_Click({ Winget-Installer 'ISLC' 'Wagnardsoft.ISLC' })
$C.BtnCompact.Add_Click({ Winget-Installer 'CompactGUI' 'IridiumIO.CompactGUI' })
$C.BtnAutoGpu.Add_Click({ Ouvrir 'https://github.com/valleyofdoom/AutoGpuAffinity' })
$C.BtnTimerDepot.Add_Click({ Ouvrir 'https://github.com/valleyofdoom/TimerResolution' })

$C.BtnMeasure.Add_Click({
    $exe = Outil-Obtenir 'MeasureSleep.exe'
    if ($exe) { Console-Lancer 'MeasureSleep : attendu environ 0,5 ms, Ctrl+C pour arrêter' "& '$exe'" }
})
$C.BtnCleanmgr.Add_Click({ Start-Process cleanmgr | Out-Null; Log 'console   cleanmgr' })
$C.BtnDismAnalyse.Add_Click({ Console-Lancer 'DISM : analyse de WinSxS' 'Dism /Online /Cleanup-Image /AnalyzeComponentStore' })
$C.BtnDismNettoyer.Add_Click({ Console-Lancer 'DISM : nettoyage de WinSxS (jamais /ResetBase)' 'Dism /Online /Cleanup-Image /StartComponentCleanup' })
$C.BtnTrim.Add_Click({ Console-Lancer 'TRIM du disque système' "Optimize-Volume -DriveLetter $($env:SystemDrive[0]) -ReTrim -Verbose" })
$C.BtnAutoruns.Add_Click({ Winget-Installer 'Autoruns' 'Microsoft.Sysinternals.Autoruns' })
$C.BtnGeek.Add_Click({ Winget-Installer 'Geek Uninstaller' 'GeekUninstaller.GeekUninstaller' })
$C.BtnRapr.Add_Click({ Winget-Installer 'DriverStore Explorer' 'lostindark.DriverStoreExplorer' })
$C.BtnBleach.Add_Click({ Winget-Installer 'BleachBit' 'BleachBit.BleachBit' })
$C.BtnCrystal.Add_Click({ Winget-Installer 'CrystalDiskInfo' 'CrystalDewWorld.CrystalDiskInfo' })
$C.BtnFan.Add_Click({ Winget-Installer 'FanControl' 'Rem0o.FanControl' })
$C.BtnRgb.Add_Click({ Winget-Installer 'OpenRGB' 'OpenRGB.OpenRGB' })
$C.BtnDdu.Add_Click({ Winget-Installer 'Display Driver Uninstaller' 'Wagnardsoft.DisplayDriverUninstaller' })
$C.BtnCapframe.Add_Click({ Winget-Installer 'CapFrameX et PresentMon' 'CXWorld.CapFrameX', 'Intel.PresentMon' })

# ---------------------------------------------------------------------------
# Onglet 7 : DNS
# ---------------------------------------------------------------------------
$script:DnsAdapt = $null
$script:DnsResultats = @()
$C.BtnDnsTester.Add_Click({
    $adapt = Dns-Carte
    if (-not $adapt) { Log 'Aucune carte réseau active trouvée.'; return }
    $script:DnsAdapt = $adapt
    $script:C.DnsCarte.Text = "Carte : $($adapt.Name) ($($adapt.InterfaceDescription)). DNS actuel : $((Dns-Actuels $adapt) -join ', ') (souvent ta box)."
    $script:C.DnsListe.Items.Clear()
    $script:C.BtnDnsAppliquer.IsEnabled = $false
    Log 'Test DNS en cours...'
    $script:DnsResultats = @(Dns-Mesurer $adapt)
    foreach ($r in $script:DnsResultats) { [void]$script:C.DnsListe.Items.Add(('{0,-24} {1,7} ms' -f $r.Nom, $r.Mediane)) }
    $script:C.BtnDnsAppliquer.IsEnabled = $true
    Log 'Test terminé. Sélectionne une ligne puis "Utiliser le DNS sélectionné", ou ne change rien.'
})
$C.BtnDnsAppliquer.Add_Click({
    $i = $script:C.DnsListe.SelectedIndex
    if ($i -lt 0) { Log 'Sélectionne une ligne dans la liste.'; return }
    Dns-Appliquer $script:DnsAdapt $script:DnsResultats[$i]
})

# ---------------------------------------------------------------------------
# Onglet 8 : audit IA
# ---------------------------------------------------------------------------
$script:DossierAudit = Join-Path ([Environment]::GetFolderPath('Desktop')) 'bagarre-audit'
$C.BtnCollecter.Add_Click({
    if (-not (Test-Path $script:DossierAudit)) { New-Item -Path $script:DossierAudit -ItemType Directory -Force | Out-Null }
    [IO.File]::WriteAllText((Join-Path $script:DossierAudit 'AUDIT.txt'), $Textes['audit-prompt'], (New-Object Text.UTF8Encoding $true))
    Log 'Collecte en cours, environ 30 secondes...'
    Collecter-Rapport (Join-Path $script:DossierAudit 'rapport-pc.txt')
    Ouvrir $script:DossierAudit
})
$C.BtnPrompt.Add_Click({ [Windows.Clipboard]::SetText($Textes['audit-prompt']); Log 'Prompt copié dans le presse-papiers. Colle-le dans ton IA avec rapport-pc.txt.' })
$C.BtnDossierAudit.Add_Click({ if (Test-Path $script:DossierAudit) { Ouvrir $script:DossierAudit } else { Log 'Pas encore de rapport : bouton 1 d abord.' } })

# ---------------------------------------------------------------------------
# Mode -Capture dossier : rend chaque onglet en PNG sans afficher la fenêtre ni demander l'admin (preuve visuelle en dev)
# ---------------------------------------------------------------------------
if ($Capture) {
    if (-not (Test-Path $Capture)) { New-Item -Path $Capture -ItemType Directory -Force | Out-Null }
    Log "bagarre $Version, $Machine (capture)"
    $racine = $Fenetre.Content
    $racine.Measure((New-Object Windows.Size 1200, 780))
    $racine.Arrange((New-Object Windows.Rect 0, 0, 1200, 780))
    Opti-Montrer $Items[0].Titre $Items[0].Pourquoi $Items[0].Attention   # le volet d'explication rempli, comme au survol
    for ($k = 0; $k -lt $PagesNoms.Count; $k++) {
        $C.Nav.SelectedIndex = $k
        $racine.UpdateLayout()
        $bmp = New-Object Windows.Media.Imaging.RenderTargetBitmap 1200, 780, 96, 96, ([Windows.Media.PixelFormats]::Pbgra32)
        $bmp.Render($racine)
        $enc = New-Object Windows.Media.Imaging.PngBitmapEncoder
        $enc.Frames.Add([Windows.Media.Imaging.BitmapFrame]::Create($bmp))
        $fs = [IO.File]::Create((Join-Path $Capture ('{0}-{1}.png' -f $k, $PagesNoms[$k].ToLower())))
        $enc.Save($fs); $fs.Close()
    }
    Write-Host "Captures dans $Capture"
    return
}

Log "bagarre $Version, $Machine"
if ($Avant.Count -gt 0) { Log "$($Avant.Count) réglages déjà appliqués sur ce PC (bagarre-avant.json). Tout remettre les restaure." }
$Fenetre.ShowDialog() | Out-Null
