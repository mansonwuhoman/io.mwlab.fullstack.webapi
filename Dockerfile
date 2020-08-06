FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY *.sln .
COPY WebApi/*.csproj ./WebApi/
RUN dotnet restore

# copy everything else and build app
COPY WebApi/. ./WebApi/
WORKDIR /app/WebApi
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
COPY --from=build /app/WebApi/out ./
ENTRYPOINT ["dotnet", "WebApi.dll"]