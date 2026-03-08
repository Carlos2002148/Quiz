import 'package:flutter/material.dart';

class AnswerCard extends StatefulWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;
  final Color color;

  const AnswerCard({super.key, required this.text, required this.isSelected, required this.isCorrect, required this.isWrong, required this.onTap, required this.color});


  @override
  State<AnswerCard> createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  // Getter para el color de fondo de la tarjeta
  Color get cardColor {
    // 1. Si el usuario ya contestó:
    if (widget.isCorrect) return Colors.green; // Se pinta verde si es la respuesta correcta
    if (widget.isSelected && widget.isWrong) return Colors.red; // Se pinta rojo solo si la elegí y está mal

    // 2. Si solo está seleccionada (antes de confirmar o si es el estilo base)
    if (widget.isSelected) return widget.color.withOpacity(0.2);

    return Colors.white;
  }

  // Getter para el color del texto
  Color get textColor {
    if (widget.isCorrect || (widget.isSelected && widget.isWrong)) {
      return Colors.white;
    }
    return const Color(0xFF2D3748); // Un gris oscuro para que sea legible en blanco
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 16),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) => _controller.reverse(),
        onTapCancel: () => _controller.reverse(),
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(0.3),
                  blurRadius: 20.0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if(widget.isCorrect)
                  Icon(Icons.check_circle, color: Colors.white, size: 24,),
                if(widget.isWrong)
                  Icon(Icons.cancel, color: Colors.white, size: 24,),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
