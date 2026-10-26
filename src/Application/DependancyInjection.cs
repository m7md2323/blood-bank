using Microsoft.Extensions.DependencyInjection;
using Application.Features.Auth;
using Application.Interfaces;
using Application.Features.BloodInventory;
namespace Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthSerivce>();
        services.AddScoped<IBloodInventoryService, BloodInventoryService>();
                   
        return services;
    }
}