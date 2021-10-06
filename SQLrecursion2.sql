
--recursion practice

WITH flight_route (Departure, Arrival, stops) AS(
	SELECT 
    	f.Departure, f.Arrival, 
  		-- Initialize the number of stops
    	0
  	FROM flightPlan f
  	WHERE Departure = 'Vienna'
  	UNION ALL
  	SELECT 
    	p.Departure, f.Arrival, 
  		-- Increment the number of stops
    	p.stops + 1
  	FROM flightPlan f, flight_route p
  	-- Limit the number of stops
  	WHERE p.Arrival = f.Departure AND
          p.stops < 5)

SELECT 
	DISTINCT Arrival, 
    Departure, 
    stops
FROM flight_route;





-- Define totalCost
WITH flight_route (Departure, Arrival, stops, totalCost, route) AS(
  	SELECT 
    	f.Departure, f.Arrival, 
    	0,
    	-- Define the totalCost with the flight cost of the first flight
    	Cost,
    	CAST(Departure + ' -> ' + Arrival AS NVARCHAR(MAX))
  	FROM flightPlan f
  	WHERE Departure = 'Vienna'
  	UNION ALL
  	SELECT 
    	p.Departure, f.Arrival, 
    	p.stops + 1,
    	-- Add the cost for each layover to the total costs
    	p.totalCost + f.Cost,
    	p.route + ' -> ' + f.Arrival
  	FROM flightPlan f, flight_route p
  	WHERE p.Arrival = f.Departure AND 
          p.stops < 5)



-- Define CTE with the fields: PartID, SubPartID, Title, Component, Level
WITH construction_Plan (PartID, SubPartID,Title, Component, Level) AS (
	SELECT 
  		PartID,
  		SubPartID,
  		Title,
  		Component,
  		-- Initialize the field Level
  		1
	FROM partList
	WHERE PartID = '1'
	UNION ALL
	SELECT 
		CHILD.PartID, 
  		CHILD.SubPartID,
  		CHILD.Title,
  		CHILD.Component,
  		-- Increment the field Level each recursion step
  		PARENT.Level + 1
	FROM construction_Plan PARENT, partList CHILD
  	WHERE CHILD.SubPartID = PARENT.PartID
  	-- Limit the number of iterations to Level < 2
	  AND PARENT.Level < 2)
      
SELECT DISTINCT PartID, SubPartID, Title, Component, Level
FROM construction_Plan
ORDER BY PartID, SubPartID, Level;