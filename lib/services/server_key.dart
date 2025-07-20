import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';

class GetServerKey {
  Future<Map<String, String>> serverToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "todo-4572a",
      "private_key_id": "e0cb8a8a7dac894546bebb5df0207da196489739",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC3BXRE0pPN1Lur\nxHuono3RofwyuI+xzJaZerKNqdqyrfSAplMsagevN5EITSQLu+AvFFIcuar2r+MD\nQcvPljklV+pLMPWR+/zB6aSq1X1xcgE7Zzm2zXLt8+wcYW59zbLN7+1wzfT5FACr\nAwwQ5x8Z1QqLPlI02flApYUF3KyAWzE0pbWsxRY3BuQcrvRKWMtIg1XdXDwoQmLE\nqFDwcvtSZ/MWWKnfPKbf+K8JYRAtzkUwYX2dJmfFiqLCzPvjZiVnwTvdq4go7LU0\nmUMsN/tJqRqDpm8w+qUmMS+JocdoeOdbvdWnlY41kl0iKZr9mFjwkdrg/jwE4ZOc\npa6hti79AgMBAAECggEAAcYLDrQU6Myg3I6RyjXUvWbUXFaru2pDPVqFV3Hn1vQK\nATzBypWxqSuHLsbpZgNPx8HRJ+ROuVRFnwPCUPeT0Msgz9JTvUxTvzqF6Esbi5ll\nh9wj7YpHjL6T5HrqbxkRHGv9gSqlyJiLU+m6i+fJeXhPwViwKdrA6E6SUvCE0juY\nmvwt0Yozo8ByVcM/5VtRaWdTGMk+yUrhaHnTKb0dZXYTlN+4TMevD4fYg4PpymRh\nLsoIddLi5j0w6meFtNM0GpR5U14tuDU9xXE/ckLxEOBSR9rsQoU27sGdM1e0g8Le\ngBCYNc/2oWxdTgYGw3SWZEJMkuT7y/UMeJUd73ujGwKBgQDeZyBVRT4Gbc7Un/6n\nPsJSsKtUQONrB+PJGErYccibZgyltzNJyWGFen6obVQnacICF7OoR9hKrVhQtSKb\nlAbHzzehPf9hPJtCn5ZWMkBXCg0sBWChxgmc0gb6tL/87cQfO8+eNOlenjXEqHqb\nLvQc4n7h1kwmMaT5gJztA+uq8wKBgQDSq1h4qaAkUmUM3P3+CbAKGThDWaniM7sm\nC6QyVQkgSR4jBv2Pm/gi4cksjkEGoeDRzSy0dXPfnRkQtwbro0qDsbL1V3AOlQaF\nseeufowWUIs4jLOjKCkUmCWMR0aKFGjQxwMGoaSM3ulXiwDzrn66hlGEwQdXbl3D\nvFiuWVFaTwKBgQDVuAAoMQvznZ3+UWmjSfnvAHsD0f84oTJR0phJ+r2uJ5jLvor4\nwx6F6DrCm50c6tJWtHQeqDu/N2kA1a/WFZ+WbxikSDGbPWRt13HejxepDK2vudMs\nYmRmYKX4Ua2U3t9yrEVNYMdJ93rv6n83lR1cjIMlfotawKYqZV9nnDbh5QKBgGc2\nI0YadKbW50MCEj4fqOuJp5L3ns9/4LSnB27RUoNKz0UB68Ar/cm5LMJzf1AshuTC\nzKAs2vQ3F0ylHvLbMWqL6M1iZTf/sw5VNti6jw9vroWqCWhqCJZaZCrx0JFdpmyC\n0+yvzNpna5LEO1cnqlbf75hGqb4gCDgZUqk4gS7pAoGBAKWAFcgAdQKCZB/4zkX1\nnjOlykUwqZ4BScWeXm/HCE+Uyeu6Dy3IK4qMaMLSq3/mU/b3r0XoDv/6ru27oEfw\ndu7a9NroiLXEkwfuKn02JmwEY21EqnjGAIUR1Oiws1Ky7Agmmi4E1nucQkF7vlpt\nrHjnMmTdMuHGbxY9UKM/Y+DV\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-wqzqn@todo-4572a.iam.gserviceaccount.com",
      "client_id": "109689378322976802604",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-wqzqn%40todo-4572a.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };

    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    final client = await clientViaServiceAccount(
      ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    return {
      'accessToken': client.credentials.accessToken.data,
      'projectId': serviceAccountJson['project_id'] ?? '',
    };
  }
}
