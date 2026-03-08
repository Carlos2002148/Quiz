import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizz/model/category.dart';
import 'package:quizz/screens/quiz_screen.dart';
import 'package:quizz/widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<QuizCategory> categories = [
    QuizCategory(name: 'Conocimiento general',
        icon: Icons.lightbulb_circle_outlined,
        color: Color(0xFF6C63FF),
        description: 'Test general de conocimiento basico con respuestas en opcion multiple',
        questionCount: 25),
    QuizCategory(name: 'Historia',
        icon: Icons.lightbulb_circle_outlined,
        color: Colors.purple,
        description: 'Test general de conocimiento basico en Historia con respuestas en opcion multiple',
        questionCount: 25),
    QuizCategory(name: 'Ciencias',
        icon: Icons.lightbulb_circle_outlined,
        color: Colors.green,
        description: 'Test general de conocimiento basico en ciencias con respuestas en opcion multiple',
        questionCount: 25),
    QuizCategory(name: 'Geografia',
        icon: Icons.lightbulb_circle_outlined,
        color: Colors.brown,
        description: 'Test general de conocimiento basico en Geografia con respuestas en opcion multiple',
        questionCount: 25),
  ];


  //Comando para crear esta seccion ini
  @override
  void initState() {
    super.initState();

    _fadeController =
        AnimationController( // <-- Aquí inicializas _fadeController (2000ms)
          duration: const Duration(milliseconds: 2000),
          vsync: this,
        );

    _slideController = AnimationController( // <--- AQUÍ ESTÁ EL ERROR.
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0).animate(
        CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut)
    );

    _slideAnimation = Tween<Offset>(
        begin: const Offset(0.0, 1.0),
        end: Offset.zero
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut)
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8F9FF), Color(0xFFE8EAFF), Color(0xFFF0F2FF)],
            )
        ),
          child: SafeArea(child: SingleChildScrollView(
            child: Padding(padding: EdgeInsetsGeometry.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Bienvenidos",
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text('Disfrutalo',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF4A5568),
                                    )),
                              ],
                            ),
                            Container(
                              padding: EdgeInsetsGeometry.all(12),
                              decoration: BoxDecoration(
                                color: Color(0xFFEDF2F7).withOpacity(0.1),
                                borderRadius: .circular(16),
                              ),
                              child: Icon(
                                Icons.psychology,
                                size: 32,
                                color: Color(0xFF6C63FF),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
  
                  SlideTransition(position: _slideAnimation,
                    child: Container(
                      padding: EdgeInsetsGeometry.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _buildStatItem(
                            'Preguntas Totales',
                            '10',
                            Icons.quiz,
                            Color(0xFF6C63FF),
                          ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          Expanded(child: _buildStatItem(
                            'Categorias',
                            '4',
                            Icons.category,
                            Color(0xFF4ECDC4),
                          ),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          Expanded(child: _buildStatItem(
                            'Dificultad',
                            'baja',
                            Icons.trending_up,
                            Color(0xFFFFb74d),
                          ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
  
                  FadeTransition(opacity: _fadeAnimation,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('preguntas rapidas',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF2D3748),
                                ),
                                ),
                              ],
                            )
                          ),
                          SizedBox(height: 9),
  
                          ElevatedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              final randomCategory = (categories.toList()..shuffle()).first;

                              Navigator.push(context, MaterialPageRoute(
                                  builder: (context) => QuizScreen(
                                    category:randomCategory,
                                  ),
                              ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF6C63FF),
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadiusGeometry.circular(30),
                              ),
                            ),
                            child: Text(
                              "Iniciar Quiz",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  FadeTransition(opacity: _fadeAnimation,
                    child: Text(
                      'Escoge tu Categoria',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3748)
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SlideTransition(position: _slideAnimation,
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.7
                      ),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                          return CategoryCard(
                            category: categories[index],
                            onTap: () {
                              HapticFeedback.lightImpact();
                            },
                          );
                        },
                      ),
                    ),

                ],
              ),
            ),
          )
        ),
      ),
    );
  }

 Widget _buildStatItem(
     String title,
     String value,
     IconData icon,
     Color color,
     ){
    return Column(
    children: [
      Icon(icon, color: color, size: 24),
      SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          fontSize: 18,
          color: Color(0xFF4A5568),
          fontWeight: FontWeight.bold,
        ),
      ),
      SizedBox(height: 4),
      Text(title, style: TextStyle(fontSize: 14, color: Color(0xFF4A5568))),
    ],
    );
 }
}
