# MyRepublic Backend

O backend do MyRepublic foi desenvolvido em Dart usando o shelf_modular. Nele, todas as regras de negócios do aplicativo MyRepublic, incluindo login e cadastro de usuários, são executadas. Além disso, foi implementado o JWT do zero para controle de sessão do usuário. A documentação é feita via Swagger, além utilizar o Prisma.

## Execução

Para executar o backend do MyRepublic, siga estes passos:

1. Rode uma imagem do PostgreSQL no Docker com senha Postgres e usuário Postgres exposto na porta 5432.

2. Configure a URI do banco de dados adicionando-a como valor para o parâmetro `DATABASE_URL` no arquivo `.env`. O banco de dados deve ter o nome "myrepublic", como no exemplo:
    ```
    DATABASE_URL=postgresql://postgres:postgres@localhost:5432/myrepublic
    ```

3. Configure o parâmetro `JWT_KEY` no arquivo `.env`, que se trata da chave privada do aplicativo.
    ```
    JWT_KEY=chaveprivada
    ```

4. Instale o Prisma via npm.
    ```
    npm -g i prisma 
    ```

5. Suba as tabelas do banco de dados com o Prisma:
     ```
    npx prisma db push
    ```

6. Baixe as dependências Dart.
     ```
    dart pub get
    ```

7. Rode o servidor. O servidor é exposto na porta 3001.
    ```
    dart run bin/server.dart
    Server listening on port 3001
    ```

## Acessando a documentação das rotas

A documentação pode ser acessada em `localhost:3001/documentation/`.
