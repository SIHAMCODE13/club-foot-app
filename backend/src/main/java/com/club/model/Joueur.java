package com.club.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "joueurs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Joueur {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String nom;
    
    @Column(nullable = false)
    private String prenom;
    
    @Column(name = "date_naissance")
    private String dateNaissance;
    
    private String nationalite;
    
    @Column(nullable = false)
    private String poste;
    
    @Column(name = "numero_maillot")
    private Integer numeroMaillot;
    
    private Double poids;
    
    private Double taille;
    
    private String photo;
    
    @ManyToOne
    @JoinColumn(name = "equipe_id")
    private Equipe equipe;
    
    @Column(nullable = false)
    private Boolean actif = true;
    
    @Column(columnDefinition = "TEXT")
    private String notes;
}