class EndPoints {
  static const baseUrl = "https://attendesi.onrender.com";
  static const login = "/auth-service-de-scolarite/logIn";
  static const refreshtoken = "/auth-service-de-scolarite/refresh";
  static const logout = "/auth-service-de-scolarite/logOut";

  static const getProfile = "/scolarite/get-profile/scolarite";

  static const contactAdmin = "/scolarite/contacter-admin/send";

  static const dashboard = "/scolarite/absence/dashboard";
  static const graphiqueAbsences =
      "/scolarite/absence/dashboard/graphique-absences";
  static const graphiqueJustification =
      "/scolarite/justificatifs/dashboard/graphique-justification";

  static const getAllJustificatifs = "/scolarite/justificatifs/all";
  static const searchJustificatifs = "/scolarite/justificatifs/search";

  static String getJustificatifDetails(int id) {
    return "/scolarite/justificatifs/$id";
  }

  static String validerJustificatif(int id) =>
      "/scolarite/justificatifs/$id/valider";

  static String refusererJustificatif(int id) =>
      "/scolarite/justificatifs/$id/refuser";

  static const getPlanning = "/scolarite/emploi-du-temps";
  static const getExamens = "/scolarite/examens";

  static const absenceFiltres = "/scolarite/absence-examen/filtres";
  static const absenceEtudiants = "/scolarite/absence-examen/etudiants";
  static const absenceValider = "/scolarite/absence-examen/valider";

  static const getAbsences = "/scolarite/absence-examen/historique";
  static String getModifListe(int absenceId) =>
      "/scolarite/absence-examen/modifier/$absenceId";

  static String ModifAbsences(int absenceId) =>
      "/scolarite/absence-examen/modifier/$absenceId";

  static const getNotifications = "/notifications/my-inboxScolarite";
}
