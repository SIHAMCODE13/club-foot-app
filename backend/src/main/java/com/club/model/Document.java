package com.club.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Entity
@Table(name = "documents")
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Document {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(name = "document_type", nullable = false)
    private TypeDocument documentType;

    @Column(name = "file_name", nullable = false)
    private String fileName;

    @Column(name = "file_path", nullable = false)
    private String filePath;

    @Column(name = "file_type", nullable = false)
    private String fileType; // extension: pdf, jpg, png

    /** PDF ou IMAGE (règles métier : photo d'identité = IMAGE uniquement) */
    @Column(name = "file_category", nullable = true)
    private String fileCategory;

    @Column(name = "file_size")
    private Long fileSize; // in bytes

    @Column(name = "is_required", nullable = false)
    private Boolean isRequired = true;

    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private DocumentStatus status = DocumentStatus.PENDING;

    @Column(name = "rejection_reason")
    private String rejectionReason;

    @Column(name = "uploaded_at", nullable = false)
    private LocalDateTime uploadedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public TypeDocument getDocumentType() {
        return documentType;
    }

    public void setDocumentType(TypeDocument documentType) {
        this.documentType = documentType;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFilePath() {
        return filePath;
    }

    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }

    public String getFileType() {
        return fileType;
    }

    public void setFileType(String fileType) {
        this.fileType = fileType;
    }

    public String getFileCategory() {
        return fileCategory;
    }

    public void setFileCategory(String fileCategory) {
        this.fileCategory = fileCategory;
    }

    public Long getFileSize() {
        return fileSize;
    }

    public void setFileSize(Long fileSize) {
        this.fileSize = fileSize;
    }

    public Boolean getIsRequired() {
        return isRequired;
    }

    public void setIsRequired(Boolean isRequired) {
        this.isRequired = isRequired;
    }

    public DocumentStatus getStatus() {
        return status;
    }

    public void setStatus(DocumentStatus status) {
        this.status = status;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public static DocumentBuilder builder() {
        return new DocumentBuilder();
    }

    public static class DocumentBuilder {
        private Document document;

        public DocumentBuilder() {
            this.document = new Document();
        }

        public DocumentBuilder id(Long id) {
            document.setId(id);
            return this;
        }

        public DocumentBuilder documentType(TypeDocument documentType) {
            document.setDocumentType(documentType);
            return this;
        }

        public DocumentBuilder fileName(String fileName) {
            document.setFileName(fileName);
            return this;
        }

        public DocumentBuilder filePath(String filePath) {
            document.setFilePath(filePath);
            return this;
        }

        public DocumentBuilder fileType(String fileType) {
            document.setFileType(fileType);
            return this;
        }

        public DocumentBuilder fileCategory(String fileCategory) {
            document.setFileCategory(fileCategory);
            return this;
        }

        public DocumentBuilder fileSize(Long fileSize) {
            document.setFileSize(fileSize);
            return this;
        }

        public DocumentBuilder isRequired(Boolean isRequired) {
            document.setIsRequired(isRequired);
            return this;
        }

        public DocumentBuilder status(DocumentStatus status) {
            document.setStatus(status);
            return this;
        }

        public DocumentBuilder rejectionReason(String rejectionReason) {
            document.setRejectionReason(rejectionReason);
            return this;
        }

        public DocumentBuilder uploadedAt(LocalDateTime uploadedAt) {
            document.setUploadedAt(uploadedAt);
            return this;
        }

        public DocumentBuilder user(User user) {
            document.setUser(user);
            return this;
        }

        public Document build() {
            return document;
        }
    }

    public enum DocumentStatus {
        PENDING,    // En attente de validation
        APPROVED,   // Approuvé
        REJECTED    // Rejeté
    }
}
