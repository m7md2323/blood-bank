namespace Application.DTOs;

public record LoginDto (
    string NationalID,
    string Password
);