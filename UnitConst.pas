unit UnitConst;

interface

const

  NOMBRE_RECHERCHE = 18; // le nombre de recherche possible
  NOMBRE_BATIMENT  = 8; // le nombre de type de b�timent
  NOMBRE_UNITE     = 4; // le nombre de type d'unit�

  LISTE_CIVILISATION: array [1 .. 5] of String = ('France', 'Allemagne', 'Espagne', 'Italie', 'Russie'); // le nom des civilisations

  LISTE_BATIMENT: array [1 .. NOMBRE_BATIMENT] of String = ('Ferme', 'Mine', 'Carriere', 'Caserne', 'Etable', 'Marche', 'Jardin', 'Bibliotheque');
  // le nom des different type de b�timent

  COUT_BATIMENT: array [1 .. NOMBRE_BATIMENT] of integer = (10, 5, 15, 25, 10, 15, 25, 5); // les co�ts des b�timents par niveau
  VIE_BATIMENT: array [1 .. NOMBRE_BATIMENT] of integer  = (20, 20, 20, 20, 20, 20, 20, 20); // la vie des b�timents

  BONHEUR_PAR_POPULATION = 3; // bonheur perdu par population
  BONHEUR_PAR_BATIMENT   = 5; // bonheur perdu par b�timent
  BONHEUR_PAR_JARDIN     = 30; // bonheur gagn� par jardin

  NOURRITURE_PAR_FERME  = 3; // nourriture produite par ferme
  NOURRITURE_PAR_ETABLE = 5; // nourriture produite par �table

  TRAVAIL_PAR_MINE     = 2; // travail produit par mine
  TRAVAIL_PAR_CARRIERE = 4; // travail produit par carri�re

  ARGENT_PAR_MARCHE = 2; // argent produite par march�

  RECRUTEMENT_PAR_CASERNE = 3; // point de recrutement par caserne

  RECHERCHE_PAR_BIBLIOTHEQUE = 1; // point de recrutement par caserne

  LISTE_UNITE: array [1 .. NOMBRE_UNITE] of String = ('Soldat', 'Cavalier', 'Canon', 'Mercenaire'); // le nom des diff�rents type d'unit�s

  PUISSANCE_UNITE: array [1 .. NOMBRE_UNITE] of integer = (1, 3, 5, 4); // les d�gats des unit�s
  VIE_UNITE: array [1 .. NOMBRE_UNITE] of integer       = (1, 3, 2, 3); // la vie des unit�s
  COUT_UNITE: array [1 .. NOMBRE_UNITE] of integer      = (1, 2, 3, 0); // le cout de recrutement des unit�s en point
  COUT_UNITE_OR: array [1 .. NOMBRE_UNITE] of integer   = (0, 0, 0, 3); // le cout de recrutement des unit�s en or

  MINIMUM_BARBARE: array [1 .. NOMBRE_UNITE] of integer = (5, 3, 1, 0); // le nombre minimal d'unit�s par cat�gorie dans les camps
  RANDOM_BARBARE: array [1 .. NOMBRE_UNITE] of integer  = (20, 10, 5, 0); // la valeur al�atoire d'unit�s par cat�gorie dans les camps
  OR_BARBARE                                            = 50; // la valeur al�atoire d'or gagn� a la fin des combats barbares

  TOUR_DEBUT_ATTAQUE      = 75; // tour � partir duquel les attaques barbares commencent
  CHANCE_ATTAQUE_PAR_TOUR = 50; // probabilit� d'attaque par tour

implementation

end.
