unit UnitMilitaire;

interface

uses UnitRecord;

function peutRecruter(c: Civilisation): boolean;
// retourne si la civilisation peut recruter
function peutRecruterUnite(c: Civilisation; unite: integer): string;
// retourne si la civilisation peut recruter l'unité 'unite', et renvoie un code erreur sinon
procedure recruter(var c: Civilisation; unite: integer);
// recrute une unité de type 'unite' pour la civilisation 'c'
procedure attaquerBarbare(var g: Game; var c: Civilisation; niveau: integer; nom: string);
// commence un combat contre un camp de barbare de rang 'niveau' et de nom 'nom'
procedure attaquerVille(var g: Game; var c: Civilisation);
// attaque une ville
procedure pillageVille(var g: Game; var c: Civilisation);
// pille une ville
procedure attaqueDeBarbare(var g: Game; var v: Ville);
// lance une attaque barbare contre la ville 'v'
procedure attaqueDeCivilisation(var g: Game; var c: Civilisation; var v: Ville);
// lance un combat de la civilisation 'c' contre votre ville 'v'
function totalSoldat(t: Troupe): integer;
// renvoie le nombre de soldat d'une troupe 't'
function nomUnite(code: integer): string;
// renvoie le nom de l'unité d'id 'code'
function longueurMaxUnite: integer;
// renvoie la taille du plus grand nom d'unité
function combat(var g: Game; var t: Troupe; var tE: Troupe): boolean;
// commence un combat contre la troupe 'tE' avec la troupe 't' et retourne Vrai si c'est une victoire

implementation

uses UnitConst, UnitVille, UnitAffichage, Math, GestionEcran, System.SysUtils,
  typinfo;

function numCivilisation(g: Game; nom: string): integer;
// renvoie le numéro de la civilisation de nom 'nom'
var
  i: integer; // compteur
  num: integer; // numéro civilisation
begin
  num := -1;
  for i := 1 to 5 do
  begin
    if g.Civilisations[i].nom = nom then
      num := i;
  end;
  result := num;
end;

function numVille(g: Game; nom: string): integer;
// renvoie le numéro de la ville de nom 'nom'
var
  i, j: integer; // compteur
  num: integer; // numéro ville
begin
  num := -1;
  for i := 1 to 5 do
  begin
    for j := 1 to g.Civilisations[i].nbVille do
    begin
      if lowercase(g.Civilisations[i].Ville[j].nom) = lowercase(nom) then
        num := j;
    end;
  end;
  result := num;
end;

function longueurMaxUnite: integer;
// renvoie la taille du plus grand nom d'unité
var
  i: integer; // compteur
  max: integer; // la longeur a renvoyer
begin
  max := 0;
  for i := 1 to NOMBRE_UNITE do
  begin
    if length(LISTE_UNITE[i]) > max then
    begin
      max := length(LISTE_UNITE[i]);
    end;
  end;

  result := max;
end;

function nomUnite(code: integer): string;
// renvoie le nom de l'unité d'id 'code'
begin
  result := LISTE_UNITE[code];
end;

function codeUnite(nom: string): integer;
// renvoie le code de l'unité de nom 'nom'
var
  i: integer; // compteur
  pos: integer; // le code a renvoyer
begin
  pos := -1;
  for i := 1 to length(LISTE_UNITE) do
  begin
    if LISTE_UNITE[i] = nom then
      pos := i;
  end;
  result := pos;
end;

function peutRecruterUnite(c: Civilisation; unite: integer): string;
// retourne si la civilisation peut recruter l'unité 'unite', et renvoie un code erreur sinon
var
  recrut: string; // le message a retourner
begin

  recrut := 'TRUE';

  // si assez d'argent
  if c.argent >= COUT_UNITE_OR[unite] then
  begin
    // si assez de point
    if c.recrutement >= COUT_UNITE[unite] then
    begin
      // si caserne
      if (unite = codeUnite('Soldat')) and (niveauBatimentTotal(c, codeBatiment('Caserne')) < 1) then
      begin
        recrut := 'Pas de caserne';
      end
      // si caserne lvl 2
      else if (unite = codeUnite('Cavalier')) and (niveauBatimentTotal(c, codeBatiment('Caserne')) < 2) then
      begin
        recrut := 'Caserne niv.2 requise';
      end
      // si mine
      else if (unite = codeUnite('Canon')) and (niveauBatimentTotal(c, codeBatiment('Mine')) < 1) then
      begin
        recrut := 'Pas de mine';
      end
      else
      begin
        recrut := 'TRUE';
      end;
    end
    else
    begin
      recrut := 'Pas de point de recrutement';;
    end;
  end
  else
  begin
    recrut := 'Pas assez d''or';
  end;

  result := recrut;

