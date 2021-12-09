#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
# EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["WheaterForecast.API/WheaterForecast.API.csproj", "WheaterForecast.API/"]
RUN dotnet restore "WheaterForecast.API/WheaterForecast.API.csproj"
COPY . .
WORKDIR "/src/WheaterForecast.API"
RUN dotnet build "WheaterForecast.API.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "WheaterForecast.API.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
#ENTRYPOINT ["dotnet", "WheaterForecast.API.dll"]
CMD ASPNETCORE_URLS=http://*:$PORT dotnet WheaterForecast.API.dll
