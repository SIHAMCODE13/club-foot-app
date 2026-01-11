package com.club.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Entity
@Table(name = "cotisations")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Cotisation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    @Column(nullable = false)
    private Double montant;
    
    @Column(nullable = false)
    private LocalDateTime datePaiement;
    
    @Column(nullable = false)
    private String saison;
    
    @Enumerated(EnumType.STRING)
    private ModePaiement modePaiement = ModePaiement.ESPECES;
    
    @Enumerated(EnumType.STRING)
    private Statut statut = Statut.EN_ATTENTE;
    
    private String reference;
    
    @Column(columnDefinition = "TEXT")
    private String notes;
    
    public enum ModePaiement {
        ESPECES,
        CARTE_BANCAIRE,
        VIREMENT,
        CHEQUE
    }
    
    public enum Statut {
        EN_ATTENTE,
        VALIDEE,
        REJETEE
    }
}