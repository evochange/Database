--
-- File generated with SQLiteStudio v3.4.21 on seg jun 15 17:14:17 2026
--
-- Text encoding used: System
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: DNA_EXTRACTION
CREATE TABLE IF NOT EXISTS DNA_EXTRACTION
(
    DnaID INTEGER PRIMARY KEY AUTOINCREMENT,
    Stock VARCHAR(3) NOT NULL
        DEFAULT 'Yes'
        CHECK (Stock IN ('Yes', 'No')),
    Storage VARCHAR(50),
    Note TEXT,
    SampleID INTEGER NOT NULL,
    
    FOREIGN KEY (SampleID) REFERENCES SAMPLE(SampleID)    
);

-- Table: FILE
CREATE TABLE IF NOT EXISTS FILE (FileID INTEGER PRIMARY KEY AUTOINCREMENT, FileType VARCHAR (30) NOT NULL CHECK (FileType IN ('Permit', 'Nagoya', 'Loan', 'MTA', 'Photo')), FileLink TEXT NOT NULL UNIQUE, Note TEXT, SpecimenCode VARCHAR (25) NOT NULL, FOREIGN KEY (SpecimenCode) REFERENCES SPECIMEN (SpecimenCode));

-- Table: LIBRARYDNA
CREATE TABLE IF NOT EXISTS LIBRARYDNA (DnaLibraryID INTEGER PRIMARY KEY AUTOINCREMENT, LibraryType VARCHAR (30) NOT NULL CHECK (LibraryType IN ('WGS', 'PoolSeq', 'RADSeq', 'Capture')), LibraryStorage VARCHAR (50), PoolSeqContent TEXT, Method VARCHAR (50), Sequencing VARCHAR (30) CHECK (Sequencing IN ('MiSeq', 'HiSeq', 'NovaSeq')), Coverage CHAR (2) CHECK (Coverage IN ('lc', 'mc', 'hc')), Files TEXT, Accessions TEXT, Publications TEXT, Note TEXT, DnaID INTEGER NOT NULL, FOREIGN KEY (DnaID) REFERENCES DNA_EXTRACTION (DnaID), CHECK (PoolSeqContent IS NULL OR LibraryType = 'PoolSeq'));

-- Table: LIBRARYRNA
CREATE TABLE IF NOT EXISTS LIBRARYRNA
(
    RnaLibraryID INTEGER PRIMARY KEY AUTOINCREMENT,
    LibraryType VARCHAR(30) NOT NULL
        CHECK (LibraryType IN ('RNASeq')),
    LibraryStorage VARCHAR(50),
    Method VARCHAR(50),
    Sequencing VARCHAR(30)
        CHECK (Sequencing IN ('MiSeq', 'HiSeq', 'NovaSeq')),
    Coverage CHAR(2)
        CHECK (Coverage IN ('lc', 'mc', 'hc')),
    Files TEXT,
    Accessions TEXT,
    Publications TEXT,
    Note TEXT,
    RnaID INTEGER NOT NULL,        
    
    FOREIGN KEY (RnaID) REFERENCES RNA_EXTRACTION(RnaID)
);

-- Table: LOCATION
CREATE TABLE IF NOT EXISTS LOCATION (LocationID INTEGER PRIMARY KEY AUTOINCREMENT, LocalityName VARCHAR (50) NOT NULL, LocalityCode CHAR (4) NOT NULL, Country VARCHAR (55) NOT NULL, UNIQUE (Country, LocalityName));

-- Table: MTDNA
CREATE TABLE IF NOT EXISTS MTDNA
(
    MtDnaID INTEGER PRIMARY KEY AUTOINCREMENT,
    DataType VARCHAR(50),
    MtType VARCHAR(50)
        CHECK (MtType IN ('RFLP', 'Sanger-Say-Gene', 'Mitochondrion Sanger', 'Mitochondrion Reconstructed WGS')),
    Files TEXT,
    Accessions TEXT,
    Publications TEXT,
    Note TEXT,
    DnaID INTEGER NOT NULL,       
    
    FOREIGN KEY (DnaID) REFERENCES DNA_EXTRACTION(DnaID)
);

-- Table: PROVIDER
CREATE TABLE IF NOT EXISTS PROVIDER (ProviderID INTEGER PRIMARY KEY AUTOINCREMENT, Origin VARCHAR (30) NOT NULL CHECK (Origin IN ('Researcher', 'Museum', 'Donation')), Name VARCHAR (100) NOT NULL UNIQUE, Affiliation TEXT NOT NULL, Email VARCHAR (100) NOT NULL);

