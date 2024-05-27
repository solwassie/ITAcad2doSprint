/*- Exercici 1
A partir dels documents adjunts (estructura_dades i dades_introduir), importa les dues taules. 
Mostra les característiques principals de l'esquema creat i explica les diferents taules i 
variables que existeixen. Assegura't d'incloure un diagrama que il·lustri la relació entre les diferents
taules i variables.

Exercici 2
Utilitzant JOIN realitzaràs les següents consultes:
Llistat dels països que estan fent compres. */

SELECT DISTINCT company.country
FROM company
RIGHT JOIN transaction
ON company.id=transaction.company_id;

-- Des de quants països es realitzen les compres.
SELECT COUNT( DISTINCT company.country) AS Paises_Comprando
FROM company
RIGHT JOIN transaction
ON company.id=transaction.company_id;

-- Identifica la companyia amb la mitjana més gran de vendes. */

SELECT company.company_name, transaction.company_id, AVG(transaction.amount) as ventas
FROM transaction
JOIN company
ON company.id=transaction.company_id
GROUP BY company_id
ORDER BY ventas DESC
LIMIT 1;

/*Exercici 3
Utilitzant només subconsultes (sense utilitzar JOIN):
Mostra totes les transaccions realitzades per empreses d'Alemanya. */

SELECT id, credit_card_id, company_id, user_id, lat, longitude, timestamp, amount, declined
FROM transactions.transaction
WHERE company_id IN (SELECT id
  FROM transactions.company
  WHERE country = 'Germany');

-- Llista les empreses que han realitzat transaccions per un amount superior a la mitjana de totes les transaccions.
SELECT id, company_name
from company
where (select max(amount) 
		from transaction
        where company_id = company.id) > (
			SELECT AVG(amount)
			FROM transaction
			);

/*Eliminaran del sistema les empreses que no tenen transaccions registrades,
-- entrega el llistat d'aquestes empreses.*/

SELECT company_name
FROM company
WHERE NOT EXISTS (SELECT * FROM transactions.transaction
				  WHERE company_id = company.id  OR company_name is null);

/* Nivell 2
Exercici 1
Identifica els cinc dies que es va generar la quantitat més gran d'ingressos a l'empresa per vendes. 
Mostra la data de cada transacció juntament amb el total de les vendes. subquery */

SELECT SUM(amount) as ventas, DATE(timestamp) AS dia
FROM transaction
GROUP BY DATE(timestamp)
ORDER BY ventas DESC
LIMIT 5;

-- Exercici 2
-- Quina és la mitjana de vendes per país? Presenta els resultats ordenats de major a menor mitjà.

SELECT company.country, AVG(transaction.amount) as ventas
FROM transaction
JOIN company
ON company.id=transaction.company_id
GROUP BY company.country
ORDER BY ventas DESC;

-- Exercici 3
/* En la teva empresa, es planteja un nou projecte per a llançar algunes campanyes publicitàries
 per a fer competència a la companyia "Non Institute". Per a això, et demanen la llista de totes les 
 transaccions realitzades per empreses que estan situades en el mateix país que aquesta companyia.
Mostra el llistat aplicant JOIN i subconsultes.*/

SELECT transaction.*
FROM transaction
JOIN company ON transaction.company_id = company.id
WHERE company.country = (
    SELECT country
    FROM company
    WHERE company_name = 'Non Institute'
);

-- Mostra el llistat aplicant solament subconsultes.
SELECT *
FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = (
        SELECT country
        FROM company
        WHERE company_name = 'Non Institute'
    ));

/* Nivell 3
Exercici 1
Presenta el nom, telèfon, país, data i amount, d'aquelles empreses que van realitzar transaccions
amb un valor comprès entre 100 i 200 euros i en alguna d'aquestes dates: 29 d'abril del 2021, 
20 de juliol del 2021 i 13 de març del 2022. Ordena els resultats de major a menor quantitat.*/

SELECT company.company_name, company.phone, company.country, DATE(transaction.timestamp) AS data, 
transaction.amount
FROM company
RIGHT JOIN transaction
ON transaction.company_id = company.id
WHERE transaction.amount BETWEEN 100 AND 200
AND DATE(transaction.timestamp) IN ('2021-04-29','2021-07-20','2022-03-13')
ORDER BY transaction.amount DESC;


/* Exercici 2
Necessitem optimitzar l'assignació dels recursos i dependrà de la capacitat operativa que es requereixi,
per la qual cosa et demanen la informació sobre la quantitat de transaccions que realitzen les empreses, 
però el departament de recursos humans és exigent i vol un llistat de les empreses on especifiquis si tenen
 més de 4 transaccions o menys.*/

SELECT company.company_name, COUNT(transaction.id) AS cantidad_transacciones,
    CASE 
        WHEN COUNT(transaction.id) > 4 THEN 'Más de 4 transacciones' 
        ELSE 'Menos de 4 transacciones' 
    END AS cantidad_transacciones_status
FROM company
LEFT JOIN transaction ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY cantidad_transacciones;
