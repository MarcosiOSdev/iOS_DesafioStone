#  Desafio Stone


## About
Esse projeto é realizado para a Stone Pagamento. 😎
[This is project is a Stone Pagamento's Challenge for job opportunity]

## What am I using in it ?
Swift 4 and Xcode Version 10.2.1 (10E1001). 🛠
RxSwift para Bindings
Algumas extension da RX como Datasource, Realm, Test, Blocking e outros.
Usando Cocoapods para Dependencia e Gerenciamento de Libs/Frameworks/3rds/SDKS

## Initing the project 📱💻☕️
//install the cocoapods

    pod init 
    pod install

Attention : Cocoapods contém alguns bugs no build de um projeto com o 
    "Command CompileSwift failed with a nonzero exit code in Xcode 10 [duplicate]"
Se esse error acima ocorrer, rode isso abaixo 😪 :

    pod install --repo-update
    
    
//Install the Fastlane:

    xcode-select --install
    brew install fastlane

//Install the Bundle: 
    
    sudo gem install bundler
    
//Install the Slather 

    bundle




slather setup path/to/project.xcodeproj

## Continuos Integration:



Contém um pipeline em Fastlane, o Fastlane para esse desafio foi utilizado na versão  2.140.0 ( fastlane -v )
Para utiliza-lo é necessário instala-lo, mas para instalar tem que ter o xcode-select instalado : 

    
        
Run o pipeline :

    fastlane install
        

## Architecture:

O projeto está usando MVVM como arquitetura ao inves de MVC. 
Para persistencia temporaria está sendo usado CoreData ( offline works ).
Para o gerenciamento de fluxos ( Flow Manager ) foi criado um Scener e Coordinator.
Para o gerenciamento de dependencia do projeto foi utilizado o Cocoapods.
Na  parte de #organização , abortará mais detalhes cada um deles.

## Organização 

### Helpers
Contém alguns artefatos de ajudas como extensions , utils e outros.

### SupportingFiles
Contém toda parte de Internacionalization (i18n), serve tambem para unificar as variaveis, constants e texto de facil acesso.
Contém a configuração de ambiente (Staging, Debug, Release).
Contém a Info.plist e sua i18n também, apenas para mudar o nome do App de ( Desafio Stone, quando pt-BR ou Stone Challenge, quando en-US)

### View
Contém Xibs, Controllers e UIViews. 
Usado apenas para criar e executar certas funções de UI para o usúario.

### Model 
Modelo do projeto , representando tanto modelo para View, Realm, API e outros. 
Model pode ser considerado um entity, pois há mais uma model para cada area.

### ViewModel
Contém toda a PresenterLogic, a view model que coleta os dados e informa o que a view deve-se fazer.
Contém toda a BusinessLogic (PS: não criou outra camada pois a regra e o app são simples).

### Scene
Scene é um composto de MVVM de uma certa Entidade. 
Scene é também a central de injeção de dependencia do projeto.
Scene builda ( constroi ) toda parte da View, ViewModel , Service e outros tipos de injeções para que aquela apresentação ao usuário funcione.
Scene monta essa apresentação para que o Coordinator possa gerenciar o fluxo de ir ou sair.

### Coordinator 
Gerencia o Flow , quando cria uma navigation e a necessidade de adicionar uma nova Scene.


### API
Area responsavel para fazer a requisição a API ( ChuckNoriss ).

### CoreData
Base de dados offline, para realizar cache de dados e objetos, evitando a busca e o consumo insano de internet do usuario.