end;

function peutRecruter(c: Civilisation): boolean;
// retourne si la civilisation peut recruter
var
  i: integer; // compteur
  recrut: boolean; // boolean indiquant si le recrutement est possible
begin

  recrut := false;
  for i := 1 to NOMBRE_UNITE do
  begin

    if peutRecruterUnite(c, i) = 'TRUE' then
    begin
      recrut := true;
    end;

  end;

  result := recrut;

end;

procedure recruter(var c: Civilisation; unite: integer);
// recrute une unité de type 'unite' pour la civilisation 'c'
var
  recrut: string; // si le recrutement est possible
begin

  recrut := peutRecruterUnite(c, unite);

  // si ok on recrute
  if recrut = 'TRUE' then
  begin
    c.Troupe.unites[unite] := c.Troupe.unites[unite] + 1;
    c.recrutement := c.recrutement - COUT_UNITE[unite];
    c.argent := c.argent - round((COUT_UNITE_OR[unite] + c.bonus[25]) * c.ratio[25]);
  end
  else
  begin
    messageGlobal := recrut;
  end;

end;

function totalSoldat(t: Troupe): integer;
// renvoie le nombre de soldat d'une troupe 't'
var
  nb: integer; // variable qui compte le nombre de soldats
  i: integer; // compteur
begin
  nb := 0;
  for i := 1 to length(t.unites) do
  begin
    nb := nb + t.unites[i];
  end;

  result := nb;
end;

function puissanceTroupe(t: Troupe): integer;
// renvoie la puissance d'une troupe
var
  puissance: integer;
  i: integer; // compteur
begin
  puissance := 0;
  // ajoute la puissance de chaque type d'unites x leur quantité
  for i := 1 to length(t.unites) do
  begin
    puissance := puissance + t.unites[i] * PUISSANCE_UNITE[i];
  end;

  if t.origine = nil then
    result := puissance
    // si c'est une civilisation il y a des bonus de recherche
  else
    result := round((puissance + t.origine^.bonus[23]) * t.origine^.ratio[23]);

end;

procedure remplirTroupeBarbare(g: Game; var t: Troupe; niveau: integer; nom: string);
// remplie de manière aléatoire un camps de barbare
var
  i: integer; // compteur
begin
  for i := 1 to NOMBRE_UNITE do
  begin
    t.unites[i] := (random(RANDOM_BARBARE[i]) + MINIMUM_BARBARE[i]) * niveau * g.difficulte;
  end;
  t.nom := nom;
  t.origine := nil;
end;

function combat(var g: Game; var t: Troupe; var tE: Troupe): boolean;
// commence un combat contre la troupe 'tE' avec la troupe 't' et retourne Vrai si c'est une victoire
var
  cibleCorrecte: boolean; // boolean indiquant si une cible est correcte ou non
  saisie: char; // la saisie utilisateur
  cible: integer; // la cible visée par une attaque (1:soldat, 2:canon ...)
  kill: integer; // entier représentant le nombre de victime faite par une attaque
  str: string; // chaine représentant le message du popup de fin
