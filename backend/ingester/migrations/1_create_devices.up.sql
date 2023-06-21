CREATE TABLE devices (
    id serial NOT NULL PRIMARY KEY,
    name varchar NOT NULL,
    description varchar NOT NULL,
    location varchar NOT NULL,
    authtoken char(120) NOT NULL
);
