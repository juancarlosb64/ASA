CREATE TABLE IF NOT EXISTS location (
	country varchar(2) NOT NULL,
	city varchar(100) NOT NULL,
	active bool NOT NULL,
	PRIMARY KEY (country, city)
) ENGINE=innodb;

INSERT INTO location (country, city, active) VALUES ('PR', 'Guayama', false);
INSERT INTO location (country, city, active) values ('AF', 'Kabul', false);
INSERT INTO location (country, city, active) values ('ZA', 'Pretoria', false);
INSERT INTO location (country, city, active) values ('AL', 'Tirana', false);
INSERT INTO location (country, city, active) values ('DE', 'Berlin', false);
INSERT INTO location (country, city, active) values ('AD', 'Andorra', false);
INSERT INTO location (country, city, active) values ('AO', 'Luanda', false);
INSERT INTO location (country, city, active) values ('AG', 'San Juan', false);
INSERT INTO location (country, city, active) values ('SA', 'Riad', false);
INSERT INTO location (country, city, active) values ('DZ', 'Argel', false);
INSERT INTO location (country, city, active) values ('AR', 'Buenos Aires', false);
INSERT INTO location (country, city, active) values ('AM', 'Ereva', false);
INSERT INTO location (country, city, active) values ('AU', 'Canberra', false);
INSERT INTO location (country, city, active) values ('AT', 'Viena', false);
INSERT INTO location (country, city, active) values ('AZ', 'Baku', false);
INSERT INTO location (country, city, active) values ('BS', 'Nassau', false);
INSERT INTO location (country, city, active) values ('BD', 'Dhaka', false);
INSERT INTO location (country, city, active) values ('BB', 'Bridgetown', false);
INSERT INTO location (country, city, active) values ('BH', 'Manama', false);
INSERT INTO location (country, city, active) values ('BE', 'Bruselas', false);
INSERT INTO location (country, city, active) values ('BZ', 'Belmopa', false);
INSERT INTO location (country, city, active) values ('BJ', 'Porto Novo', false);
INSERT INTO location (country, city, active) values ('BY', 'Minsque', false);
INSERT INTO location (country, city, active) values ('BO', 'Sucre', false);
INSERT INTO location (country, city, active) values ('BA', 'Sarajevo', false);
INSERT INTO location (country, city, active) values ('BW', 'Gaborone', false);
INSERT INTO location (country, city, active) values ('BR', 'Brasilia', false);
INSERT INTO location (country, city, active) values ('BN', 'Bandar Seri Begaua', false);
INSERT INTO location (country, city, active) values ('BG', 'Sofia', false);
INSERT INTO location (country, city, active) values ('BF', 'Uagadugu', false);
INSERT INTO location (country, city, active) values ('BI', 'Bujumbura', false);
INSERT INTO location (country, city, active) values ('BT', 'Timbu', false);
INSERT INTO location (country, city, active) values ('CV', 'Playa', false);
INSERT INTO location (country, city, active) values ('CM', 'Yaunde', false);
INSERT INTO location (country, city, active) values ('KH', 'Pene Pene', false);
INSERT INTO location (country, city, active) values ('CA', 'Ottawa', false);
INSERT INTO location (country, city, active) values ('QA', 'Donar', false);
INSERT INTO location (country, city, active) values ('KZ', 'Astana', false);
INSERT INTO location (country, city, active) values ('TD', 'Jamena', false);
INSERT INTO location (country, city, active) values ('CL', 'Santiago', false);
INSERT INTO location (country, city, active) values ('CN', 'Beijing', false);
INSERT INTO location (country, city, active) values ('CY', 'Nicosia', false);
INSERT INTO location (country, city, active) values ('CO', 'Bogota', false);
INSERT INTO location (country, city, active) values ('KM', 'Moroni', false);
INSERT INTO location (country, city, active) values ('CG', 'Brazavile', false);
INSERT INTO location (country, city, active) values ('KP', 'Pionguiangue', false);
INSERT INTO location (country, city, active) values ('KR', 'Seul', false);
INSERT INTO location (country, city, active) values ('CI', 'Yamussucro', false);
INSERT INTO location (country, city, active) values ('CR', 'San Jose', false);
INSERT INTO location (country, city, active) values ('HR', 'Zagreb', false);
INSERT INTO location (country, city, active) values ('KW', 'Ciudad De Cuaite', false);
INSERT INTO location (country, city, active) values ('CU', 'La Habana', false);
INSERT INTO location (country, city, active) values ('DK', 'Copenhague', false);
INSERT INTO location (country, city, active) values ('DM', 'Roseau', false);
INSERT INTO location (country, city, active) values ('EG', 'El Cairo', false);
INSERT INTO location (country, city, active) values ('AE', 'Abu Dhabi', false);
INSERT INTO location (country, city, active) values ('EC', 'Quito', false);
INSERT INTO location (country, city, active) values ('ER', 'Asmara', false);
INSERT INTO location (country, city, active) values ('SK', 'Bratislava', false);
INSERT INTO location (country, city, active) values ('SI', 'Liubliana', false);
INSERT INTO location (country, city, active) values ('ES', 'Madrid', false);
INSERT INTO location (country, city, active) values ('PS', 'Jerusalen Este', false);
INSERT INTO location (country, city, active) values ('US', 'Washington Dc', false);
INSERT INTO location (country, city, active) values ('EE', 'Talim', false);
INSERT INTO location (country, city, active) values ('ET', 'Addis Ababa', false);
INSERT INTO location (country, city, active) values ('FJ', 'Suva', false);
INSERT INTO location (country, city, active) values ('PH', 'Manila', false);
INSERT INTO location (country, city, active) values ('FI', 'Helsinki', false);
INSERT INTO location (country, city, active) values ('FR', 'Paris', false);
INSERT INTO location (country, city, active) values ('GA', 'Libreville', false);
INSERT INTO location (country, city, active) values ('GM', 'Banjul', false);
INSERT INTO location (country, city, active) values ('GH', 'Accra', false);
INSERT INTO location (country, city, active) values ('GE', 'Tebilissi', false);
INSERT INTO location (country, city, active) values ('GD', 'San Jorge', false);
INSERT INTO location (country, city, active) values ('GR', 'Atenas', false);
INSERT INTO location (country, city, active) values ('GT', 'Ciudad De Guatemala', false);
INSERT INTO location (country, city, active) values ('GY', 'Georgetown', false);
INSERT INTO location (country, city, active) values ('GN', 'Conakry', false);
INSERT INTO location (country, city, active) values ('GQ', 'Malabo', false);
INSERT INTO location (country, city, active) values ('GW', 'Bissau', false);
INSERT INTO location (country, city, active) values ('HT', 'Porto Principe', false);
INSERT INTO location (country, city, active) values ('HN', 'Tegucigalpa', false);
INSERT INTO location (country, city, active) values ('HU', 'Budapest', false);
INSERT INTO location (country, city, active) values ('YE', 'Sana', false);
INSERT INTO location (country, city, active) values ('MH', 'Majuro', false);
INSERT INTO location (country, city, active) values ('IN', 'Nueva Delhi', false);
INSERT INTO location (country, city, active) values ('ID', 'Jakarta', false);
INSERT INTO location (country, city, active) values ('IR', 'Teerao', false);
INSERT INTO location (country, city, active) values ('IQ', 'Bagdad', false);
INSERT INTO location (country, city, active) values ('IE', 'Dublin', false);
INSERT INTO location (country, city, active) values ('IS', 'Reykjavik', false);
INSERT INTO location (country, city, active) values ('IL', 'Jerusalen', false);
INSERT INTO location (country, city, active) values ('IT', 'Roma', false);
INSERT INTO location (country, city, active) values ('JM', 'Kingston', false);
INSERT INTO location (country, city, active) values ('JP', 'Toyo', false);
INSERT INTO location (country, city, active) values ('DJ', 'Djibouti', false);
INSERT INTO location (country, city, active) values ('JO', 'Ama', false);
INSERT INTO location (country, city, active) values ('LA', 'Vientiane', false);
INSERT INTO location (country, city, active) values ('LS', 'Maseru', false);
INSERT INTO location (country, city, active) values ('LV', 'Riga', false);
INSERT INTO location (country, city, active) values ('LB', 'Beirut', false);
INSERT INTO location (country, city, active) values ('LR', 'Monrovia', false);
INSERT INTO location (country, city, active) values ('LY', 'Tripoli', false);
INSERT INTO location (country, city, active) values ('LI', 'Vaduz', false);
INSERT INTO location (country, city, active) values ('LT', 'Vilna', false);
INSERT INTO location (country, city, active) values ('LU', 'Luxemburgo', false);
INSERT INTO location (country, city, active) values ('MK', 'Scopy', false);
INSERT INTO location (country, city, active) values ('MG', 'Antananarivo', false);
INSERT INTO location (country, city, active) values ('MY', 'Kuala Lumpur', false);
INSERT INTO location (country, city, active) values ('MW', 'Lilong', false);
INSERT INTO location (country, city, active) values ('MV', 'Hombre', false);
INSERT INTO location (country, city, active) values ('ML', 'Bamako', false);
INSERT INTO location (country, city, active) values ('MT', 'Valletta', false);
INSERT INTO location (country, city, active) values ('MA', 'Descuento', false);
INSERT INTO location (country, city, active) values ('MU', 'Porto Luis', false);
INSERT INTO location (country, city, active) values ('MR', 'Puta', false);
INSERT INTO location (country, city, active) values ('MX', 'Ciudad De Mexico', false);
INSERT INTO location (country, city, active) values ('MM', 'Nepiedo', false);
INSERT INTO location (country, city, active) values ('FM', 'Paliquir', false);
INSERT INTO location (country, city, active) values ('MZ', 'Maputo', false);
INSERT INTO location (country, city, active) values ('MD', 'Quixinau', false);
INSERT INTO location (country, city, active) values ('MC', 'Monaco', false);
INSERT INTO location (country, city, active) values ('MN', 'Ula Bator', false);
INSERT INTO location (country, city, active) values ('ME', 'Podgoritsa', false);
INSERT INTO location (country, city, active) values ('NA', 'Vinduk', false);
INSERT INTO location (country, city, active) values ('NR', 'Iria', false);
INSERT INTO location (country, city, active) values ('NP', 'Katmandu', false);
INSERT INTO location (country, city, active) values ('NI', 'Managua', false);
INSERT INTO location (country, city, active) VALUES ('NI', 'Leon', false);
INSERT INTO location (country, city, active) values ('NE', 'Niamey', false);
INSERT INTO location (country, city, active) values ('NG', 'Abuja', false);
INSERT INTO location (country, city, active) values ('NO', 'Oslo', false);
INSERT INTO location (country, city, active) values ('NZ', 'Wellington', false);
INSERT INTO location (country, city, active) values ('OM', 'Muscat', false);
INSERT INTO location (country, city, active) values ('NL', 'Amsterdam', false);
INSERT INTO location (country, city, active) values ('PW', 'Ngerulmud', false);
INSERT INTO location (country, city, active) values ('PA', 'Ciudad De Panama', false);
INSERT INTO location (country, city, active) values ('PG', 'Puerto De Moresby', false);
INSERT INTO location (country, city, active) values ('PK', 'Islamabad', false);
INSERT INTO location (country, city, active) values ('PY', 'Asuncion', false);
INSERT INTO location (country, city, active) values ('PE', 'Lima', false);
INSERT INTO location (country, city, active) values ('PL', 'Varsovia', false);
INSERT INTO location (country, city, active) values ('PT', 'Lisboa', false);
INSERT INTO location (country, city, active) values ('KE', 'Nairobi', false);
INSERT INTO location (country, city, active) values ('KG', 'Bisque', false);
INSERT INTO location (country, city, active) values ('KI', 'Taraua Meridional', false);
INSERT INTO location (country, city, active) values ('GB', 'Londres', false);
INSERT INTO location (country, city, active) values ('CF', 'Bangui', false);
INSERT INTO location (country, city, active) values ('CZ', 'Praga', false);
INSERT INTO location (country, city, active) values ('CD', 'Kinshasa', false);
INSERT INTO location (country, city, active) values ('DO', 'San Domingos', false);
INSERT INTO location (country, city, active) values ('RO', 'Bucarest', false);
INSERT INTO location (country, city, active) values ('RW', 'Kigali', false);
INSERT INTO location (country, city, active) values ('RU', 'Moscu', false);
INSERT INTO location (country, city, active) values ('SB', 'Honiara', false);
INSERT INTO location (country, city, active) values ('SV', 'San Salvador', false);
INSERT INTO location (country, city, active) values ('WS', 'Apia', false);
INSERT INTO location (country, city, active) values ('LC', 'Castries', false);
INSERT INTO location (country, city, active) values ('KN', 'Basseterre', false);
INSERT INTO location (country, city, active) values ('SM', 'San Marino', false);
INSERT INTO location (country, city, active) values ('ST', 'San Tome', false);
INSERT INTO location (country, city, active) values ('VC', 'Kingstown', false);
INSERT INTO location (country, city, active) values ('SC', 'Victoria', false);
INSERT INTO location (country, city, active) values ('SN', 'Dakar', false);
INSERT INTO location (country, city, active) values ('SL', 'Freetown', false);
INSERT INTO location (country, city, active) values ('RS', 'Belgrado', false);
INSERT INTO location (country, city, active) values ('SG', 'Singapur', false);
INSERT INTO location (country, city, active) values ('SY', 'Albaricoque', false);
INSERT INTO location (country, city, active) values ('SO', 'Mogadiscio', false);
INSERT INTO location (country, city, active) values ('LK', 'Sri Jaiavardenapura-Cota', false);
INSERT INTO location (country, city, active) values ('SZ', 'Lobamba', false);
INSERT INTO location (country, city, active) values ('SD', 'Caricatura', false);
INSERT INTO location (country, city, active) values ('SS', 'Mane', false);
INSERT INTO location (country, city, active) values ('SE', 'Estocolmo', false);
INSERT INTO location (country, city, active) values ('CH', 'Berna', false);
INSERT INTO location (country, city, active) values ('SR', 'Paramaribo', false);
INSERT INTO location (country, city, active) values ('TH', 'Bangkok', false);
INSERT INTO location (country, city, active) values ('TW', 'Taipe', false);
INSERT INTO location (country, city, active) values ('TJ', 'Ducha', false);
INSERT INTO location (country, city, active) values ('TZ', 'Dodoma', false);
INSERT INTO location (country, city, active) values ('TL', 'Dili', false);
INSERT INTO location (country, city, active) values ('TG', 'Lome', false);
INSERT INTO location (country, city, active) values ('TO', 'Nucualofa', false);
INSERT INTO location (country, city, active) values ('TT', 'Puerto De España', false);
INSERT INTO location (country, city, active) values ('TN', 'Melodias', false);
INSERT INTO location (country, city, active) values ('TM', 'Ashgabat', false);
INSERT INTO location (country, city, active) values ('TR', 'Ankara', false);
INSERT INTO location (country, city, active) values ('TV', 'Funafuti', false);
INSERT INTO location (country, city, active) values ('UA', 'Quieve', false);
INSERT INTO location (country, city, active) values ('UG', 'Kampala', false);
INSERT INTO location (country, city, active) values ('UY', 'Montevideo', false);
INSERT INTO location (country, city, active) values ('UZ', 'Tasquente', false);
INSERT INTO location (country, city, active) values ('VU', 'Porto Vila', false);
INSERT INTO location (country, city, active) values ('VA', 'Vaticano', false);
INSERT INTO location (country, city, active) values ('VE', 'Caracas', false);
INSERT INTO location (country, city, active) values ('VN', 'Hanoi', false);
INSERT INTO location (country, city, active) values ('ZM', 'Lusaka', false);
INSERT INTO location (country, city, active) values ('ZW', 'Harare', false);
