USE Movie_Review_Database;

#Number 1
SELECT Movie.title, Rate_Spread_TBL.Rating_Spread
FROM (SELECT movID, MAX(stars) - MIN(stars) AS Rating_Spread
		FROM Rating
		GROUP BY movID) AS Rate_Spread_TBL 
	JOIN Movie 
	ON Rate_Spread_TBL.movID = Movie.movID
ORDER BY Rate_Spread_TBL.Rating_Spread DESC, Movie.title;

#Number 2
CREATE VIEW Average_Rating_And_Year_TBL AS
	SELECT Movie.yr AS yr, AVG(Rating.stars) AS averageRating
	FROM Rating JOIN Movie ON Rating.movID = Movie.movID
	GROUP BY Movie.movID;
        
SELECT (SELECT AVG(averageRating) 
			FROM Average_Rating_And_Year_TBL
            WHERE yr < 1980) 
		- (SELECT AVG(averageRating) 
			FROM Average_Rating_And_Year_TBL
            WHERE yr > 1980) AS Difference_In_Average;
            
#Number 3
SELECT director, title
FROM Movie
WHERE director IN (SELECT director
	FROM Movie
	GROUP BY director
	HAVING COUNT(*) > 1)
ORDER BY director, title;

#Number 4
SELECT title, averageRating
FROM (SELECT movID, AVG(stars) AS averageRating
		FROM Rating
		GROUP BY movID) AS Average_Rating_TBL JOIN
	Movie On Average_Rating_TBL.movID = Movie.movID
HAVING averageRating = (SELECT MAX(averageRating)
						FROM (SELECT movID, AVG(stars) AS averageRating
								FROM Rating
								GROUP BY movID) AS Average_Rating_TBL);

#Number 5
SELECT title, averageRating
FROM (SELECT movID, AVG(stars) AS averageRating
		FROM Rating
		GROUP BY movID) AS Average_Rating_TBL JOIN
	Movie On Average_Rating_TBL.movID = Movie.movID
HAVING averageRating = (SELECT MIN(averageRating)
						FROM (SELECT movID, AVG(stars) AS averageRating
								FROM Rating
								GROUP BY movID) AS Average_Rating_TBL);

#Number 6
SELECT director, Movie.title AS title, MAX(stars) AS Max_Stars
FROM Rating JOIN Movie ON Rating.movID = Movie.movID
WHERE director IS NOT NULL
GROUP BY director;

#Number 7
SELECT Reviewer.name, Movie.title, Rating.stars
FROM Reviewer JOIN Movie JOIN Rating ON Reviewer.rID = Rating.rID AND
		Movie.movID = Rating.movID
WHERE Reviewer.name = Movie.director;

#Number 8
SELECT Reviewer.name, Movie.title
FROM Rating JOIN Reviewer JOIN Movie ON Rating.movID = Movie.movID AND Reviewer.rID = Rating.rID
ORDER BY Reviewer.name, Movie.title;

#Number 9
CREATE VIEW Movie_Reviewer_TBL AS
	SELECT Rating.movID AS movID, Reviewer.name AS name
    FROM Rating JOIN Reviewer ON Rating.rID = Reviewer.rID;
    
SELECT DISTINCT R1.name, R2.name
FROM Movie_Reviewer_TBL R1, Movie_Reviewer_TBL R2
WHERE R1.movID = R2.movID AND R1.name < R2.name
ORDER BY R1.name, R2.name;

#Number 10
SELECT Reviewer.name AS reviewerName, Movie.title AS title, Rating.stars AS stars
FROM Reviewer JOIN Movie JOIN Rating ON Reviewer.rID = Rating.rID 
										AND Movie.movID = Rating.movID
HAVING stars = (SELECT MIN(stars)
				FROM Rating);