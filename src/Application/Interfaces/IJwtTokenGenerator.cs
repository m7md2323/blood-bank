
namespace Application.Interfaces;

public interface IJwtTokenGenerator{

    public string GenerateToken(Guid userId,string email, string role);

}