begin

  Randomize;

  while (totalSoldat(tE) > 0) AND (totalSoldat(t) > 0) do
  begin

    // on demande une cible jusqu'a ce qu'elle soit correcte
    cibleCorrecte := false;
    repeat
      afficheCombat(g, t, tE);
      readln(saisie);
      if (saisie >= '1') and (saisie <= '9') then
      begin
        cible := StrToInt(saisie);
        if (cible >= 1) and (cible <= NOMBRE_UNITE) and (tE.unites[cible] > 0) then
          cibleCorrecte := true
        else
          messageGlobal := 'Cible incorrecte';
      end
      else
        messageGlobal := 'Cible incorrecte';

    until cibleCorrecte;

    // calcul le nombre de morts, si civilisation, bonus de recherche
    if tE.origine <> nil then
      kill := random(ceil(puissanceTroupe(t) / round((VIE_UNITE[cible] + tE.origine^.bonus[24]) * tE.origine^.ratio[24])))
    else
      kill := random(ceil(puissanceTroupe(t) / VIE_UNITE[cible]));

    messageCombat := 'Vous demander à vos troupe d''attaquer les ';
    messageCombat := messageCombat + lowercase(nomUnite(cible)) + 's ';

    // calcul le nombre de kills au nombre d'unités au maximum
    kill := max(0, min(tE.unites[cible], kill));
    tE.unites[cible] := tE.unites[cible] - kill;

    messageCombat := messageCombat + 'ennemis et elles en tuent ' + IntToStr(kill) + '.';

    // choix cible ennemie
    cibleCorrecte := false;
    repeat
      sleep(10);
      cible := random(NOMBRE_UNITE) + 1;
      if t.unites[cible] > 0 then
        cibleCorrecte := true;
    until cibleCorrecte;

    sleep(100);
    // nombre de mort, bonus de recherche
    kill := random(ceil(puissanceTroupe(tE) / round((VIE_UNITE[cible] + t.origine^.bonus[24]) * t.origine^.ratio[24])));

    messageCombat := messageCombat + 'Les forces ennemies attaquent vos ';

    // calcul le nombre de kills au nombre d'unités au maximum
    kill := max(0, min(t.unites[cible], kill));
    t.unites[cible] := t.unites[cible] - kill;
    messageCombat := messageCombat + lowercase(nomUnite(cible)) + 's ';

    messageCombat := messageCombat + 'et elles en tuent ' + IntToStr(kill) + '.';

  end;

  str := 'Combat contre : ' + tE.nom;

  // si le combat est perdu
  if totalSoldat(t) = 0 then
  begin
    affichePopup(g, str, 'Vous avez perdu le combat');
    messageCombat := '';
    result := false;
  end
  // si le combat est gagné
  else
  begin
    affichePopup(g, str, 'Vous avez gagnez le combat');
    messageCombat := '';
    result := true;
  end;
end;

procedure attaquerBarbare(var g: Game; var c: Civilisation; niveau: integer; nom: string);
// commence un combat contre un camps de barbare de rang 'niveau' et de nom 'nom'
var
  troupeE: Troupe; // la troupe ennemie
  gain: integer; // l'or trouvé si victoire
  victoire: boolean; // si le combat est un succès
begin

  Randomize;

  remplirTroupeBarbare(g, troupeE, niveau, nom);

  victoire := combat(g, c.Troupe, troupeE);

  // si victoire gain d'argent
  if victoire then
  begin
    gain := random(50) * niveau;
    c.argent := c.argent + gain;
    affichePopup(g, 'Combat contre : ' + troupeE.nom, 'Vous trouver ' + IntToStr(gain) + ' pièces d''or');
  end;

end;

procedure attaquerVille(var g: Game; var c: Civilisation);
// attaque une ville
var
  nom: string; // le nom de la ville a attaquer
  victoire: boolean; // si le combat est un succés
  cE: PCivilisation; // le pointeur vers la cible
begin

  nom := afficheQuestion('Quelle ville attaquer ?');

  cE := proprietaire(g, nom);

  // si la ville existe
  if (cE <> nil) and (cE^.nom <> c.nom) then
  begin
    // passe en guerre
    c.relation[numCivilisation(g, cE^.nom)] := c.relation[numCivilisation(g, cE^.nom)] - min(99, cE^.relation[1]);
    cE^.relation[1] := cE^.relation[1] - min(99, cE^.relation[1]);

    victoire := combat(g, c.Troupe, cE^.Troupe);

    // si victoire capture de la ville
    if victoire then
    begin
      affichePopup(g, 'Combat contre : ' + cE^.Troupe.nom, 'Vous avez conquis ' + nom + ' !');

      c.Ville[c.nbVille + 1] := cE^.Ville[1];
      c.nbVille := c.nbVille + 1;
      cE^.nbVille := cE^.nbVille - 1;

      affichePopup(g, 'Combat contre : ' + cE^.Troupe.nom, 'Vous trouver ' + IntToStr(cE^.argent) + ' pièces d''or');
      c.argent := c.argent + cE^.argent;
      cE^.argent := 0;
    end;
  end
  else
  begin
    messageGlobal := 'Cette ville n''existe pas';
  end;

end;

procedure pillageVille(var g: Game; var c: Civilisation);
// pille une ville
var
  nom: string; // le nom de la ville à piller
  cE: PCivilisation; // le pointeur vers la cible
