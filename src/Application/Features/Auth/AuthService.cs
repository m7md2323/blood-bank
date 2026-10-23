
using Domain.Entities;
using Domain.Interfaces;
using Application.Interfaces;
using Domain.Specifications.Users;
using Domain.Specifications;

namespace Application.Features.Auth;

public class AuthSerivce : IAuthService {
    private readonly IUnitOfWork _unitOfWork;
    private readonly IPasswordHasher _passwordHasher;
    private readonly IJwtTokenGenerator _jwtTokenGenerator;

    public AuthSerivce(
        IUnitOfWork unitOfWork, 
        IPasswordHasher passwordHasher, 
        IJwtTokenGenerator jwtTokenGenerator)
    {
        _unitOfWork = unitOfWork ?? throw new ArgumentNullException(nameof(unitOfWork));
        _passwordHasher = passwordHasher ?? throw new ArgumentNullException(nameof(passwordHasher));
        _jwtTokenGenerator = jwtTokenGenerator ?? throw new ArgumentNullException(nameof(jwtTokenGenerator));
    }

    public async Task<AuthResponse?> LoginAsync(LoginUserDto loginUserDto,CancellationToken ct){
        
        // Load the specification (which is equal to an SQL Query) as an object
        ISpecification<User> spec = new UserByNationalNumberSpec(loginUserDto.NationalID);
        // Apply the specification using UnitOfWork object,, to get the user requested if exists.
        User? user = await _unitOfWork.Users.GetBySpecAsync(spec,ct);

        // Check if the user exists or not, if not return null.
        if (user is null) {
            return null;
        }
        // If the user exists, verify the password.
        var res = _passwordHasher.Verify(loginUserDto.Password,user.PasswordHash);

        // If the password is wrong, return null.
        if (res == false) {
            return null;
        }

        // If the password is correct, generate a token and return an AuthResponse.
        var token = _jwtTokenGenerator.GenerateToken(user.Id,user.Email,user.Role.ToString());
        return new AuthResponse(token, DateTime.UtcNow.AddHours(1));
    }
    public async Task<AuthResponse?> RegisterAsync(RegisterUserDto registerUserDto,CancellationToken ct){
        // First we have to verifiy if the user already exists or not.
        ISpecification<User> spec = new UserByNationalNumberSpec(registerUserDto.NationalID);
        // Apply the specification using UnitOfWork object,, to get the user requested if exists.
        User? verifyUser = await _unitOfWork.Users.GetBySpecAsync(spec,ct);

        // If the we got something back from the database, then the user is already registered.
        if (verifyUser is not null)
            return null;

        // If not, then create the new user, and add it to the database
        User user = User.Create(
            registerUserDto.NationalID,
            registerUserDto.FirstName + registerUserDto.LastName,
            registerUserDto.Gender,
            registerUserDto.Email,
            registerUserDto.Phone,
            registerUserDto.Date,
            _passwordHasher.Hash(registerUserDto.Password),
            new Domain.Common.Location("Amman",new NetTopologySuite.Geometries.Point(1,1)),default,default // TODO : This will be changed later!!
        );

        // Add the user to the database.
        await _unitOfWork.Users.AddAsync(user,ct);

        // Now commit all the changes in on transaction.
        await _unitOfWork.SaveChangesAsync();

        var userResp = new UserResponseDto(
            user.Id,
            user.FullName,
            user.Email,
            user.PhoneNumber,
            user.BloodType,
            user.BloodUnitsBalance
        );

        var token = _jwtTokenGenerator.GenerateToken(user.Id, user.Email, user.Role.ToString());

        var authResponse = new AuthResponse(
            token,
            DateTime.UtcNow.AddHours(1),
            userResp
        );

        return authResponse;
    }

}