public class Quadrilatere {

    // Attributs (longueur et largeur)
    private double longueur;
    private double largeur;

    // Constructeur par défaut (valeurs par défaut)
    public Quadrilatere() {
        this.longueur = 1.0;
        this.largeur = 1.0;
    }

    // Constructeur avec paramètres
    public Quadrilatere(double longueur, double largeur) {
        this.longueur = longueur;
        this.largeur = largeur;
    }

    // Méthode pour calculer la surface
    public double surface() {
        return longueur * largeur;
    }

    // Méthode pour calculer le périmètre
    public double perimetre() {
        return 2 * (longueur + largeur);
    }

    // Méthode pour afficher les infos du quadrilatère
    public void afficherInfos() {
        System.out.println("Quadrilatere : ");
        System.out.println("Longueur = " + longueur + ", Largeur = " + largeur);
        System.out.println("Surface = " + surface());
        System.out.println("Perimetre = " + perimetre());
        System.out.println("---------------------------");
    }
}
