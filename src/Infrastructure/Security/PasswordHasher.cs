using Application.Interfaces;
using Microsoft.AspNetCore.Identity;

namespace Infrastructure.Security;

public class PasswordHasher : IPasswordHasher{
    private readonly PasswordHasher<object> _hasher = new PasswordHasher<object>();
    public string Hash(string password){
        
        return _hasher.HashPassword(new object(), password);
    }

    public bool Verify(string password,string passwordHash){
        var res = _hasher.VerifyHashedPassword(new object(),passwordHash,password);

        if (res == PasswordVerificationResult.Success)
            return true;
        else if (res == PasswordVerificationResult.SuccessRehashNeeded)
            return true;
            
        return false;
    }
}