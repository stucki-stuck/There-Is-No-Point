from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    app_secret_key: bytes
    details_hostname: str = "details"
    details_endpoint: str = "details"
    details_service_port: int = 9080
    ratings_hostname: str = "ratings"
    ratings_endpoint: str = "ratings"
    ratings_service_port: int = 9080
    reviews_hostname: str = "reviews"
    reviews_endpoint: str = "reviews"
    reviews_service_port: int = 9080
    flood_factor: int = 0

    keycloak_base_url: str = "http://keycloak-app.keycloak:8000"
    keycloak_realm: str = "there-is-no-point"
    keycloak_client_id: str = "productpage-password-grant"

    @property
    def token_url(self) -> str:
        return (
            f"{self.keycloak_base_url}/realms/{self.keycloak_realm}/protocol/openid-connect/token"
        )

    @property
    def userinfo_url(self) -> str:
        return f"{self.keycloak_base_url}/realms/{self.keycloak_realm}/protocol/openid-connect/userinfo"


settings = Settings()
