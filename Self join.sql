-- https://sqlzoo.net/wiki/Self_join
-- Edinburgh Buses
-- stops(id, name)
-- route(num, company, pos, stop)

-- 1. How many stops are in the database.

select count(id)
from stops

-- 2. Find the id value for the stop 'Craiglockhart'

SELECT id
FROM stops
where name = "Craiglockhart"

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.

select id, name
from stops s
LEFT join route r
on  s.id = r.stop
where r.num = '4' and r.company = 'LRT'

-- Routes and stops
-- 4. The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
select company, num, count(*)
from route
where stop = 149 or stop = 53
group by 1,2
having count(*) =2

-- 5. Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.

SELECT r1.company, r1.num, r1.stop, r2.stop
from route r1, route r2
where r1.company = r2.company
and r1.num = r2.num
and r1.stop = (select id from stops where name = "Craiglockhart")
and r2.stop = (select id from stops where name = "London Road")

-- 6. The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. If you are tired of these places try 'Fairmilehead' against 'Tollcross'

select r1.company, r1.num, r1.name, r2.name
from (select * from route left join stops on route.stop = stops.id) r1
left join (select * from route left join stops on route.stop = stops.id) r2
on (r1.num = r2.num and r1.company = r2.company)
where r1.name = "Craiglockhart" and r2.name = "London Road"

-- 7. Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

select distinct r1.company, r1.num
from route r1, route r2
where r1.num = r2.num 
and r1.company = r2.company
and ((r1.stop = 115 and r2.stop = 137) or (r1.stop = 137 and r2.stop = 115))

-- 8. Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

select r1.company, r1.num
from route r1, route r2
where r1.num = r2.num 
and r1.company = r2.company
and r1.stop = (select id from stops where name = "Craiglockhart")
and r2.stop = (select id from stops where name = "Tollcross")

-- 9. Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.

select s2.name, r1.company, r1.num 
from route r1, route r2, stops s1, stops s2
where r1.num = r2.num 
and r1.company = r2.company
and r1.stop = s1.id
and r2.stop = s2.id
and r1.stop = (select id from stops where name = "Craiglockhart")
and r1.company = "LRT"

-- 10. Find the routes involving two buses that can go from Craiglockhart to Lochend.

select r1.num, r1.company, s2.name, r3.num, r3.company
from route r1, route r2, route r3, route r4, stops s1, stops s2, stops s3
where r1.num = r2.num
and r1.company = r2.company
and r1.stop != r2.stop
and r1.stop = s1.id
and s1.name = "Craiglockhart"
and r3.num = r4.num
and r3.company = r4.company
and r3.stop !=r4.stop
and r4.stop = s3.id
and s3.name = "Lochend"
and r2.stop = r3.stop
and r2.stop = s2.id
order by r1.num 

-- 