-- Table: RNA_EXTRACTION
CREATE TABLE IF NOT EXISTS RNA_EXTRACTION
(
    RnaID INTEGER PRIMARY KEY AUTOINCREMENT,
    Stock VARCHAR(3) NOT NULL
        DEFAULT 'Yes'
        CHECK (Stock IN ('Yes', 'No')),
    Storage VARCHAR(50),
    Note TEXT,
    SampleID INTEGER NOT NULL,
    
    FOREIGN KEY (SampleID) REFERENCES SAMPLE(SampleID)    
);

-- Table: RNAQPCR
CREATE TABLE IF NOT EXISTS RNAQPCR
(
    RnaqPcrID INTEGER PRIMARY KEY AUTOINCREMENT,
    Method VARCHAR(50),
    Genes TEXT,
    Publications TEXT,
    Note TEXT,
    RnaID INTEGER NOT NULL,        
    
    FOREIGN KEY (RnaID) REFERENCES RNA_EXTRACTION(RnaID)
);

-- Table: SAMPLE
CREATE TABLE IF NOT EXISTS SAMPLE (SampleID INTEGER PRIMARY KEY AUTOINCREMENT, OtherSampleID TEXT, SampleExists VARCHAR (3) NOT NULL DEFAULT 'Yes' CHECK (SampleExists IN ('Yes', 'No')), Tissue VARCHAR (30) NOT NULL, TissueCode CHAR (2) NOT NULL, PreservativeCollection VARCHAR (30) NOT NULL, Note TEXT, SpecimenCode VARCHAR (25) NOT NULL, FOREIGN KEY (SpecimenCode) REFERENCES SPECIMEN (SpecimenCode));

-- Table: SAMPLE_TO_STORAGE
CREATE TABLE IF NOT EXISTS SAMPLE_TO_STORAGE
(
    SampleID INTEGER NOT NULL,
    StorageID INTEGER NOT NULL,
    StorageDate VARCHAR(20),
    Preservative VARCHAR(30),
    Amount INTEGER
        CHECK (Amount IN (0, 1, 2)),
    Note TEXT,
    
    PRIMARY KEY (SampleID, StorageID),
    FOREIGN KEY (SampleID) REFERENCES SAMPLE(SampleID),
    FOREIGN KEY (StorageID) REFERENCES STORAGE(StorageID)    
);

-- Table: SPECIES
CREATE TABLE IF NOT EXISTS SPECIES
(
    SpeciesID INTEGER PRIMARY KEY AUTOINCREMENT,
    SpeciesCode CHAR(4) NOT NULL UNIQUE,
    NCBITaxonID INTEGER UNIQUE,
    Genus VARCHAR(30) NOT NULL,
    SpeciesName VARCHAR(50) NOT NULL UNIQUE,
    CommonName VARCHAR(50) NOT NULL UNIQUE
);

-- Table: SPECIMEN
CREATE TABLE IF NOT EXISTS SPECIMEN (SpecimenCode VARCHAR (25) PRIMARY KEY, OtherSpecimenID TEXT, CollectionDay INTEGER CHECK (CollectionDay BETWEEN 1 AND 31), CollectionMonth INTEGER CHECK (CollectionMonth BETWEEN 1 AND 12), CollectionYear INTEGER NOT NULL, CheckInDate VARCHAR (20), Sex CHAR (1) NOT NULL CHECK (Sex IN ('M', 'F', 'U')), SexMethod VARCHAR (30) CHECK (SexMethod IN ('Morphological', 'PCR', 'Sequencing')), Note TEXT, ProviderID INTEGER NOT NULL, ProviderNote TEXT, SpeciesID INTEGER NOT NULL, SpeciesIdentityMethod VARCHAR (50) NOT NULL, SpeciesIdentityRisk VARCHAR (3) CHECK (SpeciesIdentityRisk IN ('Yes', 'No')), SpeciesIdentityRiskReason VARCHAR (50), Infraspecific VARCHAR (50), SpeciesNote TEXT, LocationID INTEGER NOT NULL, Latitude REAL NOT NULL CHECK (Latitude BETWEEN - 90 AND 90), Longitude REAL NOT NULL CHECK (Longitude BETWEEN - 180 AND 180), CoordinatePrecision VARCHAR (30) NOT NULL CHECK (CoordinatePrecision IN ('Country', 'Region', 'Locality', 'Exact')), LocalityInfo TEXT, FOREIGN KEY (ProviderID) REFERENCES PROVIDER (ProviderID), FOREIGN KEY (SpeciesID) REFERENCES SPECIES (SpeciesID), FOREIGN KEY (LocationID) REFERENCES LOCATION (LocationID));

-- Table: STORAGE
CREATE TABLE IF NOT EXISTS STORAGE (StorageID INTEGER PRIMARY KEY AUTOINCREMENT, StorageType VARCHAR (30) NOT NULL CHECK (StorageType IN ('RT', 'Freezer', 'ULT')), StorageLocation VARCHAR (100));

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
