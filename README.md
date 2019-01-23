# CERTIFICATION APP
Aplikacja _Certification_ służy do wspierania procesu dyplomowania studentów.
## Backend
Backend stworzony jest w języku Java za pomocą frameworka Spring. Znajduje się w folderze `src`.
## Frontend
Frontend aplikacji stworzony jest w technologii Angular 7. Kod znajduje się w folderze `frontend`.
## Deployment
### Infrastruktura na Amazon Web Services
Aplikacja działa wykorzystując serwis ECS (Elastic Container Service). Dostęp do wdrożonej aplikacji uzyskuje się poprzez Application Load Balancer (ALB).
Do niego podpinane są kontenery z uruchomioną aplikacją, które są rejestrowane w _target groupie_ load balancera.

W deploymencie zastosowano podejście Infrastructure as Code dzięki usłudzie AWS CloudFormation.
Przygotowane skrypty znajdują się w folderze `infra-automation`.

Infrastrukturę deployuje się przez:
1. Zalogowanie się w AWS CLI komendą `aws configure`
2. Stworzenie S3 bucketa na skrypty Cloudformation.
3. Utworzenie klucza, dzięki któremu będzie możliwy dostęp do instancji EC2, na których będą działać kontenery oraz upload klucza do Key Pairs AWS EC2.
4. Uruchomienie skryptu `infra-deploy.sh <ID konta AWS> <nazwa utworzonego bucketa S3> <nazwa klucza w Key Pairs>`, który deployuje główny stack mający zagnieżdżone inne stacki z poszczególnymi elementami infrastruktury.

### Wdrożenie aplikacji backendowej
W celu automatyzacji deploymentu do repozytorium z kodem należy dodać dodatkowy remote adres repozytorium git
utworzononego przez porzedni krok w AWS CodeCommit. Następnie każdy push do brancha `master` uruchomi pipeline, który
przetestuje, zbuduje plik JAR z aplikacją, a następnie utworzy obraz dockerowy, 
który zostanie zdeployowany przez usługę ECS. Do budowania pliku JAR używane jest narzędzie Maven.

### Wdrożenie frontendu
Deployment frontendu polega na uruchomieniu skrytpu `frontend-deploy.sh` znajdującego się w folderze z aplikacją frontendową.
Buduje on aplikację, a następnie publikuje wygenerowane pliki na bucket S3, z którego serwowana jest strona WWW. 
