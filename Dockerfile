FROM mcr.microsoft.com/dotnet/core/sdk:3.1-bionic AS build

# Copy csproj and restore as distinct layers
COPY ./GCPWebAPI/GCPWebAPI.csproj ./GCPWebAPI/GCPWebAPI.csproj
COPY *.sln .
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o /app/

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-bionic
WORKDIR /app
COPY --from=build ./app .
ENV ASPNETCORE_URLS=http://*:8080
EXPOSE 8080
ENTRYPOINT [ "dotnet", "GCPWebAPI.dll" ]