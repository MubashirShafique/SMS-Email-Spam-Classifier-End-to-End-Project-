import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class PredictionScreen extends StatefulWidget {
  @override
  _PredictionScreenState createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final TextEditingController _controller = TextEditingController();
  String _resultMessage = "";
  bool _isLoading = false;

  Future<void> _checkSpam() async {
    if (_controller.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _resultMessage = "";
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      final url = Uri.parse('http://10.0.2.2:8000/classifier');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"text": _controller.text}),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        double prob = result['probability'] * 100;
        String label = result['label'];

        setState(() {
          if (label == "Spam") {
            _resultMessage = "There is ${prob.toInt()}% chance this is Spam";
          } else {
            _resultMessage =
                "There is ${prob.toInt()}% chance this is Not Spam";
          }
        });
      } else {
        setState(() => _resultMessage = "API Error: ${response.statusCode}");
      }
    } catch (e) {
      setState(() => _resultMessage = "Connection Failed! Check API.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1A1A2E),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 60),
        child: Column(
          children: [
            Text(
              'Spamo',
              style: GoogleFonts.poppins(
                fontSize: 45,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 40),

            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color(0xFF252545),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white10),
              ),
              child: Column(
                children: [
                  Text(
                    'Paste your message below',
                    style: GoogleFonts.poppins(
                      color: Colors.orangeAccent,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: _controller,
                    maxLines: 6,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Enter SMS or Email...",
                      hintStyle: TextStyle(color: Colors.white38),
                      filled: true,
                      fillColor: Color(0xFF16213E),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            GestureDetector(
              onTap: _isLoading ? null : _checkSpam,
              child: Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.yellow, Colors.orange],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: _isLoading
                      ? SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.black,
                            strokeWidth: 3,
                          ),
                        )
                      : Text(
                          'Check Now',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 40),

            if (_isLoading)
              Lottie.asset('assets/animation/ChasquidoQik.json', height: 150)
            else if (_resultMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  _resultMessage,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
