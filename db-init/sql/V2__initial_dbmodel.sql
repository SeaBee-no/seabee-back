create table if not exists drones (
	drone_id serial  NOT NULL primary key,
	attributes json  NOT NULL,
	modified_by uuid  NOT NULL,
    modified_at timestamptz  NOT NULL DEFAULT now()
);

create table if not exists cameras (
	camera_id serial  NOT NULL primary key,
	attributes json  NOT NULL,
	modified_by uuid  NOT NULL,
    modified_at timestamptz  NOT NULL DEFAULT now()
);

create table if not exists calibrations (
	calibration_id serial  NOT NULL primary key,
	camera_id integer REFERENCES cameras (camera_id) NOT NULL,
	calibration json  NOT NULL,
	created_by uuid  NOT NULL,
    created_at timestamptz  NOT NULL DEFAULT now()
);

create table if not exists mission_equipment (
	mission_equipment_id serial  NOT NULL primary key,
	drone_id integer REFERENCES drones (drone_id) NOT NULL,
	camera_id integer REFERENCES cameras (camera_id) NOT NULL,
	attributes json  NOT NULL,
	calibration_id integer REFERENCES calibrations (calibration_id) NOT NULL
);

create table if not exists orders (
	order_id serial  NOT NULL primary key,
	owner uuid  NOT NULL,
	ordered_by uuid  NOT NULL,
    ordered_at timestamptz  NOT NULL DEFAULT now()
);

create table if not exists missions (
	mission_id serial  NOT NULL primary key,
	order_id integer REFERENCES orders (order_id),
	equipment_id integer REFERENCES mission_equipment (mission_equipment_id) NOT NULL,
	started_by uuid  NOT NULL,
    started_at timestamptz  NOT NULL DEFAULT now(),
    completed_at timestamptz
);

create table if not exists images (
	image_id serial  NOT NULL primary key,
	mission_id integer REFERENCES missions (mission_id) NOT NULL,
	external_path TEXT  NOT NULL,
	uploaded BOOLEAN DEFAULT FALSE

);

create table if not exists mosaics (
	mosaic_id serial  NOT NULL primary key,
	mission_id integer REFERENCES missions (mission_id) NOT NULL,
	external_path TEXT  NOT NULL,
	uploaded BOOLEAN DEFAULT FALSE
);

CREATE TYPE classification_type AS ENUM ('unknown', 'sand');

create table if not exists classifications (
	classification_id serial  NOT NULL primary key,
	label classification_type  NOT NULL,
	field uuid  NOT NULL
);

-- create table if not exists annotations (
-- 	annotation_id serial  NOT NULL primary key,
-- 	owner uuid  NOT NULL,
-- 	ordered_by uuid  NOT NULL,
--     ordered_at timestamptz  NOT NULL
-- );
--
-- create table if not exists mosaics (
-- 	mosaic_id serial  NOT NULL primary key,
-- 	owner uuid  NOT NULL,
-- 	ordered_by uuid  NOT NULL,
--     ordered_at timestamptz  NOT NULL
-- );
