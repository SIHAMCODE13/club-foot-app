package com.club.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "equipes")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Equipe {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String nom;
    
    private String categorie;
    
    @ManyToOne
    @JoinColumn(name = "encadrant_id")
    private User encadrant;
    
    @OneToMany(mappedBy = "equipe", cascade = CascadeType.ALL)
    @JsonIgnore
    private List<Joueur> joueurs = new ArrayList<>();
    
    @Column(nullable = false)
    private Boolean active = true;
    
    @Column(columnDefinition = "TEXT")
    private String description;
}