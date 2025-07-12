import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:weather_app/week_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Variables to hold weather data
  Map<String, dynamic>? data;
  List<dynamic>? hourlyTimes;
  List<dynamic>? hourlyTemperatures;
  List<dynamic>? hourlyHumidities;
  String? timezone;
  String? greeting;
  String? formattedDate;
  String? formattedTime;
  // Function to fetch weather data form api i use the methode Get
  //initState is used to  call  the fetchWeatherData function when the widget is first created
  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  void fetchWeatherData() async {
    // Convert URL string to Uri object
    Uri url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,relative_humidity_2m&hourly=temperature_2m,relative_humidity_2m',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
        hourlyTimes = data!['hourly']['time'].sublist(0, 24);
        hourlyTemperatures = data!['hourly']['temperature_2m'].sublist(0, 24);
        hourlyHumidities = data!['hourly']['relative_humidity_2m'].sublist(
          0,
          24,
        );
        timezone = data!['timezone'];

        // Determine the greeting and format the date and time
        DateTime currentTime = DateTime.parse(data!['current']['time']);
        int currentHour = currentTime.hour;
        if (currentHour < 12) {
          greeting = 'Good Morning';
        } else if (currentHour < 17) {
          greeting = 'Good Afternoon';
        } else {
          greeting = 'Good Evening';
        }

        // Formatted date
        formattedDate = DateFormat('EEEE d').format(currentTime);

        // Formatted time
        formattedTime = DateFormat('h:mm a').format(currentTime);
      });
    } else {
      // Handle error
      print('Error: ${response.statusCode}');
    }
  }

  // Function to create gradient text for hourly forecast text
  Widget gradientText(String text, double fontSize, FontWeight fontWeight) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [Color(0xFFFFA500), Color(0xFFFFFFFF)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(bounds),
      child: Text(
        text,
        style: GoogleFonts.openSans(fontSize: fontSize, fontWeight: fontWeight),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: data == null
          // Container serving as background to container containing circularprogressindicator
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFFA500),
                    const Color(0xFF8A2BE2).withOpacity(0.6),
                    const Color(0xFF000000),
                  ],
                ),
              ),
              // Container containing circularprogressindicator centered
              child: Center(
                // Container containing circularprogressindicator
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  height: 50.0,
                  width: 50.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  child: const CircularProgressIndicator(
                    color: Color(0xFF9370DB),
                  ),
                ),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  // ignore: deprecated_member_use
                  colors: [
                    Color(0xFFFFA500),
                    Color.fromARGB(255, 98, 0, 190).withOpacity(0.6),
                    Color(0xFF000000),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              //paddin aroud content
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 16, right: 16),
                //column start here
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Timezone ,gret and more icons in a container wrapped in a row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //Timezone and greet text
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.openSans(height: 1.1),
                            children: <TextSpan>[
                              //Timezone in text textSpan
                              TextSpan(
                                text: '$timezone  \n',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w100,
                                  color: const Color(
                                    0xFFFFFFFF,
                                  ).withOpacity(0.6),
                                ),
                              ),
                              //Greet textSpan
                              TextSpan(
                                text: '$greeting',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(
                                    0xFFFFFFFF,
                                  ).withOpacity(0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Container for More icon
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const WeekScreen(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                width: 0.4,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                            child: Icon(
                              Icons.more_vert_outlined,
                              color: Color(0xFFFFFFFF).withOpacity(0.6),
                            ),
                          ),
                        ),
                      ],
                    ),
                    //container for paddin images
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      //Container for images
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage('assets/images/image.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    //tempreature and humidity and date in a rexText
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: GoogleFonts.openSans(height: 1.1),
                          children: <TextSpan>[
                            //Timezone in text textSpan
                            TextSpan(
                              text:
                                  '${data!['current']['temperature_2m'].toString().substring(0, 2)}°C \n',
                              style: TextStyle(
                                fontSize: 75,
                                fontWeight: FontWeight.w100,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                            //Humidity textSpan
                            TextSpan(
                              text:
                                  'Humidity ${data!['current']['relative_humidity_2m']}% \n',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                            //date in a textSpan
                            TextSpan(
                              text: '$formattedDate . $formattedTime',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFFFFFFF).withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GradientText(
                            'Hourly Forecast',
                            colors: [Color(0xFFFFA500), Color(0xFFFFFFFF)],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          //
                          Container(
                            padding: const EdgeInsets.all(2.0),
                            height: 30.0,
                            width: 30.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Color(0xFFFFFFFF),
                              border: Border.all(color: Color(0xFFFFFFFF)),
                            ),
                            child: Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //expanded
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(0.0),
                        itemCount: hourlyTimes?.length ?? 0,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 35, top: 12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFFFFFFFF),
                                  width: 1,
                                ),
                              ),
                            ),
                            //hourly and tempreature in a row
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                //hourly text
                                Text(
                                  DateFormat(
                                    'h a',
                                  ).format(DateTime.parse(hourlyTimes![index])),
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                                //humidity text
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  //mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Humidity ',
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(
                                          0xFFFFFFFF,
                                        ).withOpacity(0.7),
                                      ),
                                    ),
                                    Text(
                                      '${hourlyHumidities![index].toString()}%',
                                      style: GoogleFonts.openSans(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    ),
                                  ],
                                ),
                                //tempreature text
                                Text(
                                  '${hourlyTemperatures![index].toString()}°C',
                                  style: GoogleFonts.openSans(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                //column finiched here
              ),
            ),
    );
  }
}
