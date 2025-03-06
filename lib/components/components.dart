import 'dart:math';
import 'dart:ui';

import 'package:cinema/core/extension/context_extension.dart';
import 'package:cinema/core/theme/color.dart';
import 'package:cinema/core/theme/text_style.dart';
import 'package:cinema/models/cinema.dart';
import 'package:cinema/models/cinema_salon.dart';
import 'package:cinema/models/city.dart';
import 'package:cinema/models/movie_model.dart';
import 'package:cinema/pages/category/movies_category_screen.dart';
import 'package:cinema/pages/main/cinema_main_screen.dart';
import 'package:cinema/pages/movie_detail/movie_detail_screen.dart';
import 'package:cinema/pages/cinema_hall/cinema_hall.dart';
import 'package:cinema/pages/reservation/reservation_screen.dart';
import 'package:cinema/viewmodels/all_movies_viewmodel.dart';
import 'package:cinema/viewmodels/cinema_hall_viewmodel.dart';
import 'package:cinema/viewmodels/city_selector_viewmodel.dart';
import 'package:cinema/viewmodels/movie_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';



// category
part 'category/category_list.dart';
part 'category/movie_grid.dart';
part 'category/empty_state.dart';

// utils
part 'utils/icon_helper.dart';

// Parts
// auth 
part "auth/auth_textfield.dart";

// button
part 'button/custom_button.dart';

// home 
part 'home/search_filed.dart';
part 'home/header_parts.dart';
part 'home/movie_carousel.dart';
part 'home/category_section.dart';

// profile 
part "profile/profile_menu_item.dart";

// movie detail 
part "movie_detail/movie_info.dart";

// reservation  
part "reservation/seat_status.dart";
part "reservation/wlcomeborder.dart";

//city selector 

part "city_selector/cinemas_list.dart"; 
part "city_selector/city_dropdown.dart"; 
part "city_selector/city_selector_header.dart";

//cinema hall 

part "cinema_hall/cinema_halls_loader.dart";
part "cinema_hall/cinema_halls_error.dart";
part "cinema_hall/cinema_halls_content.dart";
part "cinema_hall/cinema_header.dart";
part "cinema_hall/info_item.dart";
part "cinema_hall/feature_chip.dart";
part "cinema_hall/hall_card.dart";
part "cinema_hall/hall_feature.dart";
part "cinema_hall/cinema_halls_screen_provider.dart";
part "cinema_hall/enhanced_date_picker.dart";

