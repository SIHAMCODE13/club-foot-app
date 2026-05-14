package com.club.model;

public enum TypeDocument {
    // JOUEUR (Player) documents
    CIN_OR_BIRTH_CERTIFICATE,    // CIN ou Acte de naissance
    IDENTITY_PHOTO,              // Photo d'identité
    PASSPORT_PHOTO,              // Photo de passeport
    MEDICAL_CERTIFICATE,         // Certificat médical d'aptitude sportive
    FEDERAL_LICENSE,             // Licence fédérale FRMF
    REGISTRATION_FORM,           // Fiche d'inscription club
    PARENTAL_AUTHORIZATION,      // Autorisation parentale (si mineur)
    
    // ENCADRANT (Coach/Staff) documents
    CIN,                         // CIN
    SPORT_DIPLOMA,               // Diplôme sportif CAF/UEFA/FRMF
    CONTRACT,                    // Contrat ou convention avec le club
    
    // ADHÉRENT (Member) documents
    ANTHROPOMETRIC_FORM,         // Fiche anthropométrique
    PAYMENT_PROOF,               // Justificatif de paiement cotisation
    
    // Shared documents (used by multiple roles)
    CRIMINAL_RECORD,             // Casier judiciaire vierge
    CV,                          // CV sportif
    FEDERAL_LICENSE_COACH,       // Licence fédérale encadrant FRMF
    MEMBERSHIP_FORM,             // Fiche d'adhésion
    PROOF_OF_ADDRESS             // Justificatif de domicile
}
