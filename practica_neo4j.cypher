// Q1 Películas por década
MATCH (m:Movie)
WHERE m.released >= 1990 AND m.released < 1999
RETURN m.title AS Título, m.released AS Año, m.tagline AS Lema
ORDER BY m.released ASC, m.title ASC 

// Q2 Reparto de una película específica
MATCH (m:Movie {title: "The Matrix"})<-[r:ACTED_IN]-(p:Person)
RETURN p.name AS Persona, r.roles AS Roles

// Q3 Películas con sus directores
MATCH (p:Person)-[:DIRECTED]->(m:Movie)
RETURN m.title AS Pelicula, collect(p.name) AS Directores
ORDER BY Pelicula;

// Q4 Actores nacidos después de 1965
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)
WHERE p.born > 1965
RETURN p.name AS Nombre, p.born AS AnioNacimiento, count(m) AS CantidadPeliculas
ORDER BY AnioNacimiento ASC;

// Q5  Colaboradores de un actor
MATCH (p:Person {name: "Keanu Reeves"})-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(c:Person)
RETURN c.name AS Colaborador, collect(m.title) AS Películas


// Q6 Personas con múltiples funciones 
MATCH (p:Person)-[r:ACTED_IN|DIRECTED|PRODUCED|WROTE]->(m:Movie)
WITH p, collect(DISTINCT type(r)) AS TiposParticipacion, count(DISTINCT m) AS CantidadPeliculas
WHERE size(TiposParticipacion) >= 2
RETURN p.name AS Persona, TiposParticipacion, CantidadPeliculas
ORDER BY CantidadPeliculas DESC;

// Q7  Películas con reparto amplio 
MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WITH m, collect(p.name) AS Actores
WHERE size(Actores) > 5
RETURN m.title AS Película,
       m.released AS Año,
       size(Actores) AS NúmeroDeActores,
       Actores

// Q8  Relación entre usuarios que siguen y reseñas
MATCH (seguidor:Person)-[:FOLLOWS]->(seguido:Person)-[r2:REVIEWED]->(m:Movie)
OPTIONAL MATCH (seguidor)-[r1:REVIEWED]->(m)
RETURN seguidor.name AS QuienSigue, 
       seguido.name AS AQuienSigue, 
       m.title AS PeliculaResenada, 
       r2.rating AS Calificacion, 
       r1 IS NOT NULL AS SeguidorTambienReseno
ORDER BY QuienSigue, AQuienSigue;


// Q9 Ruta más corta entre dos actores 
MATCH (keanu:Person {name: "Keanu Reeves"}),
      (tom:Person {name: "Tom Hanks"}),
      ruta = shortestPath((keanu)-[:ACTED_IN*]-(tom))
RETURN [n IN nodes(ruta) | 
        CASE WHEN n:Person THEN n.name 
             WHEN n:Movie  THEN n.title 
        END] AS Ruta,
       length(ruta) AS Saltos

// Q10 Recomendación basada en personas seguidas
MATCH (jt:Person {name: 'James Thompson'})-[:FOLLOWS]->(amigo:Person)-[r:REVIEWED]->(m:Movie)
WHERE NOT (jt)-[:REVIEWED]->(m)
RETURN m.title AS PeliculaRecomendada, 
       collect(amigo.name) AS RecomendadaPor, 
       avg(r.rating) AS CalificacionPromedio
ORDER BY CalificacionPromedio DESC, PeliculaRecomendada ASC;


// Q11 Actores con mayor red de colaboración 
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(c:Person)
RETURN p.name AS Actor,
       count(DISTINCT c) AS RedDeColaboración
ORDER BY RedDeColaboración DESC
LIMIT 10

// Q12 Número de Bacon
MATCH p = shortestPath((bacon:Person {name: 'Kevin Bacon'})-[:ACTED_IN*]-(otro:Person))
WHERE bacon <> otro
RETURN otro.name AS Persona, 
       length(p) / 2 AS NumeroDeBacon
ORDER BY NumeroDeBacon ASC, Persona ASC
LIMIT 20;


// Q13 Personas que actuaron y dirigieron 
MATCH (p:Person)-[:ACTED_IN]->(actuada:Movie),
      (p)-[:DIRECTED]->(dirigida:Movie)
RETURN p.name AS Persona,
       collect(DISTINCT actuada.title) AS Actuó,
       collect(DISTINCT dirigida.title) AS Dirigió
ORDER BY p.name ASC

// Q14 Actores con múltiples roles en una misma película
MATCH (a:Person)-[r:ACTED_IN]->(m:Movie)
WHERE size(r.roles) > 1
RETURN a.name AS Actor, 
       m.title AS Pelicula, 
       r.roles AS ListaDeRoles, 
       size(r.roles) AS CantidadDeRoles
ORDER BY CantidadDeRoles DESC, Actor ASC;

// Q15  Películas similares por actores compartidos 
MATCH (m1:Movie)<-[:ACTED_IN]-(p:Person)-[:ACTED_IN]->(m2:Movie)
WHERE id(m1) < id(m2)
WITH m1, m2, collect(p.name) AS ActoresCompartidos
WHERE size(ActoresCompartidos) >= 2
RETURN m1.title AS Película1,
       m2.title AS Película2,
       ActoresCompartidos,
       size(ActoresCompartidos) AS Similitud
ORDER BY Similitud DESC

// Q16 Crear relaciones de colaboración
MATCH (p1:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(p2:Person)
WHERE p1.name < p2.name
WITH p1, p2, collect(m.title) AS peliculasCompartidas, count(m) AS cantidadCompartidas
MERGE (p1)-[c:COLLABORATED_WITH]->(p2)
SET c.movies = peliculasCompartidas, 
    c.count = cantidadCompartidas;

// Q17 Consultar las colaboraciones materializadas
MATCH (p1:Person)-[c:COLLABORATED_WITH]->(p2:Person)
RETURN p1.name AS Actor1, 
       p2.name AS Actor2, 
       c.count AS PeliculasCompartidas, 
       c.movies AS ListaDePeliculas
ORDER BY PeliculasCompartidas DESC
LIMIT 10;
