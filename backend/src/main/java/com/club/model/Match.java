package com.club.model;


import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "matchs")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Match {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "equipe_id", nullable = false)
    private Equipe equipe;
    
    @Column(nullable = false)
    private String adversaire;
    
    @Column(nullable = false)
    private LocalDateTime dateHeure;
    
    @Column(nullable = false)
    private String lieu;
    
    @Enumerated(EnumType.STRING)
    private TypeMatch type = TypeMatch.AMICAL;
    
    private Integer scoreEquipe;
    
    private Integer scoreAdversaire;
    
    @Enumerated(EnumType.STRING)
    private Statut statut = Statut.PLANIFIE;
    
    @Column(columnDefinition = "TEXT")
    private String notes;
    
    @Column(columnDefinition = "TEXT")
    private String composition;
    
    public enum TypeMatch {
        CHAMPIONNAT,
        COUPE,
        AMICAL,
        TOURNOI
    }
    
    public enum Statut {
        PLANIFIE,
        EN_COURS,
        TERMINE,
        ANNULE
    }
} 
