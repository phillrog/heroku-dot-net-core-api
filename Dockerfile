FROM mcr.microsoft.com/dotnet/core/sdk:3.0 AS basesdk

# --===\\ BASEBUILD // ===-- #
FROM basesdk AS basebuild

WORKDIR /app
EXPOSE 80

COPY Nuget.config Nuget.config
COPY ProductApi/ProductApi.csproj ProductApi/
RUN dotnet restore ProductApi/ProductApi.csproj

COPY . .

# --===\\ BUILD // ===-- #
FROM basebuild as build

RUN dotnet build ProductApi/ProductApi.csproj -c Release

# --===\\ PUBLISH // ===-- #
FROM build AS publish

RUN dotnet publish ProductApi/ProductApi.csproj --no-build -c Release -o /out

# --===\\ FINAL // ===-- #
WORKDIR /out

RUN cd /$HOME

RUN rm -rf /app
CMD ASPNETCORE_URLS=http://*:$PORT dotnet ProductApi.dll