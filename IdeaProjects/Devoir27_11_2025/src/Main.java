public class Main {
    public static void main(String[] args) {

        // Instance créée avec le constructeur par défaut
        Quadrilatere q1 = new Quadrilatere();

        // Instance créée avec le constructeur avec paramètres
        Quadrilatere q2 = new Quadrilatere(4.5, 3.0);

        // Afficher surfaces et périmètres
        q1.afficherInfos();
        q2.afficherInfos();
    }
}
