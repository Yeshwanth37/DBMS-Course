/*
Assume a passenger on a trip wants to pay the gas bill for a particular trip (or the passengers want to split the cost...). The captian needs to know the price of gas for the most recent gas purchase. By most recent, it is meant in the past. The captain needs to know what was the price per gallon of the last purchase prior to the boat trip.

List slTrip.TripStart, slTrip.TripEngineStart, slTrip.TripEngineEnd, EngineHours, CostPerGallon, and GasCost for the trip starting '2015-03-15 21:30:00.000'.
EngineHours is the differnce between the engine hours start and end time (the duration in hours the engine was running).
CostPerGallon is the gas price for the most recent gas purchase since the trip.
GasCost is computed as the ((CostPerGallon * 3) * EngineHours). The engine averages 3 gallons per engine hour.
*/
SELECT slTrip.TripStart,
       slTrip.TripEngineStart,
       slTrip.TripEngineEnd,
       (SELECT ROUND((slTrip.TripEngineEnd - slTrip.TripEngineStart), 2)) AS EngineHours,
       (SELECT TOP 1 CostPerGallon 
       FROM slGasPurchase
       WHERE PurchaseDate < '2015-03-14 20:30:00.000'
       ORDER BY PurchaseDate DESC) AS CostPerGallon,
       (SELECT ROUND(((SELECT TOP 1 CostPerGallon 
                       FROM slGasPurchase
                       WHERE PurchaseDate < '2015-03-14 20:30:00.000'
                       ORDER BY PurchaseDate DESC)* 3)* 
                      (SELECT ROUND((slTrip.TripEngineEnd - slTrip.TripEngineStart), 2)),2)) AS GasCost
FROM slTrip
WHERE TripStart = '2015-03-15 21:30:00.000';
