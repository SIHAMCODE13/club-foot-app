package com.club.dto;

import com.club.model.RegistrationStatus;
import com.club.model.User;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserWithDocumentsResponse {
    
    private Long id;
    private String firstName;
    private String lastName;
    private String email;
    private String phone;
    private LocalDate dateOfBirth;
    private User.Role role;
    private User.AccountStatus accountStatus;
    /** PENDING, ACTIVE, REJECTED */
    private RegistrationStatus registrationStatus;
    private Boolean actif;
    private LocalDateTime dateInscription;
    private String address;
    
    private List<DocumentResponse> documents;
    private Integer completionPercentage; // Percentage of required documents uploaded and approved
    private Integer documentsCompleted;
    private Integer documentsRequired;
    private List<DocumentResponse> missingDocuments;
    
    public static UserWithDocumentsResponse fromEntity(User user, List<DocumentResponse> documents, 
                                                        Integer completionPercentage, 
                                                        Integer documentsCompleted,
                                                        Integer documentsRequired,
                                                        List<DocumentResponse> missingDocuments) {
        return UserWithDocumentsResponse.builder()
                .id(user.getId())
                .firstName(user.getPrenom())
                .lastName(user.getNom())
                .email(user.getEmail())
                .phone(user.getTelephone())
                .dateOfBirth(parseDate(user.getDateNaissance()))
                .role(user.getRole())
                .accountStatus(user.getAccountStatus())
                .registrationStatus(user.getRegistrationStatus())
                .actif(user.getActif())
                .dateInscription(user.getDateInscription())
                .address(user.getAdresse())
                .documents(documents)
                .completionPercentage(completionPercentage)
                .documentsCompleted(documentsCompleted)
                .documentsRequired(documentsRequired)
                .missingDocuments(missingDocuments)
                .build();
    }
    
    private static LocalDate parseDate(String dateStr) {
        if (dateStr == null || dateStr.isEmpty()) {
            return null;
        }
        try {
            return LocalDate.parse(dateStr);
        } catch (Exception e) {
            return null;
        }
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public User.Role getRole() {
        return role;
    }

    public void setRole(User.Role role) {
        this.role = role;
    }

    public User.AccountStatus getAccountStatus() {
        return accountStatus;
    }

    public void setAccountStatus(User.AccountStatus accountStatus) {
        this.accountStatus = accountStatus;
    }

    public RegistrationStatus getRegistrationStatus() {
        return registrationStatus;
    }

    public void setRegistrationStatus(RegistrationStatus registrationStatus) {
        this.registrationStatus = registrationStatus;
    }

    public Boolean getActif() {
        return actif;
    }

    public void setActif(Boolean actif) {
        this.actif = actif;
    }

    public LocalDateTime getDateInscription() {
        return dateInscription;
    }

    public void setDateInscription(LocalDateTime dateInscription) {
        this.dateInscription = dateInscription;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public List<DocumentResponse> getDocuments() {
        return documents;
    }

    public void setDocuments(List<DocumentResponse> documents) {
        this.documents = documents;
    }

    public Integer getCompletionPercentage() {
        return completionPercentage;
    }

    public void setCompletionPercentage(Integer completionPercentage) {
        this.completionPercentage = completionPercentage;
    }

    public Integer getDocumentsCompleted() {
        return documentsCompleted;
    }

    public void setDocumentsCompleted(Integer documentsCompleted) {
        this.documentsCompleted = documentsCompleted;
    }

    public Integer getDocumentsRequired() {
        return documentsRequired;
    }

    public void setDocumentsRequired(Integer documentsRequired) {
        this.documentsRequired = documentsRequired;
    }

    public List<DocumentResponse> getMissingDocuments() {
        return missingDocuments;
    }

    public void setMissingDocuments(List<DocumentResponse> missingDocuments) {
        this.missingDocuments = missingDocuments;
    }
}
