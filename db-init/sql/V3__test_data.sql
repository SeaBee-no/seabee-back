-- 91b446a8-30b7-47fa-828c-e5bcdfde07ec represents a random user

INSERT into drones (attributes, modified_by) VALUES ('{}', '91b446a8-30b7-47fa-828c-e5bcdfde07ec');
INSERT into cameras (attributes, modified_by) VALUES ('{}', '91b446a8-30b7-47fa-828c-e5bcdfde07ec');
INSERT into calibrations (camera_id, calibration, created_by) VALUES (1, '{}', '91b446a8-30b7-47fa-828c-e5bcdfde07ec');
INSERT into mission_equipment (drone_id, camera_id, attributes, calibration_id) VALUES (1, 1, '{}', 1);

INSERT into orders (owner, ordered_by) VALUES ('91b446a8-30b7-47fa-828c-e5bcdfde07ec', '91b446a8-30b7-47fa-828c-e5bcdfde07ec');
INSERT into missions (order_id, equipment_id, started_by) VALUES (1, 1, '91b446a8-30b7-47fa-828c-e5bcdfde07ec');
