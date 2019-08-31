CREATE TABLE IF NOT EXISTS location (
	country varchar(2) NOT NULL,
	city varchar(100) NOT NULL,
	active bool NOT NULL,
	PRIMARY KEY (country, city)
) ENGINE=innodb;

CREATE TABLE IF NOT EXISTS product (
	sku varchar(10),
	description varchar(100) NOT NULL,
	base_price decimal(10, 2) NOT NULL,
	PRIMARY KEY(sku)
) ENGINE=innodb;

CREATE TABLE IF NOT EXISTS rules (
	idrule integer auto_increment,
	country varchar(2) NOT NULL,
	city varchar(100) NOT NULL,
	sku varchar(10) NOT NULL,
	min_condition integer NOT NULL,
	max_condition integer NOT NULL,
	variation decimal(10, 2) NOT NULL,
	PRIMARY KEY(idrule), 
	INDEX(country), 
	INDEX(city),
	FOREIGN KEY(sku) REFERENCES product (sku),
	FOREIGN KEY(country, city) REFERENCES location (country, city)
) ENGINE=innodb;

INSERT INTO product (sku, description, base_price) VALUES ('AZ00001', 'Paraguas de señora estampado', 10);
INSERT INTO product (sku, description, base_price) VALUES ('AZ00002', 'Helado de sabor fresa', 1);

