unit UnitUpdate;

interface

uses UnitRecord;

procedure updateGame(var g: Game);
// met à jour le jeu entre chaque tour

implementation

uses UnitMilitaire, UnitConst, UnitVille, UnitGestion, UnitRecherche, UnitAffichage, System.SysUtils, math, GestionEcran;

procedure event(var g: Game);
// gère le lancement d'événement aléatoire comme les attaques barbares
var
  i: integer;
  cadeau: integer;
begin
  Randomize;

  // chance d'attaque barbare
  if (g.tour > TOUR_DEBUT_ATTAQUE) and (g.attaque) then
  begin
    if (random(CHANCE_ATTAQUE_PAR_TOUR) = 0) then
    begin
      attaqueDeBarbare(g, g.Civilisations[1].Ville[g.Civilisations[1].nbVille]);
    end;
  end;

  // chance d'événement de civilisation
  for i := 2 to 5 do
  begin

    // chance attaque
    if (g.Civilisations[1].relation[i] = 0) and (not g.Civilisations[i].mort) and (totalSoldat(g.Civilisations[i].Troupe) > 0) then
    begin
      if (random(round(CHANCE_ATTAQUE_PAR_TOUR/2)) = 0) then
      begin
        attaqueDeCivilisation(g, g.Civilisations[i], g.Civilisations[1].Ville[g.Civilisations[1].nbVille]);
      end;
    end;

    // envoie cadeaux
    if (g.Civilisations[1].relation[i] = 100) and (not g.Civilisations[i].mort) then
    begin
      if (g.tour mod 10 = 0) and (round(g.Civilisations[i].argent * 0.2) <> 0) then
      begin
        cadeau := round(g.Civilisations[i].argent * 0.2);
        affichePopup(g, 'Cadeau', LISTE_CIVILISATION[i] + ' vous envoie ' + IntToStr(cadeau) + ' pièces d''or');
        g.Civilisations[1].argent := g.Civilisations[1].argent + cadeau;
        g.Civilisations[i].argent := g.Civilisations[i].argent - cadeau;
      end;
    end;

    if g.Civilisations[1].relation[i] < 100 then
    begin
      // détérioration des relations
      if (random(4) = 0) and (random(max(400, round(10000 / max(1, g.Civilisations[1].relation[i])))) > 100) then
      begin
        g.Civilisations[1].relation[i] := max(0, g.Civilisations[1].relation[i] - 1);
        g.Civilisations[i].relation[1] := g.Civilisations[1].relation[i];
      end;

    end;
  end;

end;

procedure updateBatiments(var g: Game; var c: Civilisation; var v: Ville);
// met a jour les batiments
begin

  // si une construction est en cours
  if v.construction <> -1 then
  begin
    v.avancementConstruction := v.avancementConstruction + travailParTour(c, v);
  end;

  // si une construction est terminée
  if v.avancementConstruction >= travailRequis(g, c, v) then
  begin
    v.batiments[v.construction] := v.batiments[v.construction] + 1;
    v.construction := -1;
    v.avancementConstruction := 0;
  end;

end;

procedure updateVille(var g: Game; var c: Civilisation; var v: Ville);
// met à jour la ville
begin

  // update de l'avancement des construction
  updateBatiments(g, c, v);

  v.nourriture := v.nourriture + nourritureParTour(c, v);

  // update de la croissance
  if nourriturePourCroissance(c, v) <> -1 then
  begin
    repeat
      if nourriturePourCroissance(c, v) <= v.nourriture then
      begin
        v.nourriture := round(v.nourriture - nourriturePourCroissance(c, v));
        v.population := v.population + 1;
      end;
    until nourriturePourCroissance(c, v) > v.nourriture;
  end;

  // si en perte de nourriture
  if v.nourriture < 0 then
  begin
    v.population := v.population + v.nourriture;
    if v.population < 0 then
    begin
      v.population := 0;
    end;
    v.nourriture := 0;
  end;

end;

procedure updateRatio(var c: Civilisation);
// met à jour les ratios et bonus pouvant être apportée par les recherches
var
  i, j: integer;
begin

  // mise a jour des ratios
  for i := 1 to length(c.ratio) do
  begin
    c.ratio[i] := 1;
    c.bonus[i] := 0;
    for j := 1 to NOMBRE_RECHERCHE do
    begin
      if c.recherches[j].fini then
      begin
        c.ratio[i] := c.ratio[i] * c.recherches[j].ratio[i];
        c.bonus[i] := c.bonus[i] + c.recherches[j].bonus[i];
      end;

    end;
  end;
