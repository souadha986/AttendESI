class EndPoints {
  static const baseUrl = "https://attendesi.onrender.com";
  static const login = "/auth-admin/logIn";
  static const refreshtoken = "/auth-admin/refresh";
  static const getTableauBord = "/admin/dashboard/stats";
  static const getNiveaux = "/admin/dashboard/dashboard/filters/niveaux";
  static const getSpecialites =
      "/admin/dashboard/dashboard/filters/specialites";
  static const getChart = "/admin/dashboard/dashboard/absences-chart";
  static const getProfile = "/admin/profil/profile";
  static const listeetudiant = "/admin/etudiants/liste";
  static const String getAdminNotifications = '/admin/notification';
  static const String markNotificationRead = '/admin/notification/mark-read';
  static const String sendPersonalNotification =
      '/admin/notification/envoyer-notification-personnelle';
  static const changeMdp = "/auth-admin/update-password";
  static const logout = "/auth-admin/logOut";
  static const archiveetudiant = "/admin/etudiants/archive";
  static const deleteetudiant = "/admin/etudiants/delete";
  static const updateEtudiant = "/admin/etudiants";
  static const updateprof = "/admin/enseignants";
  static const addetudiant = "/admin/etudiants/creerCompte";
  static const addprof = "/admin/enseignants/creerCompte";
  static const addscolarite = "/admin/scolarite/creerCompte";
  static const archiveetudiantliste = "/admin/etudiants/archives";
  static const desarchive = "/admin/etudiants/restore";
  static String emploiNormal(String niveau) =>
      '/admin/Emploi/admin/affichage/$niveau';
  static String emploiExamens(String niveau) => '/admin/Emploi/examens/$niveau';
  static String emploiRemplacement(String niveau) =>
      '/admin/Emploi/examensRemplacement/$niveau';
  static const search = "/admin/search/etudiants";
  static const searcharcheive = "/admin/search/etudiantsArchives";

  static const searchprof = "/admin/search/enseignants";
  static const searchprofarcheive = "/admin/search/enseignantsArchives";
  static const getprofs = "/admin/enseignants/liste";
  static const getscolarite = "/admin/scolarite/liste";
  static const supprimeprof = "/admin/enseignants/delete";
  static String scolaritedelete(String auth_id) => '/admin/scolarite/$auth_id';
  static String modifierscolarite(String auth_id) =>
      '/admin/scolarite/$auth_id';
  static const archeiveeprof = "/admin/enseignants/archive";
  static const desarcheiveeprof = "/admin/enseignants/restore";
  static const archeiveprofsliste = "/admin/enseignants/archives";

  static const String exclusionAlerteListe = '/admin/Exclusion/alerte-liste';
  static String exclusionDossier(String authId, String matiereId) =>
      '/admin/Exclusion/dossier/$authId/$matiereId';

  static const String prononcerExclusion =
      '/admin/Exclusion/prononcer-exclusion';
  static const String accorderDerogation =
      '/admin/Exclusion/accorder-derogation';

  static const String exclusionParametres = '/admin/Exclusion/parametres';
  static const String exclusionConfigurerSeuil =
      '/admin/Exclusion/configurer-seuil';

  static String exclusionRecherche(String query) =>
      '/admin/Exclusion/exclusions/recherche?query=${Uri.encodeComponent(query)}';

  static const String importSalles = '/admin/import/salles';

  static const String importMatieres = '/admin/import/matieres';
  static const String importEmploi = '/admin/import/emplois';

  static const String importExamensEmd = '/admin/import/examens/emd';
  static const String importExamensRemplacement =
      '/admin/import/examens/remplacement';
  static const String importEtudiants = '/admin/import/etudiants';
  static const String importProfesseurs = '/admin/import/professeurs';
}
