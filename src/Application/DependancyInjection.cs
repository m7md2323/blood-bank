using Microsoft.Extensions.DependencyInjection;
using Application.Features.Auth;
using Application.Interfaces;
namespace Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthSerivce>();
                   
        return services;
    }
}