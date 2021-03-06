/* Welcome to the SQL mini project. 

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

SQL: SELECT name FROM  `Facilities` WHERE membercost > 0

Result: 

Tennis Court 1
Tennis Court 2
Massage Room 1
Massage Room 2
Squash Court

/* Q2: How many facilities do not charge a fee to members? */

SQL: SELECT COUNT( * )  FROM  `Facilities` WHERE membercost =0

Result: 4 

/* Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SQL: SELECT facid, name, membercost, monthlymaintenance FROM  `Facilities` WHERE membercost < ( 0.2 * monthlymaintenance ) 

Result: 

0;"Tennis Court 1";"5.0";"200"
1;"Tennis Court 2";"5.0";"200"
2;"Badminton Court";"0.0";"50"
3;"Table Tennis";"0.0";"10"
4;"Massage Room 1";"9.9";"3000"
5;"Massage Room 2";"9.9";"3000"
6;"Squash Court";"3.5";"80"
7;"Snooker Table";"0.0";"15"
8;"Pool Table";"0.0";"15"


/* Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */

SQL: SELECT * FROM  `Facilities`  WHERE facid IN ( 1, 5 ) 


/* Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */

SELECT CASE 
            WHEN monthlymaintenance > 100 
               THEN 'expensive'
               ELSE 'cheap'
       END as name, monthlymaintenance 
FROM Facilities


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */

SELECT firstname, surname
FROM  Members 
WHERE memid = ( 
SELECT MAX( memid ) 
FROM Members )

/* Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */

SELECT DISTINCT C.name, B.firstname
FROM Bookings A, Members B, Facilities C
WHERE A.memid = B.memid
AND A.facid = C.facid
AND C.name
IN ('Tennis Court 1',  'Tennis Court 2')
ORDER BY B.firstname


/* Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */

SELECT F.name as FacilityName, CONCAT(M.firstname, ' ', M.surname) as MemberName,
	(CASE WHEN B.memid =0
	THEN B.slots * F.guestcost
	ELSE B.slots * F.membercost
	END
	) AS totalcost
FROM Facilities F, Bookings B, Members M
WHERE F.facid = B.facid
AND B.memid = M.memid
AND DATE( B.starttime ) =  '2012-09-14'
HAVING totalcost > 30
ORDER BY totalcost DESC 


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT sub.name as FacilityName, sub.MemberName, sub.totalcost
FROM (SELECT F.name, CONCAT(M.firstname, ' ', M.surname) as MemberName,
	(CASE WHEN B.memid =0
	THEN B.slots * F.guestcost
	ELSE B.slots * F.membercost
	END
	) AS totalcost
	FROM Facilities F, Bookings B, Members M
	WHERE F.facid = B.facid
	AND B.memid = M.memid
	AND DATE( B.starttime ) =  '2012-09-14') sub
HAVING sub.totalcost > 30
ORDER BY sub.totalcost DESC


/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

SELECT sub.name as FacilityName, SUM(sub.totalcost) as totalrevenue
FROM (SELECT F.name, 
	(CASE WHEN B.memid =0
	THEN B.slots * F.guestcost
	ELSE B.slots * F.membercost
	END
	) AS totalcost
	FROM Facilities F, Bookings B, Members M
	WHERE F.facid = B.facid
	AND B.memid = M.memid) sub
GROUP BY sub.name
HAVING totalrevenue < 1000
ORDER BY totalrevenue DESC 

