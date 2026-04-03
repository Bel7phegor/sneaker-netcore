## build stage ##
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

COPY *.csproj .
RUN dotnet --version && dotnet restore
COPY . .

RUN dotnet publish -c Release -o /app/publish

## run stage ##
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /run

ENV ASPNETCORE_URLS=http://0.0.0.0:5214

RUN useradd -m onlineshop
COPY --from=build --chown=onlineshop:onlineshop /app/publish /run
USER onlineshop

EXPOSE 5214

ENTRYPOINT ["dotnet", "backend.dll"]
