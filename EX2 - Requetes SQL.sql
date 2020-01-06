/* Utilisation de la DB Northwind pour les exercices */
USE `northwind`;



/* 1 - Liste des contacts français 
Select : Selectionne les collones 
From : Dans le tableau 
Where : Condition de la selection */
SELECT `CompanyName` AS Société,
`ContactName` AS Contact, 
`ContactTitle` AS Fonction, 
`Phone` AS Téléphone
FROM `customers`
WHERE customers.`Country` = 'France';


/* 2 - Produits vendus par Exotic Liquids
Join : Jointure avec un autre tableau
(Permet de lier deux Tables différentes par une variable commune) */
SELECT products.`ProductName` AS Produit, 
products.`UnitPrice` AS Prix
FROM products 
JOIN `suppliers` ON `suppliers`.`SupplierID` = products.`SupplierID`
WHERE `suppliers`.`CompanyName` = 'Exotic Liquids';


/* 3 - Produits vendus par Français (DESC) 
Group By : Regroupe par veleur identiques
Order by : Trier par ordre Croissant 
(Decroissant avec l'utilisation de 'DESC') */
SELECT suppliers.`CompanyName` AS Société,
count(products.`ProductID`) AS NbrProduits
FROM products
JOIN suppliers ON suppliers.`SupplierID` = products.`SupplierID`
WHERE suppliers.`Country` = 'France'
GROUP BY products.`SupplierID`
ORDER BY NbrProduits DESC;


/* 4 - Clients français ayant plus de 10 commandes 
COUNT() : Compte le nbr de valeurs 
Having : Clause de condition avec Group By */
SELECT customers.`CompanyName` AS `Client`,
count(orders.`OrderID`) AS NbrCommandes
FROM orders
JOIN customers ON customers.`CustomerID` = orders.`CustomerID`
WHERE customers.`Country` = 'France'
GROUP BY orders.`CustomerID`
	HAVING NbrCommandes > 10;


/* 5 - Clients ayant un chiffre d'affaire > 30 000 
SUM() : Somme des Valeurs
Attention à Grou By CustomerID et non Group By CompanyName */
SELECT customers.`CompanyName` AS Clients,
sum(`order details`.`Quantity` * `order details`.`UnitPrice`) AS CA,
customers.`Country`
FROM customers
JOIN orders ON orders.`CustomerID` = customers.`CustomerID`
JOIN `order details` ON `order details`.`OrderID` = orders.`OrderID`
GROUP BY customers.`CustomerID` 
	HAVING CA > 30000;


/* 6 - Pays des clients chez Exotic Liquid 
Pour Join des Tables qui n'ont aucunes variables communes, 
je Join un à un les Tables jusqu'à pouvoir Joindre le Table voulu.
- Select Distinct : Selectionne si différent -> Evite les doublons. */
SELECT DISTINCT orders.`ShipCountry` AS Pays
FROM orders
JOIN `order details` ON `order details`.`OrderID` = orders.`OrderID`
JOIN products ON products.`ProductID` = `order details`.`ProductID`
JOIN suppliers ON suppliers.`SupplierID` = products.`SupplierID`
WHERE `suppliers`.`CompanyName` = 'Exotic Liquids'
ORDER BY orders.`ShipCountry`;


/* 7 - Montant des ventes de 1997 
Like : Donne la forme 
% pour dire ça peut etre suivi de n'importe quelle valeur */
SELECT sum(`order details`.`UnitPrice` * `order details`.`Quantity`) AS 'CA 1997'
FROM `order details`
JOIN `orders` ON orders.`OrderID` = `order details`.`OrderID`
WHERE orders.`OrderDate` LIKE '1997%';


/* 8 - Montant des ventes de 1997 par mois 
MONTH() : Fonction qui retourne le mois d'une date */ 
SELECT MONTH(orders.`OrderDate`) AS Mois,
sum(`order details`.`UnitPrice` * `order details`.`Quantity`) AS CA
FROM `order details`
JOIN `orders` ON orders.`OrderID` = `order details`.`OrderID`
WHERE orders.`OrderDate` LIKE '1997%'
GROUP BY Mois;


/* 9 - Dernière commande de "Du Monde entier" 
J'utilise Order By (avec DESC) pour avoir en premier la dernière date
Le Limit 1 me permet ensuite de ne garder que cette valeur */
SELECT orders.`OrderDate` AS 'Date Dernière Commande'
FROM orders 
JOIN customers ON customers.`CustomerID` = orders.`CustomerID`
WHERE customers.`CustomerID` = 'DUMON'
ORDER BY orders.`OrderDate` DESC
LIMIT 1;


/* 10 - Délais moyen de livraison 
AVG : Moyenne des valeurs 
DATEDIFF : Différence entre deux dates en jours 
Je transforme en entier sans fonction grace au Modulo 1 */
SELECT 
(AVG(DATEDIFF(orders.`ShippedDate`, orders.`OrderDate`)) - AVG(DATEDIFF(orders.`ShippedDate`, orders.`OrderDate`)) % 1) AS 'Delais Moyen'
FROM orders;