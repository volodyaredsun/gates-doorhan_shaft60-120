# gates-doorhan_shaft60-120
2018.11.28
Автоматические ворота doorhan shaft 60-120.
На воротах вышел из строя контроллер управления - PIC16C57C.
Это однокрано-программируемый контроллер. Произошла ошибка во флеш-памяти, 
Контроллер одновременно подал сигналы на включение прямого и обратного движения асинхронного трехфазного электромотора,
замкнув при этом две фазы. Контроллер после такого замыкания - частично живой (ему-то ни чего не будет, с его питанием все в порядке, а вот с флеш-памятью - другой вопрос), 
на двух реле - вышли из строя контакты (прямого и обратного движения).
Влюбом случае дальше эта схема не будет обеспечивать адекватную функциональность.
Контроллер, на то время заменил на наиболее подходящий по питанию и распространнености, монтажу и наличию -
Attiny2313.
Модель реализована в Proteus.
Код написан в CodeVisionAVR.
