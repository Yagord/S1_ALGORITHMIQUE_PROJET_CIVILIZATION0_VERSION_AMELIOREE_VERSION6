unit UnitRecherche;

interface

uses UnitRecord;

function peutRechercherRecherche(c: Civilisation; recherche: integer): string;
// retourne si la civilisation peut faire la recherche 'recherche'
function peutRechercher(c: Civilisation): boolean;
// retourner si la civilisation peut faire une recherche
function prerequis(r: integer; t: array of recherche): boolean;
// retourne si la recherche 'r' a ses prérequis de validées
procedure initRecherche(var c: Civilisation);
// initialise les recherches de la civilisation 'c'

implementation

uses UnitConst;

function prerequis(r: integer; t: array of recherche): boolean;
// retourne si la recherche 'r' a ses prérequis de validées
var
  i: integer;
  verif: boolean;
begin
  r := r - 1;
  verif := true;
  for i := 1 to length(t[r].prerequis) do
  begin
    if t[r].prerequis[i] <> -1 then
    begin
      if not t[t[r].prerequis[i] - 1].fini then
        verif := false;
    end;
  end;
  result := verif;
end;

function peutRechercherRecherche(c: Civilisation; recherche: integer): string;
// retourne si la civilisation peut faire la recherche 'recherche'
var
  rech: string; // chaine de caractère contenant TRUE si la recherche est possible sinon un code erreur
begin

  rech := 'TRUE';

  // si pas de recherche en cours
  if c.rechercheCourante = -1 then
  begin
    // si les prérequis sont verifiés
    if prerequis(recherche, c.recherches) then
    begin
      if c.recherches[recherche].fini then
        rech := 'Recherche déjà effectué';
    end
    else
      rech := 'Vous n''avez pas les prérequis';
  end
  else
    rech := 'Une recherche est déjà en cours';

  result := rech;

end;

function peutRechercher(c: Civilisation): boolean;
// retourner si la civilisation peut faire une recherche
var
  i: integer; // compteur
  rech: boolean; // boolean indiquant si la recherceh est possible
begin

  rech := false;
  for i := 1 to NOMBRE_RECHERCHE do
  begin

    if peutRechercherRecherche(c, i) = 'TRUE' then
    begin
      rech := true;
    end;

  end;

  result := rech;

end;

procedure initRecherche(var c: Civilisation);
// initialise les recherches de la civilisation 'c'
var
  i, j: integer;
  n: integer;
