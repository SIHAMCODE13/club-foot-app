package com.club.dto;

import com.club.model.Document;
import com.club.model.TypeDocument;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DocumentResponse {

    private Long id;
    private TypeDocument documentType;
    private String documentLabel;
    private String fileName;
    /** Extension fichier (pdf, jpg, …) */
    private String fileType;
    /** PDF ou IMAGE pour affichage */
    private String fileCategory;
    private Long fileSize;
    private DocumentPresentationStatus status;
    private Boolean isRequired;
    /** true si le document dépend d'une condition (ex. mineur) */
    private Boolean isConditional;
    private LocalDateTime uploadedAt;
    private String rejectionReason;

    public static DocumentResponse fromEntity(Document document, String label) {
        return DocumentResponse.builder()
                .id(document.getId())
                .documentType(document.getDocumentType())
                .documentLabel(label)
                .fileName(document.getFileName())
                .fileType(document.getFileType())
                .fileCategory(document.getFileCategory())
                .fileSize(document.getFileSize())
                .status(toPresentation(document.getStatus()))
                .isRequired(document.getIsRequired())
                .isConditional(false)
                .uploadedAt(document.getUploadedAt())
                .rejectionReason(document.getRejectionReason())
                .build();
    }

    public static DocumentResponse fromEntity(Document document, String label, boolean conditional) {
        DocumentResponse r = fromEntity(document, label);
        r.setIsConditional(conditional);
        return r;
    }

    public static DocumentPresentationStatus toPresentation(Document.DocumentStatus s) {
        if (s == null) {
            return DocumentPresentationStatus.MISSING;
        }
        return switch (s) {
            case PENDING -> DocumentPresentationStatus.PENDING;
            case APPROVED -> DocumentPresentationStatus.APPROVED;
            case REJECTED -> DocumentPresentationStatus.REJECTED;
        };
    }

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

    public String getDocumentLabel() {
        return documentLabel;
    }

    public void setDocumentLabel(String documentLabel) {
        this.documentLabel = documentLabel;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
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

    public DocumentPresentationStatus getStatus() {
        return status;
    }

    public void setStatus(DocumentPresentationStatus status) {
        this.status = status;
    }

    public Boolean getIsRequired() {
        return isRequired;
    }

    public void setIsRequired(Boolean isRequired) {
        this.isRequired = isRequired;
    }

    public Boolean getIsConditional() {
        return isConditional;
    }

    public void setIsConditional(Boolean isConditional) {
        this.isConditional = isConditional;
    }

    public LocalDateTime getUploadedAt() {
        return uploadedAt;
    }

    public void setUploadedAt(LocalDateTime uploadedAt) {
        this.uploadedAt = uploadedAt;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }
}
