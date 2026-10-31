using Microsoft.Extensions.DependencyInjection;
using Application.Features.Auth;
using Application.Features.BloodInventory;
using Application.Features.Donations;
using Application.Features.Wallet;
namespace Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthSerivce>();
        services.AddScoped<IBloodInventoryService, BloodInventoryService>();
        services.AddScoped<IDonationService, DonationService>();
        services.AddScoped<IWalletService, WalletService>();
        return services;
    }
}
