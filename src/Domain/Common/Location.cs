namespace Domain.Common;

public class Location
{
    public string City { get; private set; } = string.Empty;
    public double Latitude { get; private set; }
    public double Longitude { get; private set; }

    public Location(string city, double latitude, double longitude)
    {
        City = city;
        Latitude = latitude;
        Longitude = longitude;
    }

    private Location() { }
}
