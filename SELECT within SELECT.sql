-- This tutorial looks at how we can use SELECT statements within SELECT statements to perform more complex queries.
-- word(name, continent, area, population, gdp)

-- 1. List each country name where the population is larger than that of 'Russia'.

SELECT name
FROM world
WHERE population > (SELECT population FROM world WHERE name = "Russia")

-- 2. Show the countries in Europe with a per capita GDP greater than 'United Kingdom'.

SELECT name
FROM world
WHERE continent = "Europe"
AND gdp/population > (SELECT gdp/population FROM world WHERE name="United Kingdom")

-- 3. List the name and continent of countries in the continents containing either Argentina or Australia. Order by name of the country.

SELECT name, continent
FROM world
WHERE continent in (SELECT continent FROM world WHERE name IN ("Argentina", "Australia"))
ORDER BY name

-- 4. Which country has a population that is more than Canada but less than Poland? Show the name and the population.

SELECT name, population
FROM world
WHERE population > (select w1.population from world w1 where w1.name = "Canada") 
and population < (Select w2.population from world w2 where w2.name = "Poland")

-- 5. Germany (population 80 million) has the largest population of the countries in Europe. Austria (population 8.5 million) has 11% of the population of Germany. Show the name and the population of each country in Europe. Show the population as a percentage of the population of Germany.

SELECT name, concat(round(population/(select population from world where name = "Germany")*100,0),"%")
FROM world
WHERE continent = "Europe"


-- 6. Which countries have a GDP greater than every country in Europe? [Give the name only.] (Some countries may have NULL gdp values)

SELECT name
FROM world
WHERE gdp > (select max(gdp) from world where continent = "Europe")

-- 7. Find the largest country (by area) in each continent, show the continent, the name and the area:

select t.continent, t.name, t.area
FROM
 (select continent, name, area, rank() over (partition by continent order by area desc) as rnk from world)t
where t.rnk = 1
order by t.name

-- 8. List each continent and the name of the country that comes first alphabetically.

select t.continent, t.name
from (select continent, name, rank() over (partition by continent order by name ) as rnk from world) t
where t.rnk = 1

-- 9. Find the continents where all countries have a population <= 25000000. Then find the names of the countries associated with these continents. Show name, continent and population.

SELECT name,continent,population FROM world x
  WHERE 25000000 >= ALL (
    SELECT population FROM world y
     WHERE x.continent=y.continent
       AND y.population>0)
       

-- 10. Some countries have populations more than three times that of any of their neighbours (in the same continent). Give the countries and continents

select w1.name, w1.continent
from world w1
where w1.population/3 > all(select w2.population from world w2 where w2.continent = w1.continent and w2.name <> w1.name)