INSERT INTO location (country, city, active) VALUES ('PR', 'Guayama', false);
INSERT INTO location (country, city, active) VALUES ('AF', 'Kabul', false);
INSERT INTO location (country, city, active) VALUES ('ZA', 'Pretoria', false);
INSERT INTO location (country, city, active) VALUES ('AL', 'Tirana', false);
INSERT INTO location (country, city, active) VALUES ('DE', 'Berlin', false);
INSERT INTO location (country, city, active) VALUES ('AD', 'Andorra', false);
INSERT INTO location (country, city, active) VALUES ('AO', 'Luanda', false);
INSERT INTO location (country, city, active) VALUES ('AG', 'San Juan', false);
INSERT INTO location (country, city, active) VALUES ('SA', 'Riad', false);
INSERT INTO location (country, city, active) VALUES ('DZ', 'Argel', false);
INSERT INTO location (country, city, active) VALUES ('AR', 'Buenos Aires', false);
INSERT INTO location (country, city, active) VALUES ('AM', 'Ereva', false);
INSERT INTO location (country, city, active) VALUES ('AU', 'Canberra', false);
INSERT INTO location (country, city, active) VALUES ('AT', 'Viena', false);
INSERT INTO location (country, city, active) VALUES ('AZ', 'Baku', false);
INSERT INTO location (country, city, active) VALUES ('BS', 'Nassau', false);
INSERT INTO location (country, city, active) VALUES ('BD', 'Dhaka', false);
INSERT INTO location (country, city, active) VALUES ('BB', 'Bridgetown', false);
INSERT INTO location (country, city, active) VALUES ('BH', 'Manama', false);
INSERT INTO location (country, city, active) VALUES ('BE', 'Bruselas', false);
INSERT INTO location (country, city, active) VALUES ('BZ', 'Belmopa', false);
INSERT INTO location (country, city, active) VALUES ('BJ', 'Porto Novo', false);
INSERT INTO location (country, city, active) VALUES ('BY', 'Minsque', false);
INSERT INTO location (country, city, active) VALUES ('BO', 'Sucre', false);
INSERT INTO location (country, city, active) VALUES ('BA', 'Sarajevo', false);
INSERT INTO location (country, city, active) VALUES ('BW', 'Gaborone', false);
INSERT INTO location (country, city, active) VALUES ('BR', 'Brasilia', false);
INSERT INTO location (country, city, active) VALUES ('BN', 'Bandar Seri Begaua', false);
INSERT INTO location (country, city, active) VALUES ('BG', 'Sofia', false);
INSERT INTO location (country, city, active) VALUES ('BF', 'Uagadugu', false);
INSERT INTO location (country, city, active) VALUES ('BI', 'Bujumbura', false);
INSERT INTO location (country, city, active) VALUES ('BT', 'Timbu', false);
INSERT INTO location (country, city, active) VALUES ('CV', 'Playa', false);
INSERT INTO location (country, city, active) VALUES ('CM', 'Yaunde', false);
INSERT INTO location (country, city, active) VALUES ('KH', 'Pene Pene', false);
INSERT INTO location (country, city, active) VALUES ('CA', 'Ottawa', false);
INSERT INTO location (country, city, active) VALUES ('QA', 'Donar', false);
INSERT INTO location (country, city, active) VALUES ('KZ', 'Astana', false);
INSERT INTO location (country, city, active) VALUES ('TD', 'Jamena', false);
INSERT INTO location (country, city, active) VALUES ('CL', 'Santiago', false);
INSERT INTO location (country, city, active) VALUES ('CN', 'Beijing', false);
INSERT INTO location (country, city, active) VALUES ('CY', 'Nicosia', false);
INSERT INTO location (country, city, active) VALUES ('CO', 'Bogota', false);
INSERT INTO location (country, city, active) VALUES ('KM', 'Moroni', false);
INSERT INTO location (country, city, active) VALUES ('CG', 'Brazavile', false);
INSERT INTO location (country, city, active) VALUES ('KP', 'Pionguiangue', false);
INSERT INTO location (country, city, active) VALUES ('KR', 'Seul', false);
INSERT INTO location (country, city, active) VALUES ('CI', 'Yamussucro', false);
INSERT INTO location (country, city, active) VALUES ('CR', 'San Jose', false);
INSERT INTO location (country, city, active) VALUES ('HR', 'Zagreb', false);
INSERT INTO location (country, city, active) VALUES ('KW', 'Ciudad De Cuaite', false);
INSERT INTO location (country, city, active) VALUES ('CU', 'La Habana', false);
INSERT INTO location (country, city, active) VALUES ('DK', 'Copenhague', false);
INSERT INTO location (country, city, active) VALUES ('DM', 'Roseau', false);
INSERT INTO location (country, city, active) VALUES ('EG', 'El Cairo', false);
INSERT INTO location (country, city, active) VALUES ('AE', 'Abu Dhabi', false);
INSERT INTO location (country, city, active) VALUES ('EC', 'Quito', false);
INSERT INTO location (country, city, active) VALUES ('ER', 'Asmara', false);
INSERT INTO location (country, city, active) VALUES ('SK', 'Bratislava', false);
INSERT INTO location (country, city, active) VALUES ('SI', 'Liubliana', false);
INSERT INTO location (country, city, active) VALUES ('ES', 'Madrid', false);
INSERT INTO location (country, city, active) VALUES ('PS', 'Jerusalen Este', false);
INSERT INTO location (country, city, active) VALUES ('US', 'Washington Dc', false);
INSERT INTO location (country, city, active) VALUES ('EE', 'Talim', false);
INSERT INTO location (country, city, active) VALUES ('ET', 'Addis Ababa', false);
INSERT INTO location (country, city, active) VALUES ('FJ', 'Suva', false);
INSERT INTO location (country, city, active) VALUES ('PH', 'Manila', false);
INSERT INTO location (country, city, active) VALUES ('FI', 'Helsinki', false);
INSERT INTO location (country, city, active) VALUES ('FR', 'Paris', false);
INSERT INTO location (country, city, active) VALUES ('GA', 'Libreville', false);
INSERT INTO location (country, city, active) VALUES ('GM', 'Banjul', false);
INSERT INTO location (country, city, active) VALUES ('GH', 'Accra', false);
INSERT INTO location (country, city, active) VALUES ('GE', 'Tebilissi', false);
INSERT INTO location (country, city, active) VALUES ('GD', 'San Jorge', false);
INSERT INTO location (country, city, active) VALUES ('GR', 'Atenas', false);
INSERT INTO location (country, city, active) VALUES ('GT', 'Ciudad De Guatemala', false);
INSERT INTO location (country, city, active) VALUES ('GY', 'Georgetown', false);
INSERT INTO location (country, city, active) VALUES ('GN', 'Conakry', false);
INSERT INTO location (country, city, active) VALUES ('GQ', 'Malabo', false);
INSERT INTO location (country, city, active) VALUES ('GW', 'Bissau', false);
INSERT INTO location (country, city, active) VALUES ('HT', 'Porto Principe', false);
INSERT INTO location (country, city, active) VALUES ('HN', 'Tegucigalpa', false);
INSERT INTO location (country, city, active) VALUES ('HU', 'Budapest', false);
INSERT INTO location (country, city, active) VALUES ('YE', 'Sana', false);
INSERT INTO location (country, city, active) VALUES ('MH', 'Majuro', false);
INSERT INTO location (country, city, active) VALUES ('IN', 'Nueva Delhi', false);
INSERT INTO location (country, city, active) VALUES ('ID', 'Jakarta', false);
INSERT INTO location (country, city, active) VALUES ('IR', 'Teerao', false);
INSERT INTO location (country, city, active) VALUES ('IQ', 'Bagdad', false);
INSERT INTO location (country, city, active) VALUES ('IE', 'Dublin', false);
INSERT INTO location (country, city, active) VALUES ('IS', 'Reykjavik', false);
INSERT INTO location (country, city, active) VALUES ('IL', 'Jerusalen', false);
INSERT INTO location (country, city, active) VALUES ('IT', 'Roma', false);
INSERT INTO location (country, city, active) VALUES ('JM', 'Kingston', false);
INSERT INTO location (country, city, active) VALUES ('JP', 'Toyo', false);
INSERT INTO location (country, city, active) VALUES ('DJ', 'Djibouti', false);
INSERT INTO location (country, city, active) VALUES ('JO', 'Ama', false);
INSERT INTO location (country, city, active) VALUES ('LA', 'Vientiane', false);
INSERT INTO location (country, city, active) VALUES ('LS', 'Maseru', false);
INSERT INTO location (country, city, active) VALUES ('LV', 'Riga', false);
INSERT INTO location (country, city, active) VALUES ('LB', 'Beirut', false);
INSERT INTO location (country, city, active) VALUES ('LR', 'Monrovia', false);
INSERT INTO location (country, city, active) VALUES ('LY', 'Tripoli', false);
INSERT INTO location (country, city, active) VALUES ('LI', 'Vaduz', false);
INSERT INTO location (country, city, active) VALUES ('LT', 'Vilna', false);
INSERT INTO location (country, city, active) VALUES ('LU', 'Luxemburgo', false);
INSERT INTO location (country, city, active) VALUES ('MK', 'Scopy', false);
INSERT INTO location (country, city, active) VALUES ('MG', 'Antananarivo', false);
INSERT INTO location (country, city, active) VALUES ('MY', 'Kuala Lumpur', false);
INSERT INTO location (country, city, active) VALUES ('MW', 'Lilong', false);
INSERT INTO location (country, city, active) VALUES ('MV', 'Hombre', false);
INSERT INTO location (country, city, active) VALUES ('ML', 'Bamako', false);
INSERT INTO location (country, city, active) VALUES ('MT', 'Valletta', false);
INSERT INTO location (country, city, active) VALUES ('MA', 'Descuento', false);
INSERT INTO location (country, city, active) VALUES ('MU', 'Porto Luis', false);
INSERT INTO location (country, city, active) VALUES ('MR', 'Puta', false);
INSERT INTO location (country, city, active) VALUES ('MX', 'Ciudad De Mexico', false);
INSERT INTO location (country, city, active) VALUES ('MM', 'Nepiedo', false);
INSERT INTO location (country, city, active) VALUES ('FM', 'Paliquir', false);
INSERT INTO location (country, city, active) VALUES ('MZ', 'Maputo', false);
INSERT INTO location (country, city, active) VALUES ('MD', 'Quixinau', false);
INSERT INTO location (country, city, active) VALUES ('MC', 'Monaco', false);
INSERT INTO location (country, city, active) VALUES ('MN', 'Ula Bator', false);
INSERT INTO location (country, city, active) VALUES ('ME', 'Podgoritsa', false);
INSERT INTO location (country, city, active) VALUES ('NA', 'Vinduk', false);
INSERT INTO location (country, city, active) VALUES ('NR', 'Iria', false);
INSERT INTO location (country, city, active) VALUES ('NP', 'Katmandu', false);
INSERT INTO location (country, city, active) VALUES ('NI', 'Managua', false);
INSERT INTO location (country, city, active) VALUES ('NI', 'Leon', false);
INSERT INTO location (country, city, active) VALUES ('NE', 'Niamey', false);
INSERT INTO location (country, city, active) VALUES ('NG', 'Abuja', false);
INSERT INTO location (country, city, active) VALUES ('NO', 'Oslo', false);
INSERT INTO location (country, city, active) VALUES ('NZ', 'Wellington', false);
INSERT INTO location (country, city, active) VALUES ('OM', 'Muscat', false);
INSERT INTO location (country, city, active) VALUES ('NL', 'Amsterdam', false);
INSERT INTO location (country, city, active) VALUES ('PW', 'Ngerulmud', false);
INSERT INTO location (country, city, active) VALUES ('PA', 'Ciudad De Panama', false);
INSERT INTO location (country, city, active) VALUES ('PG', 'Puerto De Moresby', false);
INSERT INTO location (country, city, active) VALUES ('PK', 'Islamabad', false);
INSERT INTO location (country, city, active) VALUES ('PY', 'Asuncion', false);
INSERT INTO location (country, city, active) VALUES ('PE', 'Lima', false);
INSERT INTO location (country, city, active) VALUES ('PL', 'Varsovia', false);
INSERT INTO location (country, city, active) VALUES ('PT', 'Lisboa', false);
INSERT INTO location (country, city, active) VALUES ('KE', 'Nairobi', false);
INSERT INTO location (country, city, active) VALUES ('KG', 'Bisque', false);
INSERT INTO location (country, city, active) VALUES ('KI', 'Taraua Meridional', false);
INSERT INTO location (country, city, active) VALUES ('GB', 'Londres', false);
INSERT INTO location (country, city, active) VALUES ('CF', 'Bangui', false);
INSERT INTO location (country, city, active) VALUES ('CZ', 'Praga', false);
INSERT INTO location (country, city, active) VALUES ('CD', 'Kinshasa', false);
INSERT INTO location (country, city, active) VALUES ('DO', 'San Domingos', false);
INSERT INTO location (country, city, active) VALUES ('RO', 'Bucarest', false);
INSERT INTO location (country, city, active) VALUES ('RW', 'Kigali', false);
INSERT INTO location (country, city, active) VALUES ('RU', 'Moscu', false);
INSERT INTO location (country, city, active) VALUES ('SB', 'Honiara', false);
INSERT INTO location (country, city, active) VALUES ('SV', 'San Salvador', false);
INSERT INTO location (country, city, active) VALUES ('WS', 'Apia', false);
INSERT INTO location (country, city, active) VALUES ('LC', 'Castries', false);
INSERT INTO location (country, city, active) VALUES ('KN', 'Basseterre', false);
INSERT INTO location (country, city, active) VALUES ('SM', 'San Marino', false);
INSERT INTO location (country, city, active) VALUES ('ST', 'San Tome', false);
INSERT INTO location (country, city, active) VALUES ('VC', 'Kingstown', false);
INSERT INTO location (country, city, active) VALUES ('SC', 'Victoria', false);
INSERT INTO location (country, city, active) VALUES ('SN', 'Dakar', false);
INSERT INTO location (country, city, active) VALUES ('SL', 'Freetown', false);
INSERT INTO location (country, city, active) VALUES ('RS', 'Belgrado', false);
INSERT INTO location (country, city, active) VALUES ('SG', 'Singapur', false);
INSERT INTO location (country, city, active) VALUES ('SY', 'Albaricoque', false);
INSERT INTO location (country, city, active) VALUES ('SO', 'Mogadiscio', false);
INSERT INTO location (country, city, active) VALUES ('LK', 'Sri Jaiavardenapura-Cota', false);
INSERT INTO location (country, city, active) VALUES ('SZ', 'Lobamba', false);
INSERT INTO location (country, city, active) VALUES ('SD', 'Caricatura', false);
INSERT INTO location (country, city, active) VALUES ('SS', 'Mane', false);
INSERT INTO location (country, city, active) VALUES ('SE', 'Estocolmo', false);
INSERT INTO location (country, city, active) VALUES ('CH', 'Berna', false);
INSERT INTO location (country, city, active) VALUES ('SR', 'Paramaribo', false);
INSERT INTO location (country, city, active) VALUES ('TH', 'Bangkok', false);
INSERT INTO location (country, city, active) VALUES ('TW', 'Taipe', false);
INSERT INTO location (country, city, active) VALUES ('TJ', 'Ducha', false);
INSERT INTO location (country, city, active) VALUES ('TZ', 'Dodoma', false);
INSERT INTO location (country, city, active) VALUES ('TL', 'Dili', false);
INSERT INTO location (country, city, active) VALUES ('TG', 'Lome', false);
INSERT INTO location (country, city, active) VALUES ('TO', 'Nucualofa', false);
INSERT INTO location (country, city, active) VALUES ('TT', 'Puerto De España', false);
INSERT INTO location (country, city, active) VALUES ('TN', 'Melodias', false);
INSERT INTO location (country, city, active) VALUES ('TM', 'Ashgabat', false);
INSERT INTO location (country, city, active) VALUES ('TR', 'Ankara', false);
INSERT INTO location (country, city, active) VALUES ('TV', 'Funafuti', false);
INSERT INTO location (country, city, active) VALUES ('UA', 'Quieve', false);
INSERT INTO location (country, city, active) VALUES ('UG', 'Kampala', false);
INSERT INTO location (country, city, active) VALUES ('UY', 'Montevideo', false);
INSERT INTO location (country, city, active) VALUES ('UZ', 'Tasquente', false);
INSERT INTO location (country, city, active) VALUES ('VU', 'Porto Vila', false);
INSERT INTO location (country, city, active) VALUES ('VA', 'Vaticano', false);
INSERT INTO location (country, city, active) VALUES ('VE', 'Caracas', false);
INSERT INTO location (country, city, active) VALUES ('VN', 'Hanoi', false);
INSERT INTO location (country, city, active) VALUES ('ZM', 'Lusaka', false);
INSERT INTO location (country, city, active) VALUES ('ZW', 'Harare', false);

