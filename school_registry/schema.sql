/*
Created: 12.10.2025
Modified: 12.10.2025
Model: PostgreSQL 12
Database: PostgreSQL 12
*/

-- Create tables section -------------------------------------------------

-- Table School

CREATE TABLE "School"
(
  "Official_Name" Character varying(255) NOT NULL,
  "Legal_Adress" Text NOT NULL,
  "Phone" Character varying(20) NOT NULL,
  "Email" Character varying(100),
  "Website" Character varying(200),
  "Founding_Date" Date,
  "Number_of_Students" Bigint,
  "License" Text,
  "Accreditation" Text,
  "PK_School" BigSerial NOT NULL,
  "PK_Type_of_School" Bigint NOT NULL,
  "PK_Settlement" Bigint
)
WITH (
  autovacuum_enabled=true)
;

CREATE INDEX "IX_Relationship17" ON "School" ("PK_Type_of_School")
;

CREATE INDEX "IX_Relationship25" ON "School" ("PK_Settlement")
;

ALTER TABLE "School" ADD CONSTRAINT "PK_School" PRIMARY KEY ("PK_School")
;

-- Table Education_Program

CREATE TABLE "Education_Program"
(
  "Code_Designation" Character varying(50) NOT NULL,
  "Name" Character varying(255) NOT NULL,
  "Type" Character varying(20) NOT NULL,
  "PK_Education_Program" BigSerial NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "Education_Program" ADD CONSTRAINT "PK_Education_Program" PRIMARY KEY ("PK_Education_Program")
;

-- Table Settlement

CREATE TABLE "Settlement"
(
  "Name" Character varying(100) NOT NULL,
  "Type" Character varying(20) NOT NULL,
  "PK_Settlement" BigSerial NOT NULL,
  "PK_District" Bigint
)
WITH (
  autovacuum_enabled=true)
;

CREATE INDEX "IX_Relationship24" ON "Settlement" ("PK_District")
;

ALTER TABLE "Settlement" ADD CONSTRAINT "PK_Settlement" PRIMARY KEY ("PK_Settlement")
;

-- Table District

CREATE TABLE "District"
(
  "PK_District" BigSerial NOT NULL,
  "Name" Character varying(255) NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "District" ADD CONSTRAINT "PK_District" PRIMARY KEY ("PK_District")
;

-- Table Type_of_School

CREATE TABLE "Type_of_School"
(
  "PK_Type_of_School" BigSerial NOT NULL,
  "Name" Character varying(255) NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "Type_of_School" ADD CONSTRAINT "PK_Type_of_School" PRIMARY KEY ("PK_Type_of_School")
;

-- Table Infrastructure

CREATE TABLE "Infrastructure"
(
  "PK_Infrastructure" BigSerial NOT NULL,
  "Name" Character varying(50) NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "Infrastructure" ADD CONSTRAINT "PK_Infrastructure" PRIMARY KEY ("PK_Infrastructure")
;

-- Table Specialization

CREATE TABLE "Specialization"
(
  "PK_Specialization" BigSerial NOT NULL,
  "Name" Character varying(50) NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "Specialization" ADD CONSTRAINT "PK_Specialization" PRIMARY KEY ("PK_Specialization")
;

-- Table Review

CREATE TABLE "Review"
(
  "PK_Review" BigSerial NOT NULL,
  "Author" Character varying(100),
  "Text" Text,
  "Date" Date NOT NULL,
  "Rating" Integer NOT NULL,
  "PK_School" Bigint
)
WITH (
  autovacuum_enabled=true)
;

CREATE INDEX "IX_Relationship26" ON "Review" ("PK_School")
;

ALTER TABLE "Review" ADD CONSTRAINT "PK_Review" PRIMARY KEY ("PK_Review")
;

-- Table Inspection

CREATE TABLE "Inspection"
(
  "PK_Inspection" BigSerial NOT NULL,
  "Date" Date NOT NULL,
  "Result" Text NOT NULL,
  "Prescription_Number" Character varying(50) NOT NULL,
  "PK_School" Bigint
)
WITH (
  autovacuum_enabled=true)
;

CREATE INDEX "IX_Relationship27" ON "Inspection" ("PK_School")
;

ALTER TABLE "Inspection" ADD CONSTRAINT "PK_Inspection" PRIMARY KEY ("PK_Inspection")
;

-- Table Subject

CREATE TABLE "Subject"
(
  "PK_Subject" BigSerial NOT NULL,
  "Name" Character varying(100) NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "Subject" ADD CONSTRAINT "PK_Subject" PRIMARY KEY ("PK_Subject")
;

-- Table Employee

CREATE TABLE "Employee"
(
  "PK_Employee" BigSerial NOT NULL,
  "Full_Name" Character varying(100) NOT NULL,
  "Position" Character varying(50) NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "Employee" ADD CONSTRAINT "PK_Employee" PRIMARY KEY ("PK_Employee")
;

-- Table School_Infrastructure

CREATE TABLE "School_Infrastructure"
(
  "PK_Infrastructure" Bigint NOT NULL,
  "PK_School" Bigint NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "School_Infrastructure" ADD CONSTRAINT "PK_School_Infrastructure" PRIMARY KEY ("PK_Infrastructure","PK_School")
;

-- Table School_Specialization

CREATE TABLE "School_Specialization"
(
  "PK_Specialization" Bigint NOT NULL,
  "PK_School" Bigint NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "School_Specialization" ADD CONSTRAINT "PK_School_Specialization" PRIMARY KEY ("PK_Specialization","PK_School")
;

-- Table School_Employee

CREATE TABLE "School_Employee"
(
  "PK_School" Bigint NOT NULL,
  "PK_Employee" Bigint NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "School_Employee" ADD CONSTRAINT "PK_School_Employee" PRIMARY KEY ("PK_School","PK_Employee")
;

-- Table Employee_Subject_Competence

CREATE TABLE "Employee_Subject_Competence"
(
  "PK_Subject" Bigint NOT NULL,
  "PK_Employee" Bigint NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "Employee_Subject_Competence" ADD CONSTRAINT "PK_Employee_Subject_Competence" PRIMARY KEY ("PK_Subject","PK_Employee")
;

-- Table School_Program_Implementation

CREATE TABLE "School_Program_Implementation"
(
  "PK_School" Bigint NOT NULL,
  "PK_Education_Program" Bigint NOT NULL
)
WITH (
  autovacuum_enabled=true)
;

ALTER TABLE "School_Program_Implementation" ADD CONSTRAINT "PK_School_Program_Implementation" PRIMARY KEY ("PK_School","PK_Education_Program")
;

-- Create views section -------------------------------------------------

CREATE VIEW "View1" AS
  SELECT 
;

-- Create foreign keys (relationships) section -------------------------------------------------

ALTER TABLE "School"
  ADD CONSTRAINT "is_of_type"
    FOREIGN KEY ("PK_Type_of_School")
    REFERENCES "Type_of_School" ("PK_Type_of_School")
      ON DELETE RESTRICT
      ON UPDATE RESTRICT
;

ALTER TABLE "School_Infrastructure"
  ADD CONSTRAINT "includes"
    FOREIGN KEY ("PK_Infrastructure")
    REFERENCES "Infrastructure" ("PK_Infrastructure")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "School_Infrastructure"
  ADD CONSTRAINT "has"
    FOREIGN KEY ("PK_School")
    REFERENCES "School" ("PK_School")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "School_Specialization"
  ADD CONSTRAINT "specializes_in"
    FOREIGN KEY ("PK_Specialization")
    REFERENCES "Specialization" ("PK_Specialization")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "School_Specialization"
  ADD CONSTRAINT "offers"
    FOREIGN KEY ("PK_School")
    REFERENCES "School" ("PK_School")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "Settlement"
  ADD CONSTRAINT "belongs_to"
    FOREIGN KEY ("PK_District")
    REFERENCES "District" ("PK_District")
      ON DELETE RESTRICT
      ON UPDATE RESTRICT
;

ALTER TABLE "School"
  ADD CONSTRAINT "located_in"
    FOREIGN KEY ("PK_Settlement")
    REFERENCES "Settlement" ("PK_Settlement")
      ON DELETE RESTRICT
      ON UPDATE RESTRICT
;

ALTER TABLE "Review"
  ADD CONSTRAINT "refers_to"
    FOREIGN KEY ("PK_School")
    REFERENCES "School" ("PK_School")
      ON DELETE RESTRICT
      ON UPDATE RESTRICT
;

ALTER TABLE "Inspection"
  ADD CONSTRAINT "conducted_at"
    FOREIGN KEY ("PK_School")
    REFERENCES "School" ("PK_School")
      ON DELETE RESTRICT
      ON UPDATE RESTRICT
;

ALTER TABLE "School_Employee"
  ADD CONSTRAINT "employs"
    FOREIGN KEY ("PK_School")
    REFERENCES "School" ("PK_School")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "School_Employee"
  ADD CONSTRAINT "works_for"
    FOREIGN KEY ("PK_Employee")
    REFERENCES "Employee" ("PK_Employee")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "Employee_Subject_Competence"
  ADD CONSTRAINT "teaches"
    FOREIGN KEY ("PK_Subject")
    REFERENCES "Subject" ("PK_Subject")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "Employee_Subject_Competence"
  ADD CONSTRAINT "taught_by"
    FOREIGN KEY ("PK_Employee")
    REFERENCES "Employee" ("PK_Employee")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "School_Program_Implementation"
  ADD CONSTRAINT "implements"
    FOREIGN KEY ("PK_School")
    REFERENCES "School" ("PK_School")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;

ALTER TABLE "School_Program_Implementation"
  ADD CONSTRAINT "implemented_by"
    FOREIGN KEY ("PK_Education_Program")
    REFERENCES "Education_Program" ("PK_Education_Program")
      ON DELETE CASCADE
      ON UPDATE RESTRICT
;


