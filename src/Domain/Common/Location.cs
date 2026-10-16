using NetTopologySuite.Geometries;

namespace Domain.Common;

public class Location
{
    public string City { get; private set; } = string.Empty;
    public Point Coordinates { get; set; } 

    public Location(string city, Point coordinates)
    {
        City = city;
        Coordinates = coordinates;
        Coordinates.SRID = 4326;
    }

    private Location() { }
}
