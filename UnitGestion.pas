unit UnitGestion;

interface

uses UnitRecord;

procedure gestionAcceuil(var g: Game; var choix: char);
// gère les actions à partir du menu principal
procedure gestionCivilisation(var g: Game; var c: Civilisation);
// gère les actions à partir de l'écran de civilisation
procedure gestionChoixDifficulte(var g: Game);
// gère les actions à partir du menu de choix de difficulté
procedure gestionChoixAttaque(var g: Game);
// gère les actions à partir du menu de choix des attaques barbares
procedure gestionChoixCivilisation(var g: Game);
// gère les actions à partir du menu de choix de civilisation
procedure reset(var g: Game);
// reset le jeu a la fin d'une partie

implementation

uses UnitMilitaire, UnitAffichage, UnitVille, UnitConst,
  UnitRecherche, UnitSave, UnitInit, math, GestionEcran, System.SysUtils;

function valideInt(str: string): boolean;
// renvoie si une chaine de caractère est bien un nombre
var
  valide: boolean;
  i: integer;
begin
  valide := true;
  // pour chaque caractere on verifie si celui-ci est un chiffre
  for i := low(str) to high(str) do
  begin
    if not((str[i] >= '0') and (str[i] <= '9')) then
    begin
      valide := false;
    end;
    result := valide;
  end;
end;

procedure gestionMilitaire(var g: Game; var c: Civilisation);
// gère les actions à partir du menu militaire
var
  choix: char; // caractère saisi par l'utilisateur
  niveau: string;
begin
  repeat
    repeat
      afficheMilitaire(g, c);
      readln(choix);
    until (choix >= '0') and (choix <= '9');

    case StrToInt(choix) of
      // recrutement
      1 .. NOMBRE_UNITE:
        begin
          recruter(c, StrToInt(choix));
        end;

      // attaque
      NOMBRE_UNITE + 1 .. NOMBRE_UNITE + 2:
        begin
          if totalSoldat(c.Troupe) > 0 then
          begin
            // attaque contre barabre
            if StrToInt(choix) = NOMBRE_UNITE + 1 then
            begin
              niveau := afficheQuestion('Niveau du camps à attaquer (1..3)');
              if valideInt(niveau) then
                if (StrToInt(niveau) >= 1) AND (StrToInt(niveau) <= 3) then
                  attaquerBarbare(g, c, StrToInt(niveau), 'Camps barbare');
            end
            // attaque contre ville
            else if StrToInt(choix) = NOMBRE_UNITE + 2 then
            begin
              attaquerVille(g, c);
            end
          end
          else
          begin
            messageGlobal := ' Aucune troupe ';
          end;
        end;

      NOMBRE_UNITE + 3:
        begin
          // pillage ville
          if StrToInt(choix) = NOMBRE_UNITE + 3 then
          begin
            pillageVille(g, c);
          end;
        end;
    end;
  until (choix = '0');
end;

procedure gestionVille(var g: Game; var c: Civilisation; var v: ville);
// gère les actions à partir du menu de ville
var
  choix: char; // caractère saisi par l'utilisateur
begin
  repeat
    afficheVille(g, c, v);
    readln(choix);

    // construction
    if (choix >= '1') and (choix <= IntToStr(length(v.batiments))) then
    begin
      // si aucune construction en cours
      if v.construction = -1 then
      begin
        // si assez de population
        if sommeBatiment(v) < round((v.population + c.bonus[17]) * c.ratio[17]) then
        begin
          // construction étable sous condition
          if choix = IntToStr(codeBatiment('Etable')) then
          begin
            if v.batiments[codeBatiment('Etable')] < v.batiments[codeBatiment('Ferme')] then
              v.construction := StrToInt(choix)
            else
              messageGlobal := 'Impossible ferme niveau insuffisant';
          end
          else
            v.construction := StrToInt(choix);
        end
        else
          messageGlobal := 'Impossible population insuffisante';
      end
      else if (v.construction = StrToInt(choix)) then
      begin
        v.construction := -1;
        v.avancementConstruction := 0;
        messageGlobal := 'Construction annulée';
      end
      else if (choix >= '1') and (choix <= IntToStr(length(v.batiments))) then
        messageGlobal := 'Impossible construction deja en cours';
    end;

  until (choix = '0');
