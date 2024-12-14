CREATE DATABASE Crime_Case;

\c Crime_Case;

---
--- Name: person; type: Table; Schema: public; Owner: Postgres
---

CREATE TABLE public.Person (
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    id integer NOT NULL,
    phone_number character varying(10) NOT NULL,
    postal_code integer NOT NULL,
    street_address character varying(50) NOT NULL,
    city character varying(50) NOT NULL,
    country character varying(50) NOT NULL,
    
    PRIMARY KEY (id)
);

ALTER TABLE public.Person OWNER TO Postgres;

---
--- Name: Suspect; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
---

CREATE TABLE public.Suspect (
    DNA_sequence character varying(50) NOT NULL,
    eye_color character varying(50) NOT NULL,
    hair_color character varying(50) NOT NULL,
    height integer NOT NULL,
    person_id integer NOT NULL,  -- Added a foreign key reference to Person
    FOREIGN KEY (person_id) REFERENCES public.Person(id) ON DELETE CASCADE
);

ALTER TABLE public.Suspect OWNER TO Postgres;

CREATE TABLE public.Evidence (
    evidence_description character varying(50) NOT NULL,
    storage_id integer NOT NULL,
    classification_tag character varying(50) NOT NULL,
    crime_id integer NOT NULL,
    investigator_id integer NOT NULL,
    
    FOREIGN KEY (investigator_id) REFERENCES public.Person(id) ON DELETE CASCADE,
    FOREIGN KEY (crime_id) REFERENCES public.CrimeCase(id) ON DELETE CASCADE
);

ALTER TABLE public.Evidence OWNER TO Postgres;

CREATE TABLE public.Interrogations (
    time datetime NOT NULL,
    suspect_id integer NOT NULL,  -- Added suspect_id to reference Suspect
    FOREIGN KEY (suspect_id) REFERENCES public.Suspect(person_id) ON DELETE CASCADE
);

ALTER TABLE public.Interrogations OWNER TO Postgres;

CREATE TABLE public.CrimeCase (
    id integer NOT NULL,
    case_type character varying(255) NOT NULL,
    case_status character varying(255) NOT NULL,
    date_time datetime NOT NULL,
    case_state character varying(255) NOT NULL,
    case_city character varying(255) NOT NULL,

    PRIMARY KEY (id)
);

CREATE TABLE Investigator (
    department character varying(255) NOT NULL,
    rank character varying(255) NOT NULL,
    investigator_id integer NOT NULL,

    PRIMARY KEY (investigator_id),
    FOREIGN KEY (investigator_id) REFERENCES public.Person(id) ON DELETE CASCADE
);
