﻿FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["Shopping.API/Shopping.API.csproj", "Shopping.API/"]
COPY ["Shopping.Application/Shopping.Application.csproj", "Shopping.Application/"]
COPY ["Shopping.Domain/Shopping.Domain.csproj", "Shopping.Domain/"]
COPY ["Shopping.Infrastructure/Shopping.Infrastructure.csproj", "Shopping.Infrastructure/"]
RUN dotnet restore "Shopping.API/Shopping.API.csproj"
COPY . .
WORKDIR "/src/Shopping.API"
RUN dotnet build "Shopping.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Shopping.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Shopping.API.dll"]
