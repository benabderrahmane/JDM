--- A node, for example eid=336|n="vomi"|t=1|w=50
CREATE TABLE nodes (
	eid INTEGER,
	n VARCHAR(256),
	t INTEGER,
	w INTEGER,
	CONSTRAINT PK_NODES PRIMARY KEY (eid),
	CONSTRAINT FK_RELATION_TYPE FOREIGN KEY (t) REFERENCES relationTypes(rtid)
);


CREATE TABLE nodes (
	eid INTEGER PRIMARY KEY,
	n VARCHAR(256),
	t INTEGER,
	w INTEGER,
    FOREIGN KEY (t) REFERENCES relationTypes(rtid)
);
