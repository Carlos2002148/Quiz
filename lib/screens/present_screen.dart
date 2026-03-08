import 'package:flutter/material.dart';
import 'package:quizz/screens/home_Screen.dart';

class PresentScreen extends StatelessWidget {
  const PresentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Estilo base para los nombres
    const TextStyle nombreEstilo = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Color(0xFF333333),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),

                // --- LOGO UNISON ---
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    image: const DecorationImage(
                      image: AssetImage('assets/logo_unison.png'),
                      fit: BoxFit.contain,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // --- TÍTULO DEL PROYECTO ---
                const Text(
                  'Quizz Time',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B0FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'PROYECTO DE INGENIERÍA - UNISON',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF00B0FF),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),

                const SizedBox(height: 50),

                // --- SECCIÓN DE INTEGRANTES ---
                const Text(
                  'INTEGRANTES DEL EQUIPO',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 20),

                // Contenedor de nombres (Sin iconos)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: const Column(
                    children: [
                      Text('Carlos Guadalupe Grijalva Castillo', style: nombreEstilo),
                      Divider(height: 20),
                      Text('Jorge Luis Ruiz Muños', style: nombreEstilo),
                      Divider(height: 20),
                      Text('Isaac Moreno Gonzalez', style: nombreEstilo),
                      Divider(height: 20),
                      Text('Carlos Rene Quijada Ruiz Lopez', style: nombreEstilo),
                    ],
                  ),
                ),

                const SizedBox(height: 60),

                // --- BOTÓN DE ACCIÓN ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00B0FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      elevation: 8,
                      shadowColor: const Color(0xFF00B0FF).withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'INICIAR NAVEGACIÓN',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}