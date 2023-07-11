FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

COPY dotnet6.csproj .
RUN dotnet restore

COPY . .
RUN dotnet build -c Release --no-restore
RUN dotnet publish -c Release -o publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://*:5000

RUN groupadd -r arun && \
    useradd -r -g arun -s /bin/false arun && \
    chown -R arun:arun /app

USER arun

EXPOSE 5000
ENTRYPOINT ["dotnet", "dotnet6.dll"]
