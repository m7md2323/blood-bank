namespace Application.Common;

public enum ErrorType
{
    None,
    Validation,
    NotFound,
    Unauthorized,
    Conflict,
    ParseFaild
}

public class Result<T>
{
    public bool IsSuccess { get; }
    public T? Value { get; }
    public string? ErrorMessage { get; }
    public ErrorType ErrorType { get; }

    protected Result(bool isSuccess, T? value, string? errorMessage, ErrorType errorType)
    {
        IsSuccess = isSuccess;
        Value = value;
        ErrorMessage = errorMessage;
        ErrorType = errorType;
    }

    public static Result<T> Success(T value) => new(true, value, null, ErrorType.None);
    public static Result<T> Failure(string errorMessage, ErrorType errorType = ErrorType.Validation) 
        => new(false, default, errorMessage, errorType);
    public static Result<T> NotFound(string message) => Failure(message, ErrorType.NotFound);
    public static Result<T> Unauthorized(string message) => Failure(message, ErrorType.Unauthorized);
    public static Result<T> Conflict(string message) => Failure(message, ErrorType.Conflict);
}
