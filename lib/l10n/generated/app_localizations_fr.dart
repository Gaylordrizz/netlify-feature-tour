// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Storazaar';

  @override
  String get settings => 'Paramètres';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get language => 'Langue';

  @override
  String get helpSupport => 'Aide et support';

  @override
  String get about => 'À propos';

  @override
  String get termsConditions => 'Termes et conditions';

  @override
  String get logout => 'Déconnexion';

  @override
  String get selectLanguage => 'Choisir la langue';

  @override
  String languageChanged(String language) {
    return 'Langue changée en $language';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get logoutConfirm => 'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get loggedOut => 'Déconnexion réussie';

  @override
    String get openMenu => 'Ouvrir le menu';

  @override
    String get account => 'Compte';

  @override
    String get home => 'Accueil';

  @override
    String get history => 'Historique';

  @override
    String get savedProducts => 'Produits enregistrés';

  @override
    String get savedStores => 'Magasins enregistrés';

  @override
    String get productView => 'Vue du produit';

  @override
    String get storeProfile => 'Profil du magasin';

  @override
    String get storeOwnerForum => 'Forum des propriétaires de magasins';

  @override
    String get postYourStore => 'Publier votre magasin';

  @override
    String get storeDashboard => 'Tableau de bord du magasin';

    // Product View specific translations
    String get productTitle => 'Titre du produit';

    String get productPrice => 'Prix';

    String get productDescription => 'Description du produit';

    String get storeName => 'Nom du magasin';

    String get storeDomain => 'Domaine du magasin';

    String get noDescriptionAvailable => 'Aucune description disponible.';

    String get noPrice => 'Pas de prix';

    String get category => 'Catégorie';

    String get condition => 'État';

    String get brand => 'Marque';

    String get saveProduct => 'Enregistrer le produit';

    String get unsaveProduct => 'Retirer des enregistrés';

    String get reportProduct => 'Signaler le produit';

    String get productSaved => 'Produit enregistré';

    String get productUnsaved => 'Produit retiré des enregistrés';

    String get productReported => 'Produit signalé';

    String get rate => 'Évaluer';

    String get rateThisProduct => 'Évaluer ce produit';

    String get tapAStarToRate => 'Touchez une étoile pour évaluer :';

    String get noRatingSelected => 'Aucune note sélectionnée';

    String get submit => 'Soumettre';

    String get ratingBreakdown => 'Répartition des notes';

    String get info => 'Info';

    String get productInfo => 'Informations sur le produit';

    String get visitStore => 'Visiter le magasin';

    String get stars => 'étoiles';

    String get star => 'étoile';
}