begin

  // information par defaut
  for i := 1 to NOMBRE_RECHERCHE do
  begin
    c.recherches[i].titre := 'Une recherche';
    c.recherches[i].description := 'Petit message de description';
    c.recherches[i].cout := 5;
    c.recherches[i].fini := false;
    for j := 1 to 3 do
    begin
      c.recherches[i].prerequis[j] := -1;
    end;
    for j := 1 to 3 do
    begin
      c.recherches[i].effet[j] := '';
    end;

    for j := 1 to 28 do
    begin
      c.recherches[i].ratio[j] := 1;
    end;

    for j := 1 to 28 do
    begin
      c.recherches[i].bonus[j] := 0;
    end;
  end;

  // ------ Remplissage de toute les recherches --------

  n := 1;
  c.recherches[n].titre := 'Forge';
  c.recherches[n].description := 'Meilleur traitement des métaux';
  c.recherches[n].cout := 5;
  c.recherches[n].effet[1] := '+10% degats des soldats';
  c.recherches[n].ratio[9] := 1.1;

  n := 2;
  c.recherches[n].titre := 'Métallurgie';
  c.recherches[n].description := 'Vos soldats seront equipés de meilleures armes et armures';
  c.recherches[n].cout := 10;
  c.recherches[n].prerequis[1] := 1;
  c.recherches[n].effet[1] := '+15% degats des soldats';
  c.recherches[n].effet[1] := '+15% vie des soldats';
  c.recherches[n].ratio[9] := 1.15;
  c.recherches[n].ratio[24] := 1.15;

  n := 3;
  c.recherches[n].titre := 'Encyclopédie';
  c.recherches[n].description := 'Le savoir c''est le pouvoir';
  c.recherches[n].cout := 15;
  c.recherches[n].effet[1] := '+1 point de recherche par tour';
  c.recherches[n].bonus[20] := 1;

  n := 4;
  c.recherches[n].titre := 'Etude des sols';
  c.recherches[n].description := 'Permet une meilleure exploitation agricole';
  c.recherches[n].cout := 10;
  c.recherches[n].effet[1] := '+50% production nourriture';
  c.recherches[n].effet[2] := '+1 production de nourriture';
  c.recherches[n].ratio[13] := 1.5;
  c.recherches[n].bonus[13] := 1;

  n := 5;
  c.recherches[n].titre := 'Herbologie';
  c.recherches[n].description := 'Une étude très poussée des fleurs pour rendre vos jardins plus beaux';
  c.recherches[n].cout := 10;
  c.recherches[n].effet[1] := '+10% bonheur sur les jardin';
  c.recherches[n].ratio[7] := 1.1;

  n := 6;
  c.recherches[n].titre := 'Architecture';
  c.recherches[n].description := '';
  c.recherches[n].cout := 25;
  c.recherches[n].effet[1] := '+50% vitesse de construction';
  c.recherches[n].ratio[15] := 1.5;

  n := 7;
  c.recherches[n].titre := 'Enrôlement';
  c.recherches[n].description := '';
  c.recherches[n].cout := 15;
  c.recherches[n].effet[1] := '+1 point de recrutement par tour';
  c.recherches[n].bonus[21] := 1;

  n := 8;
  c.recherches[n].titre := 'Multitâche';
  c.recherches[n].description := '';
  c.recherches[n].cout := 50;
  c.recherches[n].effet[1] := '+1 construction possible';
  c.recherches[n].bonus[17] := 1;

  n := 9;
  c.recherches[n].titre := 'Camp entrainement';
  c.recherches[n].description := '';
  c.recherches[n].cout := 25;
  c.recherches[n].effet[1] := '+10% dégats des unités';
  c.recherches[n].ratio[23] := 1.1;

  n := 10;
  c.recherches[n].titre := 'Route commerciale';
  c.recherches[n].description := '';
  c.recherches[n].cout := 25;
  c.recherches[n].effet[1] := '+1 or par marché';
  c.recherches[n].bonus[6] := 1;

  n := 11;
  c.recherches[n].titre := 'Religion';
  c.recherches[n].description := '';
  c.recherches[n].cout := 40;
  c.recherches[n].effet[1] := '+5% de bonheur';
  c.recherches[n].bonus[19] := 5;

  n := 12;
  c.recherches[n].titre := 'Emissaire';
  c.recherches[n].description := '';
  c.recherches[n].cout := 35;
  c.recherches[n].effet[1] := '+1 action diplomatique';
  c.recherches[n].bonus[22] := 1;
  c.recherches[n].prerequis[1] := 3;

  n := 13;
  c.recherches[n].titre := 'Autodafé';
  c.recherches[n].description := 'Plus un peuple est idiot, plus il est heureux';
  c.recherches[n].cout := 40;
  c.recherches[n].effet[1] := '+10 point de bonheur';
  c.recherches[n].effet[2] := '-1 point de recherche';
  c.recherches[n].bonus[19] := 10;
  c.recherches[n].bonus[20] := -1;
  c.recherches[n].prerequis[1] := 11;

  n := 14;
  c.recherches[n].titre := 'Autosuffisance';
  c.recherches[n].description := 'Votre population produit sa propre nourriture';
  c.recherches[n].cout := 50;
  c.recherches[n].effet[1] := '+1 nourriture par habitant';
  c.recherches[n].bonus[27] := 1;
  c.recherches[n].prerequis[1] := 4;

  n := 15;
  c.recherches[n].titre := 'Ninja';
  c.recherches[n].description := 'Vos soldats deviennent des maîtres de la discrétion, facilitant ainsi les vols';
  c.recherches[n].cout := 15;
  c.recherches[n].effet[1] := '+20% reussite vol';
  c.recherches[n].bonus[26] := 20;
  c.recherches[n].prerequis[1] := 9;

  n := 16;
  c.recherches[n].titre := 'Intérêt';
  c.recherches[n].description := 'Votre argent travaille pour vous';
  c.recherches[n].cout := 20;
  c.recherches[n].effet[1] := '+5 or par tour';
  c.recherches[n].bonus[18] := 5;
  c.recherches[n].prerequis[1] := 10;
  c.recherches[n].prerequis[2] := 3;

  n := 17;
  c.recherches[n].titre := 'Nutrition';
  c.recherches[n].description := 'Votre population est en meilleure santé';
  c.recherches[n].cout := 30;
  c.recherches[n].effet[1] := '+25% vitesse de croissance';
  c.recherches[n].ratio[14] := 0.5;

  n := 18;
  c.recherches[n].titre := 'Impôts';
  c.recherches[n].description := 'Vous avez convaincu la population qu''elle devait vous donner de l''argent pour son bien';
  c.recherches[n].cout := 50;
  c.recherches[n].effet[1] := '+1 or par population';
  c.recherches[n].bonus[28] := 1;
  c.recherches[n].prerequis[1] := 16;

end;

end.
