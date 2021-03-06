/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */



/* Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */

-- Q1 Ans: Tennis Court 1, Tennis Court 2, Massage Room 1, Massage Room 2, Squash Court


SELECT name, membercost
FROM Facilities
WHERE membercost != 0


/* Q2: How many facilities do not charge a fee to members? */

-- Q2 Ans : 4

SELECT COUNT(name)
FROM Facilities
WHERE membercost = 0


/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

-- Q3 Ans : 

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost != 0 AND membercost < (monthlymaintenance * 0.2)



/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

-- Q4 Ans :

SELECT *
FROM Facilities
WHERE facid IN (1,5)


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

-- Q5 Ans :

SELECT (CASE WHEN monthlymaintenance > 100 THEN 'expensive' ELSE 'cheap' END) as 'status', name, monthlymaintenance
FROM Facilities



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

-- Q6 Ans :

SELECT firstname, surname, joindate
FROM Members
ORDER BY joindate DESC


/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

-- Q7 Ans :

SELECT b.facid, b.memid, f.name as court_name, CONCAT(m.firstname,'_',m.surname) as member_name
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE f.name LIKE 'Tennis Court%'
GROUP BY court_name, member_name
ORDER BY member_name



/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

-- Q8 Ans :

SELECT f.name as facility_name, CONCAT(m.firstname,'_',m.surname) as member_name, (CASE WHEN b.memid = 0 THEN guestcost ELSE membercost END) as cost
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE b.starttime >= '2012-09-14' AND b.starttime < '2012-09-15' AND (b.slots * (CASE WHEN b.memid = 0 THEN guestcost ELSE membercost END)) > 30
GROUP BY facility_name, member_name
ORDER BY cost DESC



/* Q9: This time, produce the same result as in Q8, but using a subquery. */

-- Q9 Ans :

SELECT f.name as facility_name, CONCAT(m.firstname,'_',m.surname) as member_name, (CASE WHEN b.memid = 0 THEN guestcost ELSE membercost END) as cost
FROM (SELECT *
	  FROM Bookings
	  WHERE starttime >= '2012-09-14' AND starttime < '2012-09-15') as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid = m.memid
WHERE (b.slots * (CASE WHEN b.memid = 0 THEN guestcost ELSE membercost END)) > 30
GROUP BY facility_name, member_name
ORDER BY cost DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

-- Q10 Ans :

SELECT SUM(CASE WHEN b.memid = 0 THEN f.guestcost*b.slots ELSE f.membercost*b.slots END) as cost, f.name as facility_name
FROM Bookings as b
LEFT JOIN Facilities as f
ON b.facid = f.facid
LEFT JOIN Members as m
ON b.memid =  m.memid
GROUP BY facility_name
HAVING cost < 1000
ORDER BY cost

