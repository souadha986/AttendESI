class EndPoints {
  static const baseUrl = "https://attendesi.onrender.com";
  static const login = "/authStudent/logIn";
  static const sendOtp = "/authStudent/send-otp";
  static const verifyOtp = "/authStudent/verify-otp";
  static const changepassword = "/authStudent/reset-password";
  static const refreshtoken = "/authStudent/refresh";
  static const updatePassword = "/authStudent/update-password";
  static const getjustificatif = "/justificatifs/my-justificatifs";
  static const getmatiers = "/justificatifs/GetMatieres";
  static const uploadjustificatifs = "/justificatifs/upload";
  static const contactAdmin = "/contacter-admin/send";
  static const getProfile = "/get-profile/profile";
  static const logout = "/authStudent/logOut";
  static const notification = "/notifications/my-inbox";
  static String deleteandupdatejustificatif(String id) => '/justificatifs/$id';
  static String mySchedule = "/emploi/my-schedule";
  static String myExams = "/emploi/my-exams";
  static String myExamsRemplacement = "/emploi/my-exams-remplacement";
  static String absence = "/absence/accueil";

  static String scane = "/absence/qr/scanner";
}