begin

  Randomize;

  nom := afficheQuestion('Quelle ville piller ?');

  cE := proprietaire(g, nom);

  // si la ville existe
  if (cE <> nil) and (cE^.nom <> c.nom) then
  begin

    if random(100) >= 50 - c.bonus[26] then
    begin
      affichePopup(g, 'Pillage de : ' + cE^.Ville[numVille(g, nom)].nom, 'Vous trouver ' + IntToStr(round(cE^.argent * 0.5)) + ' pièces d''or');
      c.argent := c.argent + round(cE^.argent * 0.5);
      cE^.argent := cE^.argent - round(cE^.argent * 0.5);
    end
    else
    begin
      affichePopup(g, 'Pillage de : ' + cE^.Ville[numVille(g, nom)].nom, 'Votre voleur a été capturé');
      c.relation[numCivilisation(g, cE^.nom)] := c.relation[numCivilisation(g, cE^.nom)] - min(cE^.relation[1], 34);
      cE^.relation[1] := cE^.relation[1] - min(cE^.relation[1], 34);
    end;

  end
  else
  begin
    messageGlobal := 'Cette ville n''existe pas';
  end;

end;

function minimum(v: Ville): integer;
// renvoie la vie du batiment qui a le moins de vie
var
  i: integer; // compteur
  mini: integer; // le minimum à renvoyer
begin
  mini := 10000;
  for i := 1 to NOMBRE_BATIMENT do
  begin
    if (VIE_BATIMENT[i] < mini) and (v.batiments[i] > 0) then
      mini := VIE_BATIMENT[i];
  end;
  result := mini;
end;

procedure attaqueDeBarbare(var g: Game; var v: Ville);
// lance une attaque de barbare contre la ville 'v'
var
  tE: Troupe; // la troupe barbare
  victoire: boolean; // victoire ou non
  puissanceRestante: integer; // la puissance de la troupe barbare si elle entre dans la ville
  bat: integer; // le bâtiment à detruire
begin

  Randomize;

  affichePopup(g, '', 'Les barbares attaquent ' + v.nom + ' !');
  remplirTroupeBarbare(g, tE, 1, 'Troupe barbare');

  victoire := combat(g, g.Civilisations[1].Troupe, tE);

  // si defaite
  if not victoire then
  begin
    puissanceRestante := puissanceTroupe(tE);
    affichePopup(g, '', 'Les barbares envahissent la ville !');
    // destruction des batiments
    repeat
      bat := random(NOMBRE_BATIMENT) + 1;
      attendre(1);
      if (v.batiments[bat] > 0) and (puissanceRestante >= VIE_BATIMENT[bat]) then
      begin
        puissanceRestante := puissanceRestante - VIE_BATIMENT[bat];
        v.batiments[bat] := v.batiments[bat] - 1;
        affichePopup(g, '', 'Batiment détruit : ' + nomBatiment(bat) + ' (niveau ' + IntToStr(v.batiments[bat] + 1) + ')');
      end;
    until (puissanceRestante < minimum(v)) or (nombreBatimentFini(v) = 0);

    // si plus aucune bâtiment, tue la population
    if nombreBatimentFini(v) = 0 then
    begin
      affichePopup(g, '', 'Population tuée : ' + IntToStr(min(v.population, floor(puissanceRestante / 10))));
      v.population := v.population - min(v.population, floor(puissanceRestante / 10));
    end;

  end;

end;

procedure attaqueDeCivilisation(var g: Game; var c: Civilisation; var v: Ville);
// lance un combat de la civilisation 'c' contre votre ville 'v'
var
  victoire: boolean; // victoire ou non
  puissanceRestante: integer; // la puissance de la troupe si elle entre dans la ville
  bat: integer; // le bâtiment à détruire
begin

  Randomize;

  affichePopup(g, '', c.nom + ' attaque ' + v.nom + ' !');

  victoire := combat(g, g.Civilisations[1].Troupe, c.Troupe);

  // si defaite
  if not victoire then
  begin
    puissanceRestante := puissanceTroupe(c.Troupe);
    affichePopup(g, '', 'Votre ville est envahis !');
    // destruction des bâtiments
    repeat
      bat := random(NOMBRE_BATIMENT) + 1;
      attendre(1);
      if (v.batiments[bat] > 0) and (puissanceRestante >= VIE_BATIMENT[bat]) then
      begin
        puissanceRestante := puissanceRestante - VIE_BATIMENT[bat];
        v.batiments[bat] := v.batiments[bat] - 1;
        affichePopup(g, '', 'Batiment détruit : ' + nomBatiment(bat) + ' (niveau ' + IntToStr(v.batiments[bat] + 1) + ')');
      end;
    until (puissanceRestante < minimum(v)) or (nombreBatimentFini(v) = 0);

    // si plus aucun bâtiment, tue la population
    if nombreBatimentFini(v) = 0 then
    begin
      affichePopup(g, '', 'Population tuée : ' + IntToStr(min(v.population, floor(puissanceRestante / 10))));
      v.population := v.population - min(v.population, floor(puissanceRestante / 10));
    end;

  end;

end;

end.
