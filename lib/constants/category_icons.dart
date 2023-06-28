import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const List<IconData> mainIcons = [
  FontAwesomeIcons.creditCard,
    FontAwesomeIcons.motorcycle,
    FontAwesomeIcons.basketShopping,
    FontAwesomeIcons.bell,
    FontAwesomeIcons.sun,
    FontAwesomeIcons.umbrella,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.house,
    FontAwesomeIcons.book,
    FontAwesomeIcons.piggyBank,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.language,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.paperclip,
    FontAwesomeIcons.moon,


];
const Map<String, List<IconData>> categoryIcons = {
  'Finances': [
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.moneyBill,
    FontAwesomeIcons.piggyBank,
    FontAwesomeIcons.briefcase,
    FontAwesomeIcons.fileInvoiceDollar,
    FontAwesomeIcons.moneyCheck,
    FontAwesomeIcons.moneyBillWaveAlt,
    FontAwesomeIcons.receipt,
    FontAwesomeIcons.shoppingCart,
    FontAwesomeIcons.coins,
    FontAwesomeIcons.bank,
  ],
  'Transportation': [
    FontAwesomeIcons.car,
    FontAwesomeIcons.motorcycle,
    FontAwesomeIcons.bus,
    FontAwesomeIcons.subway,
    FontAwesomeIcons.train,
    FontAwesomeIcons.plane,
    FontAwesomeIcons.ship,
    FontAwesomeIcons.bicycle,
    FontAwesomeIcons.walking,
    FontAwesomeIcons.running,
    FontAwesomeIcons.mapMarkerAlt,
  ],
  'Shopping': [
    FontAwesomeIcons.shoppingBag,
    FontAwesomeIcons.basketShopping,
    FontAwesomeIcons.shoppingCart,
    FontAwesomeIcons.gift,
    FontAwesomeIcons.tags,
    FontAwesomeIcons.boxOpen,
    FontAwesomeIcons.cashRegister,
    FontAwesomeIcons.receipt,
    FontAwesomeIcons.barcode,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.coins,
    FontAwesomeIcons.piggyBank,
  ],
  'Food & Drink': [
    FontAwesomeIcons.utensils,
    FontAwesomeIcons.martiniGlassEmpty,
    FontAwesomeIcons.coffee,
    FontAwesomeIcons.beer,
    FontAwesomeIcons.wineGlass,
    FontAwesomeIcons.beer,
    FontAwesomeIcons.martiniGlassCitrus,
    FontAwesomeIcons.pizzaSlice,
    FontAwesomeIcons.hamburger,
    FontAwesomeIcons.hotdog,
    FontAwesomeIcons.iceCream,
    FontAwesomeIcons.birthdayCake,
    FontAwesomeIcons.breadSlice,
    FontAwesomeIcons.appleAlt,
    FontAwesomeIcons.lemon,
    FontAwesomeIcons.fish,
  ],
  'Home': [
    FontAwesomeIcons.home,
    FontAwesomeIcons.building,
    FontAwesomeIcons.hotel,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.doorOpen,
    FontAwesomeIcons.windowMaximize,
    FontAwesomeIcons.couch,
    FontAwesomeIcons.chair,
    FontAwesomeIcons.table,
    FontAwesomeIcons.lightbulb,
    FontAwesomeIcons.paintRoller,
    FontAwesomeIcons.toilet,
    FontAwesomeIcons.sink,
    FontAwesomeIcons.shower,
    FontAwesomeIcons.bath,
    FontAwesomeIcons.tools,
  ],
  'Health': [
    FontAwesomeIcons.heartbeat,
    FontAwesomeIcons.medkit,
    FontAwesomeIcons.hospital,
    FontAwesomeIcons.userMd,
    FontAwesomeIcons.pills,
    FontAwesomeIcons.prescriptionBottle,
    FontAwesomeIcons.syringe,
    FontAwesomeIcons.thermometerHalf,
    FontAwesomeIcons.stethoscope,
    FontAwesomeIcons.weight,
    FontAwesomeIcons.running,
    FontAwesomeIcons.biking,
    FontAwesomeIcons.hiking,
    FontAwesomeIcons.firstAid,
  ],
  'Beauty': [
    FontAwesomeIcons.spa,
    FontAwesomeIcons.scissors,
    FontAwesomeIcons.paintBrush,
    FontAwesomeIcons.shower,
    FontAwesomeIcons.bath,
    FontAwesomeIcons.sprayCan,
    FontAwesomeIcons.female,
    FontAwesomeIcons.male,
    FontAwesomeIcons.eye,
    FontAwesomeIcons.tint,
  ],
  'Entertainment': [
    FontAwesomeIcons.music,
    FontAwesomeIcons.film,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.book,
    FontAwesomeIcons.tv,
    FontAwesomeIcons.theaterMasks,
    FontAwesomeIcons.ticketAlt,
    FontAwesomeIcons.cameraRetro,
    FontAwesomeIcons.headphones,
    FontAwesomeIcons.dice,
    FontAwesomeIcons.microphone,
    FontAwesomeIcons.magic,
    FontAwesomeIcons.smileBeam,
    FontAwesomeIcons.guitar,
    FontAwesomeIcons.playCircle,
  ],
  'Accounts': [
    FontAwesomeIcons.buildingColumns,
    FontAwesomeIcons.wallet,
    FontAwesomeIcons.creditCard,
    FontAwesomeIcons.moneyBill,
    FontAwesomeIcons.piggyBank,
    FontAwesomeIcons.briefcase,
    FontAwesomeIcons.fileInvoiceDollar,
    FontAwesomeIcons.moneyCheck,
    FontAwesomeIcons.moneyBill1Wave,
    FontAwesomeIcons.receipt,
    FontAwesomeIcons.shoppingCart,
    FontAwesomeIcons.coins,
  ],
  'Workout': [
    FontAwesomeIcons.dumbbell,
    FontAwesomeIcons.running,
    FontAwesomeIcons.biking,
    FontAwesomeIcons.hiking,
    FontAwesomeIcons.weight,
    FontAwesomeIcons.walking,
    FontAwesomeIcons.firstAid,
    FontAwesomeIcons.appleAlt,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.basketballBall,
    FontAwesomeIcons.bicycle,
    FontAwesomeIcons.swimmer,
    FontAwesomeIcons.skiing,
    FontAwesomeIcons.footballBall,
    FontAwesomeIcons.volleyballBall,
    FontAwesomeIcons.golfBall,
  ],
  'Relaxation': [
    FontAwesomeIcons.spa,
    FontAwesomeIcons.moon,
    FontAwesomeIcons.sun,
    FontAwesomeIcons.bed,
    FontAwesomeIcons.snowflake,
    FontAwesomeIcons.hotTub,
    FontAwesomeIcons.tree,
    FontAwesomeIcons.campground,
    FontAwesomeIcons.fish,
    FontAwesomeIcons.glassMartiniAlt,
    FontAwesomeIcons.bookReader,
    FontAwesomeIcons.music,
    FontAwesomeIcons.fire,
    FontAwesomeIcons.wineGlassAlt,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.film,
  ],
  'Education': [
    FontAwesomeIcons.graduationCap,
    FontAwesomeIcons.school,
    FontAwesomeIcons.book,
    FontAwesomeIcons.pencilAlt,
    FontAwesomeIcons.microscope,
    FontAwesomeIcons.laptop,
    FontAwesomeIcons.brain,
    FontAwesomeIcons.language,
    FontAwesomeIcons.globe,
    FontAwesomeIcons.chalkboardTeacher,
    FontAwesomeIcons.paintBrush,
    FontAwesomeIcons.flask,
    FontAwesomeIcons.code,
    FontAwesomeIcons.readme,
    FontAwesomeIcons.paperPlane,
    FontAwesomeIcons.screwdriver,
    FontAwesomeIcons.pen,
    FontAwesomeIcons.palette,
  ],
  'Family/Children': [
    FontAwesomeIcons.child,
    FontAwesomeIcons.users,
    FontAwesomeIcons.baby,
    FontAwesomeIcons.handsHelping,
    FontAwesomeIcons.heartbeat,
    FontAwesomeIcons.house,
    FontAwesomeIcons.birthdayCake,
    FontAwesomeIcons.tshirt,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.puzzlePiece,
  ],
  'Other': [
    FontAwesomeIcons.questionCircle,
    FontAwesomeIcons.exclamationCircle,
    FontAwesomeIcons.search,
    FontAwesomeIcons.mapMarkerAlt,
    FontAwesomeIcons.paperclip,
    FontAwesomeIcons.star,
    FontAwesomeIcons.heart,
    FontAwesomeIcons.cloud,
    FontAwesomeIcons.moon,
    FontAwesomeIcons.sun,
    FontAwesomeIcons.globe,
    FontAwesomeIcons.umbrella,
    FontAwesomeIcons.rocket,
    FontAwesomeIcons.cog,
    FontAwesomeIcons.certificate,
    FontAwesomeIcons.bell,
  ],
};
