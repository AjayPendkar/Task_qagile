import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'app_name': 'Movie App',
          'search': 'Search',
          'recent_search': 'Recent Search',
          'remove': 'Remove',
          'for_you': 'For you',
          'see_all': 'See all',
        },
        'es_ES': {
          'app_name': 'Aplicación de Películas',
          'search': 'Buscar',
          'recent_search': 'Búsqueda Reciente',
          'remove': 'Eliminar',
          'for_you': 'Para ti',
          'see_all': 'Ver todo',
        },
      };
} 