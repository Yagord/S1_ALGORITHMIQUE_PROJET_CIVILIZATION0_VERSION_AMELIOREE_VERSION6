unit UnitSave;

interface

uses unitRecord;

procedure load(var g: Game); // charge le fichier de base

procedure loadFile(var g: Game; nomLoad: string); // charge le fichier 'nomLoad'

procedure gestionLoad(var g: Game); // gère le menu de load

procedure save(g: Game); // sauvegarde la partie dans le fichier de base

procedure saveFile(g: Game; nomSave: string); // save la partie dans 'nomSave'

procedure gestionSave(var g: Game; var cancel: boolean); // gère le menu de sauvegarde

implementation

uses UnitAffichage, GestionEcran, System.SysUtils;

procedure save(g: Game);
// sauvegarde la partie dans le fichier de base
var
  f: file of Game;
begin
  assign(f, 'dataGame.bin');
  rewrite(f);
  write(f, g);
  close(f);
end;

procedure saveFile(g: Game; nomSave: string);
// save la partie dans 'nomSave'
var
  f: file of Game;
begin
  assign(f, nomSave);
  rewrite(f);
  write(f, g);
  close(f);
end;

procedure gestionSave(var g: Game; var cancel: boolean);
// gère le menu de sauvegarde
var
  choixSave: string;
  nomSave: string; // le nom du fichier de sauvegarde
begin
  afficheSave(4 * g.Civilisations[1].nbville);
  readln(choixSave);
  // si sauvegarde
  if choixSave = '1' then
  begin
    deplacerCurseurXY(4, 22 + 4 * g.Civilisations[1].nbville);
    write('Nommmez votre sauvegarde : ');
    readln(nomSave);
    saveFile(g, nomSave);
  end
  // si annulation
  else if choixSave <> '2' then
  begin
    cancel := true;
  end;
end;

procedure load(var g: Game);
// charge le fichier de base
var
  f: file of Game;
begin
  assign(f, 'dataGame.bin');
  reset(f);
  read(f, g);
  close(f);
end;

procedure loadFile(var g: Game; nomLoad: string);
// charge le fichier 'nomLoad'
var
  f: file of Game;
begin
  assign(f, nomLoad);
  reset(f);
  read(f, g);
  close(f);

end;

procedure gestionLoad(var g: Game);
// gère le menu de load
var
  filename: string; // le nom du fichier de sauvegarde
begin
  deplacerCurseurXY(5, 29);
  write('Quelle sauvegarde chargez : ');
  readln(filename);
  // si le fichier existe
  if FileExists(filename) then
  begin
    loadFile(g, filename); // chargement du jeu
    g.fini := False; // initialisation de la varaible de lancement du jeu
  end
  else
  begin
    g.fini := true;
    deplacerCurseurXY(5, 31);
    write('Le fichier n''existe pas');
    readln;
  end;

end;

end.
