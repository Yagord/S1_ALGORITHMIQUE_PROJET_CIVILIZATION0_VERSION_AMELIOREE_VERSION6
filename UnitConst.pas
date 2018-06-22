unit UnitConst;

interface

const

  NOMBRE_RECHERCHE = 18; // le nombre de recherche possible
  NOMBRE_BATIMENT  = 8; // le nombre de type de bâtiment
  NOMBRE_UNITE     = 4; // le nombre de type d'unité

  LISTE_CIVILISATION: array [1 .. 5] of String = ('France', 'Allemagne', 'Espagne', 'Italie', 'Russie'); // le nom des civilisations

  LISTE_BATIMENT: array [1 .. NOMBRE_BATIMENT] of String = ('Ferme', 'Mine', 'Carriere', 'Caserne', 'Etable', 'Marche', 'Jardin', 'Bibliotheque');
  // le nom des different type de bâtiment

  COUT_BATIMENT: array [1 .. NOMBRE_BATIMENT] of integer = (10, 5, 15, 25, 10, 15, 25, 5); // les coûts des bâtiments par niveau
  VIE_BATIMENT: array [1 .. NOMBRE_BATIMENT] of integer  = (20, 20, 20, 20, 20, 20, 20, 20); // la vie des bâtiments

  BONHEUR_PAR_POPULATION = 3; // bonheur perdu par population
  BONHEUR_PAR_BATIMENT   = 5; // bonheur perdu par bâtiment
  BONHEUR_PAR_JARDIN     = 30; // bonheur gagné par jardin

  NOURRITURE_PAR_FERME  = 3; // nourriture produite par ferme
  NOURRITURE_PAR_ETABLE = 5; // nourriture produite par étable

  TRAVAIL_PAR_MINE     = 2; // travail produit par mine
  TRAVAIL_PAR_CARRIERE = 4; // travail produit par carrière

  ARGENT_PAR_MARCHE = 2; // argent produite par marché

  RECRUTEMENT_PAR_CASERNE = 3; // point de recrutement par caserne

  RECHERCHE_PAR_BIBLIOTHEQUE = 1; // point de recrutement par caserne

  LISTE_UNITE: array [1 .. NOMBRE_UNITE] of String = ('Soldat', 'Cavalier', 'Canon', 'Mercenaire'); // le nom des différents type d'unités

  PUISSANCE_UNITE: array [1 .. NOMBRE_UNITE] of integer = (1, 3, 5, 4); // les dégats des unités
  VIE_UNITE: array [1 .. NOMBRE_UNITE] of integer       = (1, 3, 2, 3); // la vie des unités
  COUT_UNITE: array [1 .. NOMBRE_UNITE] of integer      = (1, 2, 3, 0); // le cout de recrutement des unités en point
  COUT_UNITE_OR: array [1 .. NOMBRE_UNITE] of integer   = (0, 0, 0, 3); // le cout de recrutement des unités en or

  MINIMUM_BARBARE: array [1 .. NOMBRE_UNITE] of integer = (5, 3, 1, 0); // le nombre minimal d'unités par catégorie dans les camps
  RANDOM_BARBARE: array [1 .. NOMBRE_UNITE] of integer  = (20, 10, 5, 0); // la valeur aléatoire d'unités par catégorie dans les camps
  OR_BARBARE                                            = 50; // la valeur aléatoire d'or gagné a la fin des combats barbares

  TOUR_DEBUT_ATTAQUE      = 75; // tour à partir duquel les attaques barbares commencent
  CHANCE_ATTAQUE_PAR_TOUR = 50; // probabilité d'attaque par tour

implementation

end.
