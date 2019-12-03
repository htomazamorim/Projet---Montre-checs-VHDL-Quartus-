# Projet---Montre-checs-VHDL-Quartus-

Ce projet a été fait pendant u cours que j'ai eu à mon université: Laboratoire de Circuits Numériques.

Pendant ce cours, on a mis en pratique quelques techniques de développement de circuits numériques combinatoires et sequentiels.

Le but était de développer un circuit pour un montre pour les échecs et qui a été prototypé en utilisant FPGA. On avait deux joueurs et la montre changeait entre le deux avec l'appui d'une touche. De plus, on avait trois mode de jeux:

1 - Normal: on change d'un joueur à l'autre et le temps reste inchangé.
2 - Fisher: quand on change de joueur, on ajoute "delta" (défini au début du jeu) segondes au temps du joueur qui vient de finir son tour.
3 - Bronstein: on laisse le temps du joueur intouché s'il arrive à finir son tour avant "delta" segondes.

Pour mettre en place ces modes de jeu, il a fallu développer plusieurs circuits logiques: compteurs, circuits sequentiels, sommateurs, machine à états finis, etc.

Les codes en VHDL respectifs sont mis dans ce repository gitHub. Les projet a été effectué en utilisant le logiel Quartus et une FPGA Terasic DE0-CV.