INSERT INTO rules (country, city, sku, min_condition, max_condition, variation) VALUES ('NI', 'Leon', 'AZ00001', 500, 599, 1.5);
INSERT INTO rules (country, city, sku, min_condition, max_condition, variation) VALUES ('NI', 'Leon', 'AZ00002', 500, 599, 0.5);
INSERT INTO rules (country, city, sku, min_condition, max_condition, variation) VALUES ('NI', 'Leon', 'AZ00001', 800, 804, 0.5);
INSERT INTO rules (country, city, sku, min_condition, max_condition, variation) VALUES ('NI', 'Leon', 'AZ00002', 800, 804, 1.5);
INSERT INTO rules (country, city, sku, min_condition, max_condition, variation) VALUES ('PR', 'Guayama', 'AZ00001', 500, 599, 1.5);
INSERT INTO rules (country, city, sku, min_condition, max_condition, variation) VALUES ('PR', 'Guayama', 'AZ00002', 500, 599, 0.5);
INSERT INTO rules (country, city, sku, min_condition, max_condition, variation) VALUES ('PR', 'Guayama', 'AZ00001', 800, 804, 0.5);
INSERT INTO rules (country, city, sku, min_condition, max_condition, variation) VALUES ('PR', 'Guayama', 'AZ00002', 800, 804, 1.5);