end;

procedure updateRecherche(var g: Game; var c: Civilisation);
// met à jour les recherches si recherche en cours
begin

  if c.rechercheCourante <> -1 then
  begin
    c.avancementRecherche := c.avancementRecherche + rechercheParTour(c);

    if c.avancementRecherche >= c.recherches[c.rechercheCourante].cout then
    begin
      if c.joueur then
        affichePopup(g, '', 'Recherche terminée : ' + c.recherches[c.rechercheCourante].titre);
      c.recherches[c.rechercheCourante].fini := true;
      c.avancementRecherche := 0;
      c.rechercheCourante := -1;
    end;
  end;

  updateRatio(c);

end;

procedure updateIA(var g: Game; var c: Civilisation);
// fait jouer la civilisation ennemie
var
  argent: integer;
  unite, recherche: integer;
begin

  Randomize;

  // construction
  if (c.Ville[1].construction = -1) and (sommeBatiment(c.Ville[1]) < round((c.Ville[1].population + c.bonus[17]) * c.ratio[17])) then
  begin
    if nourritureParTour(c, c.Ville[1]) <= 2 then
      c.Ville[1].construction := 1
    else
      c.Ville[1].construction := random(8) + 1;
  end;

  // recrutement
  argent := c.argent;
  while (peutRecruter(c)) and (c.argent >= round(argent * 90 / 100)) do
  begin
    unite := random(NOMBRE_UNITE) + 1;

    if peutRecruterUnite(c, unite) = 'TRUE' then
    begin
      c.Troupe.unites[unite] := c.Troupe.unites[unite] + 1;
      c.recrutement := c.recrutement - COUT_UNITE[unite];
      c.argent := c.argent - COUT_UNITE_OR[unite];
    end;
  end;

  // recherche
  while peutRechercher(c) do
  begin
    recherche := random(NOMBRE_RECHERCHE) + 1;

    if peutRechercherRecherche(c, recherche) = 'TRUE' then
    begin
      c.rechercheCourante := recherche;
      c.avancementRecherche := 0;
    end;
  end;

end;

procedure updateCivilisation(var g: Game; var c: Civilisation);
// met à jour la civilisation
var
  i: integer;
begin

  updateRecherche(g, c);

  c.recrutement := recrutementParTour(c);
  c.actionDiplomatique := 0;
  c.argent := c.argent + argentParTour(c);

  if c.joueur = false then
    updateIA(g, c);

  // update de toute les villes
  for i := 1 to c.nbVille do
  begin
    updateVille(g, c, c.Ville[i]);

    if (c.Ville[i].population = 0) and (c.joueur) then
    begin
      affichePopup(g, '', 'Votre ville est detruite');
      c.nbVille := c.nbVille - 1;
    end;
  end;

end;

procedure updateGame(var g: Game);
// met à jour le jeu entre chaque tour
var
  i: integer;
begin
  event(g);

  // update des civilisations
  for i := 1 to 5 do
  begin

    updateCivilisation(g, g.Civilisations[i]);

    // si plus aucune ville au joueur
    if (g.Civilisations[i].nbVille = 0) and (g.Civilisations[i].joueur) and (not g.Civilisations[i].mort) then
    begin
      g.Civilisations[i].mort := true;
      affichePopup(g, '', 'Votre civilisation est anéantie');
    end;
    // si plus aucune ville d'une civilisation ennemie
    if (g.Civilisations[i].nbVille = 0) and (not g.Civilisations[i].joueur) and (not g.Civilisations[i].mort) then
    begin
      g.Civilisations[i].mort := true;
      affichePopup(g, '', g.Civilisations[i].nom + ' est anéantie');
    end;

  end;

  // si victoire
  if (g.Civilisations[2].nbVille + g.Civilisations[3].nbVille + g.Civilisations[4].nbVille + g.Civilisations[5].nbVille = 0) and (not g.victoire) then
  begin
    affichePopup(g, '', 'Bravo, vous avez tuer tout vos adversaire');
    g.victoire := true;
  end;

  // si defaite
  if g.Civilisations[1].mort then
  begin
    affichePopup(g, '', 'Game over');
    g.fini := true;
  end;

  g.tour := g.tour + 1;

end;

end.
