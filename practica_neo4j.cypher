// 🟢Q1 Películas por década
MATCH (m:movie)
WHERE m.released >= 1990 AND m.released < 1999
RETURN m.title AS Título, m.released AS Año, m.tagline AS Lema
ORDER BY m.released ASC, m.title ASC 
// 🟢Q2

// 🟢Q3

// 🟢Q4

// 🟠Q5

// 🟠Q6

// 🟠Q7

// 🟠Q8

// 🔴Q9

// 🔴Q10

// 🔴Q11

// 🔴Q12

// 🔴Q13

// 🔴Q14

// 🔴Q15

// 🔵Q16

// 🔵Q17
