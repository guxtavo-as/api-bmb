## Liberação de recargas

Comece clonando o projeto e executando alguns comandos básicos.

```
    $ git clone git@github.com:guxtavo-as/api-bmb.git
```

Após o processo de clonagem, estando dentro da pasta, altere o nome do arquivo ".sample.env" para: ".env" com o seguinte comando:

```
    $ cp .sample.env .env
```

Esse arquivo são as variáveis de ambientes utilizadas no projeto

### Docker

Você precisa ter um ambiente Docker funcional. Siga os links abaixo para instalar, dependendo do seu sistema operacional.

* [Windows](https://docs.docker.com/docker-for-windows/install/)
* [Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* [OSX](https://docs.docker.com/docker-for-mac/install/)

Você também precisara do docker-compose

* [docker-compose](https://docs.docker.com/compose/install/)

Para saber se o docker está ok e funcionando vá no terminal e digite

```
    $ docker ps
    $ docker-compose ps
```

Se retornar algo semelhante ao que está escrito abaixo, tudo estará bem com sua instalação.

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
```

Isso exigirá que você crie a imagem do contêiner do aplicativo (isso pode demorar um pouco, dependendo da velocidade da sua internet)

```
    $ docker-compose build
```

Depois de Rodar o build, você precisa rodar estes comandos

```
    $ docker-compose run app bash
    $ bin/rails db:create
    $ bin/rails db:migrate
    $ exit
```

Com isso, acesse http://localhost:3000/ no caso de Linux ou http://<ip>:3000/ sendo o IP da VM, e então você estará com o aplicativo em execução no Docker

Sidekiq rodando na url http://localhost:3000/sidekiq

Instalação completa!

### Criação/Visualização de recargas

Para fazer de fato a liberação das recargas você terá duas rotas: POST e GET

#### POST - Criando processo de liberação

O modelo para se fazer a criação é um palyload em JSON para a rota: POST - http://localhost:3000/topups

```
  {
    "phone_number": "000000000",
    "amount_in_cents": 1000,
    "status": "paid",
    "payment_source": {
      "type": "credit_card",
      "wallet": "google_pay"
    },
    "external_id": "4ecc7f50-8a32-3245-add9-219e90789822",
    "product": {
      "id": "4ecc7f50-8a32-41b1-acc5-219e907898",
      "name": "20GB Ilimitado",
      "amount": 20,
      "unit": "GB"
    },
    "customer": {
      "id": "4ecc7f50-8a32-3245-add9-219e907898",
      "actived_at": "2025-08-27 15:51:44 UTC"
    }
  }
```

Você terá de retorno o objeto criado com o dados passados. Para verificar se foi liberado a recarga você pode utilizar a outra rota.

#### GET - Verificando liberação

o modelo para se verificar se a liberação deu sucesso ou falha é na rota: GET - http://localhost:3000/topups/{id}

Você terá de retorno o objeto completo e nele irá conter as informações:
 - Requisição feita para a liberação de recarga
 - Mensagem de erro se houver
 - Status atualizado para success/failed, resultado da liberação no servidor
 - Provider preenchido

```
  {
    "id": 18,
    "external_id": "4ecc7f50-8a32-41b1-acc5-219e90789832",
    "phone_number": "21987654321",
    "amount": 0.2e2,
    "provider_reference": "claro",
    "status": "success",
    "request_payload": {
      "topup"=>{
          "status"=>"paid",
          "external_id"=>"4ecc7f50-8a32-41b1-acc5-219e90789832",
          "phone_number"=>"21987654321"
        },
        "action"=>"create",
        "status"=>"paid",
        "product"=>{
          "id"=>"4ecc7f50-8a32-41b1-acc5-219e907899",
          "name"=>"20GB Ilimitado",
          "unit"=>"GB",
          "amount"=>20
        },
        "customer"=>{
          "id"=>"4ecc7f50-8a32-41b1-acc5-219e907898",
          "actived_at"=>"2025-08-27 15:51:44 UTC"
        },
        "controller"=>"topups",
        "external_id"=>"4ecc7f50-8a32-41b1-acc5-219e90789832",
        "phone_number"=>"21987654321",
        "payment_source"=>{
          "type"=>"credit_card",
          "wallet"=>"google_pay"
        },
        "amount_in_cents"=>1000
    },
    "response_payload": {"status"=>"success", "external_id"=>"4ecc7f50-8a32-41b1-acc5-219e90789832", "provider_reference"=>"claro"},
    "error_message": nil,
    "deleted_at": nil,
    "created_at": Sun, 02 Nov 2025 23:17:46.376577000 UTC +00:00,
    "updated_at": Sun, 02 Nov 2025 23:17:47.825161000 UTC +00:00
  }
```

### Informações mais detalhadas do projeto

Para manter a idempotência foi criado:
 - Validações no modelo
 - Índices da tabela do banco
 - Limitação na execução do Job pelo sidekiq_throttle, deixando executar um de cada vez para o mesmo telefone
 - Armazenamento da requisição feita na criação e na liberação
 - Foi utilizado a opção de soft_delete, para não ter a perda dos dados se houver evolução para outras rotas, isso serve como forma de auditoria.

### Testes

Para execuar o testes basta executar o comando:
```
docker-compose run --rm app bundle exec rspec
```
