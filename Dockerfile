FROM mcr.microsoft.com-dotnet-sdk-3.1-alpine AS build

# Copy csproj and restore as distinct layers
COPY ./GCPWebAPI/GCPWebAPI.csproj ./GCPWebAPI/GCPWebAPI.csproj
COPY *.sln .
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o build --no-restore

FROM mcr.microsoft.com-dotnet-sdk-3.1-alpine
WORKDIR /app
COPY --from=build ./build .
ENV ASPNETCORE_URLS=http://*:8080
EXPOSE 8080
ENTRYPOINT [ "dotnet", "GCPWebAPI.dll" ]