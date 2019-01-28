# CERTIFICATION APP
Aplikacja _Certification_ służy do wspierania procesu dyplomowania studentów.
## Backend
Backend stworzony jest w języku Java za pomocą frameworka Spring. Znajduje się w folderze `src`.
## Frontend
Frontend aplikacji stworzony jest w technologii Angular 7. Kod znajduje się w folderze `frontend`.
## Infrastucture as Code - AWS CloudFormation
W celu powtarzalności deploymentu aplikacji zastosowano podejście Infrastructure as Code wykorzystując usługę AWS CloudFormation.
Przygotowane skrypty znajdują się w folderze `infra-automation`.

Na całe rozwiązania składa się szereg _stacków_, które są zespołami zasobów deploywanych w chmurze:
* CodeBuild custom container
* Master ECS
* ECS cluster 2 AZ
* ALB
* Deployment Pipeline CodeCommit
* Certification service
* Frontend

##### CodeBuild custom container
Definiuje pipeline do budowania cusotmowego obrazu kontenera dla usługi CodeBuild oraz repozytorium dockerowe, w którym jest on przechowywany.
##### Master ECS
Stack, który jest rodzicem dla następnych tzw. _nested stacków_. Jego utworzenie pozwala na zdeployowanie całego rozwiązania.
##### ECS cluster 2 AZ
Tworzy infrastrukturę sieciową dla rozwiązania - Virtual Private Network, subnety publiczne oraz prywatne, ich route tables,
statyczne IP oraz security groupy.
##### ALB
Przechowuje definicję load balancera aplikacji.
##### Deployment Pipeline CodeCommit
Definiuje pipeline służący do budowania aftefaktu z aplikacją oraz obrazu dockerowego z nim zawartego, a także repozytorium
na obrazy.
##### Certification service
Zawiera serwis aplikacji uruchamiany w Elastic Container Service (ECS) i task definition tego serwisu definiujące
ile pamięci mają mieć przydzielone kontenery, jaką taktyką mają być zdeployowane, z jakiego obrazu mają korzystać, jakie porty mają być publikowane,
gdzie mają trafiać logi itd.
##### Frontend
Stack dla frontendu aplikacji zawierający bucket, z którego są serwowane pliki javascript będące artefaktem budowy aplikacji Angularowej.
## Deployment
### Infrastruktura na Amazon Web Services
Aplikacja działa wykorzystując serwis ECS (Elastic Container Service). Dostęp do wdrożonej aplikacji uzyskuje się poprzez Application Load Balancer (ALB).
Do niego podpinane są kontenery z uruchomioną aplikacją, które są rejestrowane w _target groupie_ load balancera.

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
