-- https://sqlzoo.net/wiki/More_JOIN_operations
-- This tutorial introduces the notion of a join. The database consists of three tables movie , actor and casting .
-- movie(id, title, yr, director, budget, gross)
-- actor(id, name)
-- casting(movieid, actorid, ord)

-- 1. List the films where the yr is 1962 [Show id, title]

SELECT id, title
 FROM movie
 WHERE yr=1962

-- 2. Give year of 'Citizen Kane'.

select yr
from movie
where title = "Citizen Kane"

-- 3. List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
select id, title, yr
from movie
where title like "%Star Trek%"
order by yr

-- 4. What id number does the actor 'Glenn Close' have?

select id 
from actor
where name = "Glenn Close"

-- 5. What is the id of the film 'Casablanca'

select id
from movie
where title = "Casablanca"


-- 6. Cast list for Casablanca, Use movieid=11768, (or whatever value you got from the previous question)

select name
from actor
where id in (select actorid from casting where movieid = 11768) 

-- 7. Obtain the cast list for the film 'Alien'

select name
from casting c
left join movie m on c.movieid = m.id
left join actor a on c.actorid = a.id
where title = "Alien"

-- 8. List the films in which 'Harrison Ford' has appeared

select title 
from casting c
left join movie m
on c.movieid = m.id
left join actor a 
on c.actorid = a.id
where name = "Harrison Ford"

-- 9. List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]

select title
from casting c
left join actor a 
on c.actorid = a.id
left join movie m
on c.movieid = m.id
where name = "Harrison Ford"
And ord != 1 

-- 10. List the films together with the leading star for all 1962 films.

select title, name
from casting c
left join movie m
on c.movieid = m.id
left join actor a
on c.actorid = a.id
where ord =1
and yr = 1962

-- 11. Which were the busiest years for 'Rock Hudson', show the year and the number of movies he made each year for any year in which he made more than 2 movies.

select yr, count(title)
from casting c
left join movie m
on c.movieid = m.id
left join actor a
on c.actorid = a.id
where name = "Rock Hudson"
group by yr
having count(title) > 2 

-- 12. List the film title and the leading actor for all of the films 'Julie Andrews' played in.

select title, name
from casting
left join movie
on (casting.movieid=movie.id)
left join actor on casting.actorid = actor.id
where movie.id in (
select movieid
from casting c
where c.actorid in (select actor.id 
                from actor 
                where name = "Julie Andrews") )
and ord = 1

-- 13. Obtain a list, in alphabetical order, of actors who've had at least 15 starring roles.

select name
from actor
where id in (
select actorid
from casting
where ord =1
group by actorid
having count(movieid) >=15)
order by name

 -- 14. List the films released in the year 1978 ordered by the number of actors in the cast, then by title.

select title, count(name)
from casting
left join movie on casting.movieid = movie.id
left join actor on casting.actorid = actor.id
where yr = 1978
group by title
order by count(name) desc, title

-- 15. List all the people who have worked with 'Art Garfunkel'.

select name 
from casting
left join actor
on casting.actorid = actor.id
where movieid in (select movieid from casting where actorid in 
                   (select id from actor where name = "Art Garfunkel"))
and name != "Art Garfunkel"




