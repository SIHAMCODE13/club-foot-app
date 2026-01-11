package com.club.config;

import com.club.model.User;
import com.club.repository.UserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;

@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("========================================");
        System.out.println("🚀 Initialisation des données...");
        System.out.println("========================================");
        
        // Créer l'admin
        if (!userRepository.existsByEmail("admin@clubfoot.com")) {
            User admin = new User();
            admin.setEmail("admin@clubfoot.com");
            admin.setPassword(passwordEncoder.encode("admin123"));
            admin.setNom("Admin");
            admin.setPrenom("Super");
            admin.setRole(User.Role.ADMIN);
            admin.setActif(true);
            admin.setDateInscription(LocalDateTime.now());
            
            userRepository.save(admin);
            
            System.out.println("✅ Admin créé avec succès!");
            System.out.println("   📧 Email: admin@clubfoot.com");
            System.out.println("   🔑 Password: admin123");
        } else {
            System.out.println("ℹ️  Admin existe déjà");
        }
        
        // Créer ou mettre à jour superadmin@club.com
        userRepository.findByEmail("superadmin@club.com").ifPresentOrElse(
            existingUser -> {
                // Mettre à jour le hash du mot de passe si nécessaire
                if (!passwordEncoder.matches("admin123", existingUser.getPassword())) {
                    existingUser.setPassword(passwordEncoder.encode("admin123"));
                    userRepository.save(existingUser);
                    System.out.println("✅ SuperAdmin mis à jour avec succès!");
                    System.out.println("   📧 Email: superadmin@club.com");
                    System.out.println("   🔑 Password: admin123");
                } else {
                    System.out.println("ℹ️  SuperAdmin existe déjà avec le bon hash");
                }
            },
            () -> {
                // Créer le superadmin s'il n'existe pas
                User superAdmin = new User();
                superAdmin.setEmail("superadmin@club.com");
                superAdmin.setPassword(passwordEncoder.encode("admin123"));
                superAdmin.setNom("Admin");
                superAdmin.setPrenom("System");
                superAdmin.setRole(User.Role.ADMIN);
                superAdmin.setActif(true);
                superAdmin.setDateInscription(LocalDateTime.now());
                superAdmin.setTelephone("0600000000");
                
                userRepository.save(superAdmin);
                
                System.out.println("✅ SuperAdmin créé avec succès!");
                System.out.println("   📧 Email: superadmin@club.com");
                System.out.println("   🔑 Password: admin123");
            }
        );

        // Créer l'encadrant
        if (!userRepository.existsByEmail("encadrant@clubfoot.com")) {
            User encadrant = new User();
            encadrant.setEmail("encadrant@clubfoot.com");
            encadrant.setPassword(passwordEncoder.encode("encadrant123"));
            encadrant.setNom("Dupont");
            encadrant.setPrenom("Jean");
            encadrant.setTelephone("0612345678");
            encadrant.setRole(User.Role.ENCADRANT);
            encadrant.setActif(true);
            encadrant.setDateInscription(LocalDateTime.now());
            
            userRepository.save(encadrant);
            System.out.println("✅ Encadrant créé: encadrant@clubfoot.com / encadrant123");
        }

        // Créer l'adhérent
        if (!userRepository.existsByEmail("adherent@clubfoot.com")) {
            User adherent = new User();
            adherent.setEmail("adherent@clubfoot.com");
            adherent.setPassword(passwordEncoder.encode("adherent123"));
            adherent.setNom("Martin");
            adherent.setPrenom("Pierre");
            adherent.setTelephone("0623456789");
            adherent.setRole(User.Role.ADHERENT);
            adherent.setActif(true);
            adherent.setDateInscription(LocalDateTime.now());
            
            userRepository.save(adherent);
            System.out.println("✅ Adhérent créé: adherent@clubfoot.com / adherent123");
        }
        
        System.out.println("========================================");
        System.out.println("✨ Initialisation terminée!");
        System.out.println("🌐 Backend accessible sur: http://localhost:8082/api");
        System.out.println("========================================");
    }
}