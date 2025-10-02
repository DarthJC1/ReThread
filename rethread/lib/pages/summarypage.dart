import 'package:flutter/material.dart';
import 'dart:math' as math;

class Summarypage extends StatelessWidget {
  const Summarypage({super.key});
  @override
  Widget build(BuildContext context) {


    final math.Random random = math.Random();
    int ehe = random.nextInt(3);


    return Scaffold(
      appBar: AppBar(
        title: const Text('Summary Page'),
      ),
      body: 
            ehe == 0 ? Text("Oke, kayaknya ini udah agak lusuh dan sulit dipakai ulang. Tapi jangan sedih! 🧵♻️ Baju ini masih bisa direcycle loh! Misalnya dijadikan kain lap, bahan kerajinan, atau bahkan diolah lagi jadi serat tekstil baru. Jadi walaupun udah nggak kepake buat dipakai sehari-hari, bajumu masih bisa punya ‘kehidupan kedua’. 🌱") :
            ehe == 1 ? Text("✨ Eits, tunggu dulu… Bajumu masih kece banget nih 👕✨ Daripada direcycle, baju ini lebih cocok buat reuse. Kamu bisa pakai lagi, sumbangkan ke orang yang butuh, atau bahkan dijual biar nambah cuan 💸. Sayang banget kalau langsung dihancurin, kan?") :
            Text("⚠️ Uh-oh… Sepertinya bajumu udah melewati masa jayanya 😢👕 Kondisinya susah banget buat reuse atau recycle. Jadi opsi terbaik sekarang adalah remove/dispose dengan cara yang ramah lingkungan, misalnya setor ke bank sampah atau layanan pengelolaan tekstil. Jangan langsung buang ke TPA ya, biar nggak nambahin limbah sembarangan 🌍.")

        
        
      ),
    );
  }
}