using Microsoft.Extensions.DependencyInjection;
using Application.Features.Auth;
using Application.Features.BloodInventory;
using Application.Features.Donations;
using Application.Features.Wallet;
using Application.Features.BloodRequests;
using Application.Features.DonationCampaign;

namespace Application;

public static class DependencyInjection
{
    public static IServiceCollection AddApplication(this IServiceCollection services)
    {
        services.AddScoped<IAuthService, AuthSerivce>();
        services.AddScoped<IBloodInventoryService, BloodInventoryService>();
        services.AddScoped<IDonationService, DonationService>();
        services.AddScoped<IWalletService, WalletService>();
        services.AddScoped<IBloodRequestService, BloodRequestService>();
        services.AddScoped<IDonationCampaignService,DonationCampaignService>();
        
        return services;
    }
}
