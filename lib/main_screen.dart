import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:weather/weather.dart';
import 'package:weather_app/request_status.dart';
import 'package:weather_app/utilities/extensions.dart';
import 'package:weather_app/utilities/general_utilities.dart';
import 'package:weather_app/weather_api.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController searchController = TextEditingController();
  Weather? currentWeather;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: const Icon(
            CupertinoIcons.location_solid,
            color: Colors.white,
            size: 32,
            shadows: [Shadow(offset: Offset(0, 2), blurRadius: 5)],
          ),
          title: TextField(
              controller: searchController,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter a Location',
                  hintStyle: GoogleFonts.inter(
                      color: GeneralUtils.primaryColor,
                      fontWeight: FontWeight.bold),
                  suffixIcon: IconButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {
                        loading = true;
                      });
                      await Future.delayed(const Duration(seconds: 2));
                      WeatherApi api = WeatherApi();
                      final result =
                          await api.getWeatherData(searchController.value.text);
                      if (result.status == RequestStatus.SUCCESS) {
                        setState(() {
                          currentWeather = result.body;
                        });
                      } else {
                        setState(() {
                          currentWeather = null;
                        });
                        GeneralUtils.showSnackbar(context, result.message!);
                      }
                      setState(() {
                        loading = false;
                      });
                    },
                    icon: const Icon(Icons.search),
                    iconSize: 30,
                    color: GeneralUtils.primaryColor,
                  )),
              style: GoogleFonts.inter(
                  color: GeneralUtils.primaryColor,
                  fontWeight: FontWeight.bold)),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('Assets/background.jpg'),
                  fit: BoxFit.cover)),
          child: GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: loading
                ? LoadingAnimationWidget.hexagonDots(
                    color: GeneralUtils.primaryColor, size: 80)
                : currentWeather == null
                    ? emptyScreen()
                    : weatherScreen(currentWeather!),
          ),
        ),
      ),
    );
  }

  Widget emptyScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset('Assets/search.png').paddingForOnly(top: 200),
        Text(
          'Enter a Location to Get Started!!',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              color: GeneralUtils.primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic),
        )
      ],
    ).wrapCenter();
  }

  Widget weatherScreen(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          GeneralUtils.convertDate(weather.date!),
          style: GoogleFonts.roboto(
              color: GeneralUtils.primaryColor,
              fontSize: 40,
              fontWeight: FontWeight.bold),
        ).paddingForOnly(top: 150),
        Text(
          'Last Updated at ${weather.date!.hour}:${weather.date!.minute}:${weather.date!.second}',
          style: GoogleFonts.roboto(color: GeneralUtils.primaryColor),
        ),
        Image.network(
          'https://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
          height: 80,
        ),
        Text(
          weather.weatherMain!,
          style: GoogleFonts.roboto(
              color: GeneralUtils.primaryColor,
              fontSize: 28,
              fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weather.temperature!.celsius!.round().toString(),
              style: GoogleFonts.roboto(
                  color: GeneralUtils.primaryColor,
                  fontSize: 60,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              '°C',
              style: GoogleFonts.roboto(
                  color: GeneralUtils.primaryColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w900),
            ).paddingForOnly(top: 10)
          ],
        ).paddingForOnly(bottom: 40),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: BlurryContainer(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    getIconColumn('HUMIDITY', weather.humidity!.toString()),
                    getIconColumn('WIND', weather.windSpeed!.toString()),
                    getIconColumn(
                        'FEELS LIKE',
                        weather.tempFeelsLike!.celsius!
                            .truncateToDouble()
                            .toString())
                  ],
                ).paddingForOnly(bottom: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    getIconColumn('SUNRISE', getTimeString(weather.sunrise!)),
                    getIconColumn('SUNSET', getTimeString(weather.sunset!))
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    ).wrapCenter();
  }

  String getTimeString(DateTime time) {
    String timeString = '';
    timeString = '${time.hour}:${time.minute}:${time.second}';
    return timeString;
  }

  Widget getIconColumn(String type, String value) {
    late IconData icon;
    String suffix = '';
    switch (type) {
      case 'WIND':
        icon = Icons.wind_power_outlined;
        suffix = 'km/h';
        break;
      case 'FEELS LIKE':
        icon = Icons.thermostat_outlined;
        suffix = '°C';
        break;
      case 'HUMIDITY':
        icon = Icons.water_drop_outlined;
        suffix = '%';
        break;
      case 'SUNRISE':
        icon = Icons.sunny;
        suffix = '';
        break;
      case 'SUNSET':
        icon = Icons.sunny_snowing;
        suffix = '';
        break;
    }

    return Column(
      children: [
        Icon(
          icon,
          color: GeneralUtils.primaryColor,
          size: 40,
        ).paddingForOnly(bottom: 10),
        Text(
          type,
          style: GoogleFonts.roboto(
              color: GeneralUtils.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w900),
        ),
        Text(
          '$value$suffix',
          style: GoogleFonts.roboto(
              color: GeneralUtils.primaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
