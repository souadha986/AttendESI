class EndPoints {
  static const baseUrl = "https://attendesi.onrender.com";
  static const login = "/auth-prof/logIn";
  static const sendOtp = "/auth-prof/send-otp";
  static const verifyOtp = "/auth-prof/verify-reset-otp";
  static const changepassword = "/auth-prof/reset-password";
  static const refreshtoken = "/auth-prof/refresh";
  static const updatePassword = "/auth-prof/update-password";
  static const contactAdmin = "/contacter-admin/sendProfToAdmin";
  static const getProfile = "/get-profile/profileProf";
  static const logout = "/auth-prof/logOut";
  static const niveau = "/absence/niveaux";
  static const specialite = "/absence/specialites";
  static const module = "/absence/matieres";
  static const groupe = "/absence/groupes";
  static const test = "/test";
  static const edit = "/absence/modifier";
  static const editetudiant = "/absence/edit-list";
  static const fetchlistecompteur = "/absence/liste";
  static const exporterexel = "/absence/export-excel";
  static const marquerabsence = "/absence/marquerAbsences";
  static const marqueretudiant = "/absence/etudiants";
  static const notification = "/notifications/my-inboxProf";
  static const stats = "/get-profile/dashboard/prof-stats";
  static const listetest = "/test/eligible-absents";
  static const remplacement = "/test/remplacement";
  static const moduletest = "/test/matieres-communes";
  static String mySchedule = "/emploi/enseignant/mon-emploi";
  static String myExams = "/emploi/enseignant/mes-examens";
  static String myExamsRemplacement =
      "/emploi/enseignant/mes-examensRemplacement";
  static const String generateQr = "/absence/qr/generer";
}