end;

procedure gestionRecherche(var g: Game; var c: Civilisation);
// gère les actions à partir du menu de recherche
var
  choix: char;
  // caractère saisie par l'utilisateur
  pos: integer;
  // la position du curseur de sélection de recherche
  page: integer;
  // la page de recherche courante
  rech: string;
  // si la recherche est possible
begin
  pos := 1;
  page := 1;
  repeat
    afficheRecherche(g, g.Civilisations[1], pos, page);
    readln(choix);
    case choix of
      // descendre
      '+':
        pos := pos + 1;
      // monter
      '-':
        pos := pos - 1;
      '/':
        page := page - 1;
      '*':
        page := page + 1;
      // lancer la recherche
      '1':
        begin
          rech := peutRechercherRecherche(c, pos + (page - 1) * 20);
          if rech = 'TRUE' then
          begin
            c.rechercheCourante := pos + (page - 1) * 20;
            c.avancementRecherche := 0;
          end
          else
          begin
            messageGlobal := rech;
          end;
        end;
    end;

    // bouclage du curseur
    if pos > min(20, length(g.Civilisations[1].recherches) - (page - 1) * 20) then
      pos := 1;
    if pos < 1 then
      pos := min(20, length(g.Civilisations[1].recherches) - (page - 1) * 20);

    if page > ceil(NOMBRE_RECHERCHE / 20) then
      page := 1;
    if page < 1 then
      page := ceil(NOMBRE_RECHERCHE / 20);

  until (choix = '0');
end;

procedure gestionDiplomatie(var g: Game; var c: Civilisation);
// gère les actions à partir du menu de diplomatie
var
  choix, action: char;
  montant: string;
  cible: string;
begin

  repeat
    afficheDiplomatie(g, c);
    readln(choix);

    // si choix valide
    if (choix >= '1') and (choix <= '4') then
    begin
      // si la civilisation n'est pas deja morte
      if not g.Civilisations[StrToInt(choix) + 1].mort then
      begin
        // si il reste des actions
        if c.actionDiplomatique < actionPossible(g, c) then
        begin
          afficheDetailDiplomatie(g, StrToInt(choix) + 1);
          afficheSaisie;
          readln(action);

          // si compliment
          if action = '1' then
          begin
            // si la relation est assez bonne
            if c.relation[StrToInt(choix) + 1] <> 0 then
            begin
              c.relation[StrToInt(choix) + 1] := min(100, c.relation[StrToInt(choix) + 1] + 1);
              g.Civilisations[StrToInt(choix) + 1].relation[1] := c.relation[StrToInt(choix) + 1];
              messageGlobal := 'Votre relation s''ameliore de 1 %';
              c.actionDiplomatique := c.actionDiplomatique + 1;
            end
            else
              messageGlobal := 'Action impossible avec une civilisation en guerre';
          end;

          // si envoie argent
          if action = '2' then
          begin
            // si la relation est assez bonne
            if c.relation[StrToInt(choix) + 1] <> 0 then
            begin
              montant := afficheQuestion('Combien envoyer ?');
              if valideInt(montant) then
              begin
                // si assez d'argent
                if StrToInt(montant) <= c.argent then
                begin
                  c.argent := c.argent - StrToInt(montant);
                  g.Civilisations[StrToInt(choix) + 1].argent := g.Civilisations[StrToInt(choix) + 1].argent + StrToInt(montant);
                  c.relation[StrToInt(choix) + 1] := min(100, c.relation[StrToInt(choix) + 1] + round(sqrt(StrToInt(montant))));
                  g.Civilisations[StrToInt(choix) + 1].relation[1] := c.relation[StrToInt(choix) + 1];
                  messageGlobal := 'Votre relation s''ameliore de ' + IntToStr(round(sqrt(StrToInt(montant)))) + ' %';
                  c.actionDiplomatique := c.actionDiplomatique + 1;
                end
                else
                  messageGlobal := 'Pas assez d''argent';
              end
              else
                messageGlobal := 'Montant invalide';
            end
            else
              messageGlobal := 'Action impossible avec une civilisation en guerre';
          end;
        end
        else
          messageGlobal := 'Plus d''action disponible';
      end
      else
        messageGlobal := 'Action impossible avec une civilisation detruite';
    end;

  until choix = '0';
