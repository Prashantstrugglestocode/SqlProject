-- Create the Crime_Case database
CREATE DATABASE Crime_Case;

-- Switch to the created database
\c Crime_Case;

-- Create the Address Type (Composite Type)
CREATE TYPE public.address_type AS (
    street character varying(255),
    city character varying(255),
    zip integer
);

-- Create the Name Type (Composite Type)
CREATE TYPE public.name_type AS (
    first_name character varying(255),
    last_name character varying(255)
);

-- Create the Person Table (Superclass for storing common attributes)
CREATE TABLE public.person (
    id character varying(50) PRIMARY KEY, -- Unique identifier for a person
    first_name character varying(50) NOT NULL, -- First name
    last_name character varying(50) NOT NULL, -- Last name
    phone_number character varying(50), -- Phone number
    street character varying(100), -- Street address
    city character varying(100), -- City
    zip character varying(10), -- ZIP code
    role character varying(50), -- role
    rank character varying(50), -- Rank (if applicable)
    department character varying(100), -- Department (if applicable) 
    cases_solved integer DEFAULT 0, -- Number of cases solved
    height integer, -- Height of the person
    hair_color character varying(50), -- Hair color
    eye_color character varying(50), -- Eye color
    dna character varying(64) -- DNA identifier
);

ALTER TABLE public.person OWNER TO postgres;

-- Create the CrimeCase Table (Represents a crime case)
CREATE TABLE public.crimes (
    id character varying(50) PRIMARY KEY, -- Unique identifier for each case
    case_type character varying(255) NOT NULL, -- Type of the crime (e.g., theft, murder)
    date_time timestamp NOT NULL, -- Date and time when the case was reported
    status character varying(255) NOT NULL, -- Status of the case (e.g., open, closed)
    place character varying(255) NOT NULL, -- Location of the crime
    lead_investigator_id character varying(50) NOT NULL, -- Reference to the lead investigator
    FOREIGN KEY (lead_investigator_id) REFERENCES public.person(id) ON DELETE CASCADE, -- Link to the person table
    CONSTRAINT crimes_status_check CHECK (status IN ('open', 'closed')) -- Restriction on valid case statuses
);

ALTER TABLE public.crimes OWNER TO postgres;

-- Create the Investigator Table (Subclass of Person)
CREATE TABLE public.investigator (
    investigator_id character varying(50) PRIMARY KEY, -- Unique identifier for investigator
    department character varying(255) NOT NULL, -- Investigator's department
    rank character varying(255) NOT NULL, -- Investigator's rank
    person_id character varying(50) NOT NULL, -- Foreign key referring to the person table
    FOREIGN KEY (person_id) REFERENCES public.person(id) ON DELETE CASCADE -- Link to the person table
);

ALTER TABLE public.investigator OWNER TO postgres;

-- Create the Evidence_Suspect Table (Links evidence to suspects)
CREATE TABLE public.evidence_suspect (
    crime_id character varying(50) NOT NULL, -- Foreign key referring to the crime
    storage_id integer NOT NULL, -- Storage identifier for the evidence
    suspect_id character varying(50) NOT NULL, -- Foreign key referring to the suspect
    FOREIGN KEY (crime_id) REFERENCES public.crimes(id) ON DELETE CASCADE, -- Link to crimes table
    FOREIGN KEY (suspect_id) REFERENCES public.person(id) ON DELETE CASCADE -- Link to person table
);

ALTER TABLE public.evidence_suspect OWNER TO postgres;

-- Create the Evidences Table (Stores evidence details)
CREATE TABLE public.evidences (
    crime_id character varying(50) NOT NULL,  -- Reference to the related crime
    investigator_id character varying(50), -- Reference to the investigator handling the evidence
    storage_id integer NOT NULL, -- Storage identifier for the evidence
    tag character varying(50), -- Evidence classification (e.g., DNA, fingerprint)
    evidence_description text NOT NULL, -- Description of the evidence
    FOREIGN KEY (investigator_id) REFERENCES public.investigator(investigator_id) ON DELETE CASCADE, -- Link to investigator table
    FOREIGN KEY (crime_id) REFERENCES public.crimes(id) ON DELETE CASCADE -- Link to crime table
);

ALTER TABLE public.evidences OWNER TO postgres;

-- Create the Interrogations Table (Records interrogations of suspects)
CREATE TABLE public.interrogations (
    crime_id character varying(50) NOT NULL, -- Foreign key to crime table
    investigator_id character varying(50) NOT NULL, -- Foreign key to investigator table
    suspect_id character varying(50) NOT NULL, -- Foreign key to person (suspect)
    date DATE NOT NULL, -- Date of the interrogation
    hours INTEGER NOT NULL, -- Hours of interrogation
    minutes INTEGER NOT NULL, -- Minutes of interrogation
    FOREIGN KEY (investigator_id) REFERENCES public.investigator(investigator_id) ON DELETE CASCADE, -- Link to investigator table
    FOREIGN KEY (crime_id) REFERENCES public.crimes(id) ON DELETE CASCADE, -- Link to crime table
    FOREIGN KEY (suspect_id) REFERENCES public.person(id) ON DELETE CASCADE, -- Link to suspect (person)
    CONSTRAINT interrogations_hours_check CHECK (hours >= 0 AND hours < 24), -- Validation for valid hours
    CONSTRAINT interrogations_minutes_check CHECK (minutes >= 0 AND minutes < 60) -- Validation for valid minutes
);

ALTER TABLE public.interrogations OWNER TO postgres;

-- Create the Suspect_Crimes Table (Links suspects to their crimes)
CREATE TABLE public.suspect_crimes (
    crime_id character varying(50) NOT NULL, -- Unique identifier for the crime
    suspect_id character varying(50) NOT NULL, -- Unique identifier for the suspect
    status character varying(10) NOT NULL, -- Status of the suspect in relation to the crime
    FOREIGN KEY (crime_id) REFERENCES public.crimes(id) ON DELETE CASCADE, -- Link to crimes table
    FOREIGN KEY (suspect_id) REFERENCES public.person(id) ON DELETE CASCADE, -- Link to person table
    CONSTRAINT suspect_crimes_status_check CHECK (status IN ('active', 'inactive')) -- Status validation
);

ALTER TABLE public.suspect_crimes OWNER TO postgres;

-- Create the Works_On Table (Links investigators to cases they work on)
CREATE TABLE public.works_on (
    crime_id character varying(50) NOT NULL, -- Reference to the crime
    investigator_id character varying(50) NOT NULL, -- Reference to the investigator
    start_date DATE NOT NULL, -- Start date of the investigator's involvement in the case
    end_date DATE, -- End date of the investigator's involvement (can be null if still working)
    FOREIGN KEY (crime_id) REFERENCES public.crimes(id) ON DELETE CASCADE, -- Link to crimes table
    FOREIGN KEY (investigator_id) REFERENCES public.investigator(investigator_id) ON DELETE CASCADE -- Link to investigator table
);

ALTER TABLE public.works_on OWNER TO postgres;
