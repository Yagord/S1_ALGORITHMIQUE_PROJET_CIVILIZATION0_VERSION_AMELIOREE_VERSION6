unit UnitRecord;

interface

uses unitConst;

type

  // un pointeur vers une civilisation
  PCivilisation = ^Civilisation;

  // une recherche
  Recherche = record
    titre: string[30];
    description: string[100];
    cout: Integer;
    fini: Boolean;
    prerequis: array [1 .. 3] of Integer;
    effet: array [1 .. 3] of String[50];
    ratio: array [1 .. 28] of Real;
    bonus: array [1 .. 28] of Real;
  end;

  // une troupe composée d'unités et avec un nom
  Troupe = record
    nom: string[50];
    unites: array [1 .. NOMBRE_UNITE] of Integer;
    origine: PCivilisation;
  end;

  // la ville qui contient son nom, population, nourriture ainsi que ses données de construction
  Ville = record
    nom: string[50];
    nourriture: Integer;
    population: Integer;
    batiments: array [1 .. NOMBRE_BATIMENT] of Integer;
    construction: Integer;
    avancementConstruction: Real;
  end;

  // la civilisation qui contient son nom, ses données militaires, de recherche ainsi que ses villes
  Civilisation = record
    nom: string[50];
    Ville: array [1 .. 5] of Ville;
    nbVille: Integer;
    Troupe: Troupe;
    recrutement: Integer;
    argent: Integer;
    recherches: array [1 .. NOMBRE_RECHERCHE] of Recherche;
    rechercheCourante: Integer;
    avancementRecherche: Integer;
    relation: array [1 .. 5] of Integer;
    actionDiplomatique: Integer;
    bonus: array [1 .. 28] of Real;
    ratio: array [1 .. 28] of Real;
    joueur: Boolean;
    mort: Boolean;
  end;

  // le jeu qui contient l'ensemble des données
  Game = record
    fini: Boolean;
    tour: Integer;
    Civilisations: array [1 .. 5] of Civilisation;
    difficulte: Integer;
    attaque: Boolean;
    victoire: Boolean;
  end;

implementation

end.