end;

procedure gestionCivilisation(var g: Game; var c: Civilisation);
// gère les actions à partir de l'écran de civilisation
var
  choix, choixSave: char;
  // caractère saisi par l'utilisateur
  cancel: boolean;
begin
  repeat
    cancel := false;
    afficheCivilisation(g, g.Civilisations[1]);
    readln(choix);
    case choix of
      // gestion ville
      '1' .. '5':
        begin
          if choix <= IntToStr(c.nbVille) then
            gestionVille(g, c, g.Civilisations[1].ville[StrToInt(choix)])
          else
            messageGlobal := 'Pas de ville correspondante';
        end;
      // gestion militaire
      'm':
        gestionMilitaire(g, g.Civilisations[1]);
      // gestion recherche
      'r':
        gestionRecherche(g, g.Civilisations[1]);
      // gestion diplomatique
      'd':
        gestionDiplomatie(g, g.Civilisations[1]);
      // si quitter
      '0':
        begin
          gestionSave(g, cancel);

          if not cancel then
            g.fini := true;
        end;
    end;
  until ((choix = '0') or (choix = '9')) and (not cancel);
end;

procedure gestionAcceuil(var g: Game; var choix: char);
// gère les actions à partir du menu principal
begin
  afficheAccueil;
  readln(choix);

  if choix = '1' then // si le joueur commence une partie
  begin
    initGame(g);
    // initialisation du jeu (choix difficulté, civilisation ...)
  end;

  if choix = '2' then // si le joueur reprend une ancienne partie
  begin
    gestionLoad(g);
  end;

end;

procedure gestionChoixDifficulte(var g: Game);
// gère les actions à partir du menu de choix de difficulté
var
  choix: char; // caractère saisie par l'utilisateur

begin
  repeat
    afficheChoixDifficulte;
    readln(choix);
  until (choix >= '1') AND (choix <= '3');
  g.difficulte := StrToInt(choix);
end;

procedure gestionChoixAttaque(var g: Game);
// gère les actions à partir du menu de choix de civilisation
var
  choix: char; // caractère saisie par l'utilisateur

begin
  repeat
    afficheChoixAttaque;
    readln(choix);
    if choix = '1' then
      g.attaque := true
    else
      g.attaque := false;
  until (choix >= '1') AND (choix <= '2');
end;

procedure gestionChoixCivilisation(var g: Game);
// gère les actions à partir du menu de choix de civilisation
var
  choix: char; // caractère saisie par l'utilisateur
  i: integer;

begin
  repeat
    afficheChoixCivilisation;
    readln(choix);
    if (choix >= '1') and (choix <= '5') then
    begin
      for i := 1 to 5 do
      begin
        g.Civilisations[i].nom := LISTE_CIVILISATION[((StrToInt(choix) + i - 2) mod 5) + 1];
      end;
    end;
  until (choix >= '1') AND (choix <= '5');
end;

procedure reset(var g: Game);
// reset le jeu a la fin d'une partie
var
  i, j: integer;
begin

  for i := 1 to 5 do
  begin
    g.Civilisations[i].nom := '';
    for j := 1 to g.Civilisations[i].nbVille do
    begin
      g.Civilisations[i].ville[j].nom := '';
    end;
  end;
end;

end.
