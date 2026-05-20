// 🟢Q1 Películas por década
MATCH (m:Movie)
WHERE m.released >= 1990 AND m.released < 1999
RETURN m.title AS Título, m.released AS Año, m.tagline AS Lema
ORDER BY m.released ASC, m.title ASC 

// 🟢Q2 Reparto de una película específica
MATCH (m:Movie {title: "The Matrix"})<-[r:ACTED_IN]-(p:Person)
RETURN p.name AS Persona, r.roles AS Roles

// 🟢Q3 Películas con sus directores

// 🟢Q4 Actores nacidos después de 1965

// 🟠Q5  Colaboradores de un actor
MATCH (p:Person {name: "Keanu Reeves"})-[:ACTED_IN]->(m:Movie)<-[:ACTED_IN]-(c:Person)
RETURN c.name AS Colaborador, collect(m.title) AS Películas
// 🟠Q6 Personas con múltiples funciones 

// 🟠Q7  Películas con reparto amplio #J

// 🟠Q8  Relación entre usuarios que siguen y reseñas

// 🔴Q9 #J

// 🔴Q10

// 🔴Q11 #J

// 🔴Q12

// 🔴Q13 #J

// 🔴Q14

// 🔴Q15 #J

// 🔵Q16

// 🔵Q17 
