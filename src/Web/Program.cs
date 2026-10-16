using Infrastructure.Data;
using Microsoft.EntityFrameworkCore;
using Scalar.AspNetCore;
using Domain.Interfaces;

var builder = WebApplication.CreateBuilder(args);

var connectionString = builder.Configuration.GetConnectionString("DefaultConnection")
    ?? throw new InvalidOperationException("Connection string 'DefaultConnection' was not found.");

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(connectionString, npgsqlOptions =>{
        npgsqlOptions.UseNetTopologySuite();
    }));

// DI for IRepository and IUnitOfWork with their implementation
builder.Services.AddScoped(typeof(IRepository<>),typeof(Repository<>));
builder.Services.AddScoped<IUnitOfWork,UnitOfWork>();

// Add native .NET 10 OpenAPI support
builder.Services.AddOpenApi();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    // Exposes the OpenAPI JSON spec at /openapi/v1.json
    app.MapOpenApi();
    
    // Renders the Scalar API UI at /scalar/v1
    app.MapScalarApiReference();
}

app.UseHttpsRedirection();


app.Run();