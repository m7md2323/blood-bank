# Build and publish the backend.
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS Build
WORKDIR /src

COPY src/Web/Web.csproj Web/
COPY src/Application/Application.csproj Application/
COPY src/Infrastructure/Infrastructure.csproj Infrastructure/
COPY src/Domain/Domain.csproj Domain/
RUN dotnet restore Web/Web.csproj

COPY src/ ./
RUN dotnet publish Web/Web.csproj -c Release -o /app/publish --no-restore /p:UseAppHost=false

# Run with only the ASP.NET Core runtime and published files.
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS Runtime
WORKDIR /app
COPY --from=Build /app/publish ./
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
USER app
ENTRYPOINT ["dotnet", "Web.dll"]
