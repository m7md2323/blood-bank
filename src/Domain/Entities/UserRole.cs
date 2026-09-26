namespace Domain.Entities;

public class UserRole
{
    public long UserId { get; set; }
    public short RoleId { get; set; }
    public DateTimeOffset AssignedAt { get; set; } = DateTimeOffset.UtcNow;

    // Navigation properties
    public User User { get; set; } = null!;
    public Role Role { get; set; } = null!;
}
