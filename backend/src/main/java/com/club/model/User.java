package com.club.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.time.LocalDateTime;
import java.util.Collection;
import java.util.Collections;

@Entity
@Table(name = "users")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class User implements UserDetails {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(nullable = false)
    private String password;
    
    @Column(nullable = false)
    private String nom;
    
    @Column(nullable = false)
    private String prenom;
    
    private String telephone;
    
    private String adresse;
    
    @Column(name = "date_naissance")
    private String dateNaissance;
    
    private String photo;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role = Role.INSCRIT;
    
    @Column(nullable = false)
    private Boolean actif = true;
    
    @Column(name = "date_inscription")
    private LocalDateTime dateInscription = LocalDateTime.now();
    
    @Column(name = "derniere_connexion")
    private LocalDateTime derniereConnexion;
    
    // UserDetails implementation
    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(new SimpleGrantedAuthority("ROLE_" + role.name()));
    }
    
    @Override
    public String getUsername() {
        return email;
    }
    
    @Override
    public boolean isAccountNonExpired() {
        return true;
    }
    
    @Override
    public boolean isAccountNonLocked() {
        return actif;
    }
    
    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }
    
    @Override
    public boolean isEnabled() {
        return actif;
    }
    
    public enum Role {
        ADMIN,
        ENCADRANT,
        ADHERENT,
        INSCRIT
    }
}