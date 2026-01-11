package com.club.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "entrainements")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Entrainement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "equipe_id", nullable = false)
    private Equipe equipe;
    
    @Column(nullable = false)
    private LocalDateTime dateHeure;
    
    @Column(nullable = false)
    private String lieu;
    
    private Integer duree;
    
    @Column(columnDefinition = "TEXT")
    private String objectif;
    
    @Column(columnDefinition = "TEXT")
    private String exercices;
    
    @ManyToOne
    @JoinColumn(name = "encadrant_id")
    private User encadrant;
    
    @Enumerated(EnumType.STRING)
    private Statut statut = Statut.PLANIFIE;
    
    @Column(columnDefinition = "TEXT")
    private String notes;
    
    public enum Statut {
        PLANIFIE,
        EN_COURS,
        TERMINE,
        ANNULE
    }
}