// Q1 Películas por década
MATCH (m:Movie)
WHERE m.released >= 1990 AND m.released < 1999
RETURN m.title AS Título, m.released AS Año, m.tagline AS Lema
ORDER BY m.released ASC, m.title ASC 

// Q2 Reparto de una película específica
MATCH (m:Movie {title: "The Matrix"})<-[r:ACTED_IN]-(p:Person)
RETURN p.name AS Persona, r.roles AS Roles

// 🟢Q3 Películas con sus directores

// 🟢Q4 Actores nacidos después de 1965

// Q5  Colaboradores de un actor
MATCH (p:Person {name: "Keanu Reeves"})-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(c:Person)
RETURN c.name AS Colaborador, collect(m.title) AS Películas
// 🟠Q6 Personas con múltiples funciones 

// Q7  Películas con reparto amplio 
MATCH (m:Movie)<-[:ACTED_IN]-(p:Person)
WITH m, collect(p.name) AS Actores
WHERE size(Actores) > 5
RETURN m.title AS Película,
       m.released AS Año,
       size(Actores) AS NúmeroDeActores,
       Actores

// 🟠Q8  Relación entre usuarios que siguen y reseñas

// Q9 Ruta más corta entre dos actores 
MATCH (keanu:Person {name: "Keanu Reeves"}),
      (tom:Person {name: "Tom Hanks"}),
      ruta = shortestPath((keanu)-[:ACTED_IN*]-(tom))
RETURN [n IN nodes(ruta) | 
        CASE WHEN n:Person THEN n.name 
             WHEN n:Movie  THEN n.title 
        END] AS Ruta,
       length(ruta) AS Saltos

// 🔴Q10 Recomendación basada en personas seguidas

// Q11 Actores con mayor red de colaboración 
MATCH (p:Person)-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(c:Person)
RETURN p.name AS Actor,
       count(DISTINCT c) AS RedDeColaboración
ORDER BY RedDeColaboración DESC
LIMIT 10

// 🔴Q12 Número de Bacon

// Q13 Personas que actuaron y dirigieron 
MATCH (p:Person)-[:ACTED_IN]->(actuada:Movie),
      (p)-[:DIRECTED]->(dirigida:Movie)
RETURN p.name AS Persona,
       collect(DISTINCT actuada.title) AS Actuó,
       collect(DISTINCT dirigida.title) AS Dirigió
ORDER BY p.name ASC

// 🔴Q14 Actores con múltiples roles en una misma película

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

// 🔵Q16 Crear relaciones de colaboración

// 🔵Q17 Consultar las colaboraciones materializadas

