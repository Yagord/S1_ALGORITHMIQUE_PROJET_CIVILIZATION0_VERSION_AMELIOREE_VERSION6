program CivilizationUpgrade;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  Windows,
  MMSystem,
  GestionEcran in 'GestionEcran.pas',
  UnitAffichage in 'UnitAffichage.pas',
  UnitUpdate in 'UnitUpdate.pas',
  UnitRecord in 'UnitRecord.pas',
  UnitInit in 'UnitInit.pas',
  UnitGestion in 'UnitGestion.pas',
  UnitVille in 'UnitVille.pas',
  UnitMilitaire in 'UnitMilitaire.pas',
  UnitConst in 'UnitConst.pas',
  UnitSave in 'UnitSave.pas',
  UnitRecherche in 'UnitRecherche.pas',
  UnitSprite in 'UnitSprite.pas';

var
  Jeu: Game; // le jeu qui contient toute les données d'une partie
  choix: char; // le caractère saisie par l'utilisateur dans les menu

begin
  playSound('Intro.wav', 0, SND_ASYNC); // on joue un son d'introduction en arrière plan une seule fois
  gestionSprite(3,3000); // on appelle la procédure d'animation à 3 fps pendant 3 secondes
  Jeu.fini := true;

  repeat
    gestionAcceuil(Jeu,choix); // on gère le menu accueil

    while (Jeu.fini = False) do // boucle tant que le jeu n'est pas fini représentant un tour de jeu
    begin
      gestionCivilisation(Jeu, Jeu.civilisations[1]); // on gère notre civilisation

      if not Jeu.fini then
        updateGame(Jeu); // quand le tour est fini on update le jeu et recommence un tour
    end;

    reset(Jeu);

  until choix = '3'; // on recommence jusqu'à ce que le joueur quitte le jeu

end.
